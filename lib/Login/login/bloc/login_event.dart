part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class LoginSubmitEvent extends LoginEvent {
  late String Username;
  late String Password;
  LoginSubmitEvent({required this.Username, required this.Password});
}

class LoginErrorEvent extends LoginEvent {
  late String Error;
  LoginErrorEvent({required this.Error});
}
