import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:admin/global/Variables.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomePageAddPolylineEvent>((event, emit) async {
      try{
        await firebaseFirestore.collection("route").doc(event.DriverUsername).get().then((value) async {
          print(value.data()!.length);
          if(value.data()!.length>2){
            List<LatLng> route = [];
            GeoPoint geoPoint;
            for(int i=1;i<value.data()!.length;i++){
              geoPoint = value.get(i.toString());
              route.add(LatLng(geoPoint.latitude, geoPoint.longitude));
            }
            
            LatLng driverLatLang = await firebaseFirestore.collection("Drivers").doc(event.DriverUsername).get().then((value){
              return LatLng(double.parse(value.get("latitude")) ,double.parse(value.get("langitude")));
            });
            emit(HomePageAddPolylinState(route: route,cameraUpdateLatLang:driverLatLang));
            }
          else{
            throw("Sorry But We dont Have This Bus Route Yet");
          }
          });
        
      }
      catch(error){
        print(error.toString());
        emit(HomePageErrorState(ErrorMessage: error.toString()));
      }
    });

    on<HomePageGetUserLocationPermissionEvent>((event, emit) async {
      emit(HomePageLoadingState(Message: "Fetching Your Location..."));
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
      emit(HomePageGetUserLocationPermissionSuccessState());
      }
      catch(error){
        emit(HomePageErrorState(ErrorMessage:error.toString()));
      }
    });

    on<HomePageStartUserLocationStreamEvent>((event, emit) async {
      // emit(HomePageLoadingState(Message: "Fetching Your Location..."));
      try{
        await Geolocator.getCurrentPosition().onError((error, stackTrace){
          throw(error.toString());
        });
        emit(HomePageStartUserLocationStreamState());
      }
      catch(error){
        if(error.toString().contains("The location service on the device is disabled.")){
            emit(HomePageErrorState(ErrorMessage: "Gps is Disabled, Please Enable it to Get Your Live Location."));
        }
        else{
          emit(HomePageErrorState(ErrorMessage: error.toString()));
        }
      }
    });
    
    on<HomePageErrorEvent>((event, emit){
      emit(HomePageErrorState(ErrorMessage: event.errorMessage));
    });

  }
}
