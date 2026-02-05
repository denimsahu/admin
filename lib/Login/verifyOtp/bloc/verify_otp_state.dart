part of 'verify_otp_bloc.dart';

@immutable
sealed class VerifyOtpState {}

final class VerifyOtpInitial extends VerifyOtpState {}

class VerifyOtpLoadingState extends VerifyOtpState {}

class VerifyOtpSuccessState extends VerifyOtpState{}

class VerifyOtpErrorState extends VerifyOtpState{
  String Error;
  VerifyOtpErrorState({required this.Error});
}