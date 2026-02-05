import 'package:admin/global/Variables.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

part 'add_stops_event.dart';
part 'add_stops_state.dart';

class AddStopsBloc extends Bloc<AddStopsEvent, AddStopsState> {
  AddStopsBloc() : super(AddStopsInitial()) {
    on<AddStopsGetPositionPermissionEvent>((event, emit) async {
      try{
        await Geolocator.checkPermission().then((value) async {
        if (value == LocationPermission.deniedForever) {
          throw("Permission Denied Location permission Are Denied ForEver, Please Chnage them from App Settings");
        } 
        else if (value == LocationPermission.denied) {
          await Geolocator.requestPermission().then((value) async {
            if (value == LocationPermission.deniedForever) {
              throw("Permission Denied Location permission Are Denied ForEver, Please Chnage them from App Settings");
            } 
            else if (value == LocationPermission.denied) {
              throw("Permission Denied Location permission Denied, Cant't Access Location");
            }
          });
        }
      });
      emit(AddStopsGotAdminPositionPermissionSuccessState());
      }
      catch(error){
        emit(AddStopsErrorState(error:error.toString()));
      }
    });
    on<AddStopsGetAdminCurrentPositionEvent>((event, emit) async {
       emit(AddStopsLoadingState(Message: "Fetching Your Location..."));
      try{
        LatLng currentPosition = await Geolocator.getCurrentPosition().then((value) => LatLng(value.latitude, value.longitude));
        emit(AddStopsGotAdminLocationState(currentPosition:currentPosition));
      }
      catch(error){
        AddStopsErrorState(error: error.toString());
      }
    });
    on<AddStopsUpdateMarkersEvent>((event, emit){
      emit(AddStopsUpdateMarkersState());
    });
    on<AddStopsAddedEvent>((event, emit) async {
      List<Marker> stopList=[];
      event.stopsList.forEach((element) {
          if(element.markerId!=MarkerId("Adder")&&element.markerId!=MarkerId("User")){
            stopList.add(element);
          }
      });
      if (stopList.length<2){
        emit(AddStopsErrorState(error: "Add At Least Two or More Stops To Continue"));
      }
      else{
        emit(AddStopsLoadingState());
        print("hello-------------------------------------------------------");
        event.driverDetails.containsKey("Vehicle Number");
        String VehicleNumber = event.driverDetails["Vehicle Number"];
        await firebaseFirestore.collection("Drivers").doc(VehicleNumber)
        .set(event.driverDetails);
        Map<String,dynamic> stops={};
        for (int i = 0; i<stopList.length; i++){
          stops.addEntries({MapEntry(i.toString(),stopList[i].markerId.value)});
        }
        stops.addEntries({MapEntry("IsGoingToTheEnd", true),MapEntry("DrivingAllowed", true),MapEntry("IsOn", false)});
        await firebaseFirestore.collection("Stops").doc(VehicleNumber).set(stops);
        await firebaseFirestore.collection("route").doc(VehicleNumber).set({});
        emit(AddStopsDriverCreatedSuccessfullyState());
      }
    });
  }
}
