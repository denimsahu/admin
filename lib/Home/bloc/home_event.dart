part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class HomePageAddPolylineEvent extends HomeEvent{
  String DriverUsername;
  HomePageAddPolylineEvent({required this.DriverUsername});
}

class HomePageGetUserLocationPermissionEvent extends HomeEvent{
  
}

class HomePageStartUserLocationStreamEvent extends HomeEvent{
  
}

class HomePageErrorEvent extends HomeEvent{
  String errorMessage;
  HomePageErrorEvent({required this.errorMessage});
}
