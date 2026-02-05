part of 'create_driver_bloc.dart';

sealed class CreateDriverEvent {}

class CreateDriverSubmitEvent extends CreateDriverEvent {
  late String FirstName;
  late String LastName;
  late String LicenceNumber;
  late String VehicleNumber;
  late String Password;

  CreateDriverSubmitEvent({
    required this.FirstName,
    required this.LastName,
    required this.LicenceNumber,
    required this.Password,
    required this.VehicleNumber,
  });
}

class CreateDriverErrorEvent extends CreateDriverEvent {
  late String Error;

  CreateDriverErrorEvent({required this.Error});
}

class CreateDriverStopsAddedEvent extends CreateDriverEvent{
  List<Marker> stopList;
  CreateDriverStopsAddedEvent({required this.stopList});
}