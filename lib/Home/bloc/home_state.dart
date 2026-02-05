part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

class HomePageAddPolylinState extends HomeState{
  List<LatLng> route;
  LatLng cameraUpdateLatLang;
  HomePageAddPolylinState({required this.route, required this.cameraUpdateLatLang});
}

class HomePageErrorState extends HomeState{
  String ErrorMessage;
  HomePageErrorState({required this.ErrorMessage});
}

class HomePageLoadingState extends HomeState{
  String? Message;
  HomePageLoadingState({this.Message});
}

class HomePageGetUserLocationPermissionSuccessState extends HomeState{}

class HomePageStartUserLocationStreamState extends HomeState{
  
}