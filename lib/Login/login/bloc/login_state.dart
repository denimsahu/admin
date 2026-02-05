part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

class LoginLoadingState extends LoginState{
}
class LoginVerifyCaptachState extends LoginState{}
class LoginOtpSentState extends LoginState{
  late String verificationId;
  LoginOtpSentState({required this.verificationId});
}

class LoginSuccessState extends LoginState {
  late String Username;
  LoginSuccessState({required this.Username});
}

class LoginErrorState extends LoginState {
  late String Error;
  LoginErrorState({required this.Error});
}
