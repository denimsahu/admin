part of 'add_stops_bloc.dart';

@immutable
sealed class AddStopsState {}

final class AddStopsInitial extends AddStopsState {}

class AddStopsLoadingState extends AddStopsState{
  String? Message="";
  AddStopsLoadingState({this.Message});
}

class AddStopsGotAdminPositionPermissionSuccessState extends AddStopsState{}

class AddStopsGotAdminLocationState extends AddStopsState{
  LatLng currentPosition;
  AddStopsGotAdminLocationState({required this.currentPosition});
}

class AddStopsErrorState extends AddStopsState{
  String error;
  AddStopsErrorState({required this.error});
}

class AddStopsUpdateMarkersState extends AddStopsState{}

class AddStopsDriverCreatedSuccessfullyState extends AddStopsState{}