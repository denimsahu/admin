part of 'create_driver_bloc.dart';

@immutable
sealed class CreateDriverState {}

final class CreateDriverInitial extends CreateDriverState {}

class CreateDriverLoadingState extends CreateDriverState{}


class CreateDriverErrorState extends CreateDriverState{
  late String Error;
  CreateDriverErrorState({required this.Error});
}

class CreateDriverAddStopsState extends CreateDriverState{
   late String FirstName;
    late String LastName;
    late String LicenceNumber;
    late String VehicleNumber;
    late String Password;

    CreateDriverAddStopsState({
      required this.FirstName,
      required this.LastName,
      required this.LicenceNumber,
      required this.Password,
      required this.VehicleNumber,
    });
}