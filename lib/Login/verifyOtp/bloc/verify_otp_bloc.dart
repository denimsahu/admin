import 'package:admin/Login/variables.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'verify_otp_event.dart';
part 'verify_otp_state.dart';

class VerifyOtpBloc extends Bloc<VerifyOtpEvent, VerifyOtpState> {
  VerifyOtpBloc() : super(VerifyOtpInitial()) {
    on<VerifyOtpSubmitEvent>((event, emit) async {
      emit(VerifyOtpLoadingState());
       if(RegExp(r'^[0-9]{6,6}$').hasMatch(event.otp)){
          PhoneAuthCredential loginCreditionals = PhoneAuthProvider.credential(verificationId: event.verificationid, smsCode: event.otp);
          try{
            await firebaseAuth.signInWithCredential(loginCreditionals);
            emit(VerifyOtpSuccessState());    
          }
          catch(error){
            emit(VerifyOtpErrorState(Error:error.toString()));
          }
        }
        else{
          emit(VerifyOtpErrorState(Error:"Enter An Valid 6 digit OTP."));
        }
    });
  }
}
