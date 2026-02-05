import 'package:admin/global/Variables.dart';
import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

part 'create_driver_event.dart';
part 'create_driver_state.dart';

class CreateDriverBloc extends Bloc<CreateDriverEvent, CreateDriverState> {
  CreateDriverBloc() : super(CreateDriverInitial()) {
    on<CreateDriverSubmitEvent>((event, emit) async {
      try{
        emit(CreateDriverLoadingState());
        if(event.FirstName.isEmpty || event.LastName.isEmpty || event.LicenceNumber.isEmpty || event.Password.isEmpty || event.VehicleNumber.isEmpty){
          throw("Fill All Feilds to Continue");
        }
        bool DocExists= await Drivers.doc(event.VehicleNumber.toString().toUpperCase()).get().then((value){
          return value.exists;
        });
        if(DocExists){
          emit(CreateDriverErrorState(Error: "A Driver With This Vehicle Is Already Registerd"));
        }
        else{
          emit(CreateDriverAddStopsState(FirstName: event.FirstName, LastName: event.LastName, LicenceNumber: event.LicenceNumber, Password: event.Password, VehicleNumber: event.VehicleNumber));
        }
      }
      catch(error){
        emit(CreateDriverErrorState(Error: error.toString()));  
      }
    });

    on<CreateDriverErrorEvent>((event, emit){
      emit(CreateDriverErrorState(Error: event.Error.toString()));
    });
  }
}
