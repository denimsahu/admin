part of 'verify_otp_bloc.dart';

@immutable
sealed class VerifyOtpEvent {}

class VerifyOtpSubmitEvent extends VerifyOtpEvent{
  late String otp;
  late String verificationid;
  VerifyOtpSubmitEvent({required this.otp, required this.verificationid});
}