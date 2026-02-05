part of 'add_stops_bloc.dart';

@immutable
sealed class AddStopsEvent {}

class AddStopsGetPositionPermissionEvent extends AddStopsEvent{}

class AddStopsGetAdminCurrentPositionEvent extends AddStopsEvent{}


class AddStopsUpdateMarkersEvent extends AddStopsEvent{}

class AddStopsAddedEvent extends AddStopsEvent{
  List<Marker> stopsList;
  Map<String,dynamic> driverDetails;
  AddStopsAddedEvent({required this.stopsList, required this.driverDetails});
}