import 'dart:async';

import 'package:admin/Login/variables.dart';
import 'package:admin/global/Variables.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmitEvent>((event, emit) async {
      emit(LoginLoadingState());
      try {
        DocumentSnapshot<Map<String, dynamic>>? doc = await firebaseFirestore.collection("Administrators").doc(event.Username.toString()).get();
        if (doc.exists) {
          if (doc.get("Password").toString() == sha256.convert(utf8.encode(event.Password.toString())).toString()) {
            emit(LoginVerifyCaptachState());
            try{
              late String VerificationId;
              String? Error;
              Completer<void> codeSentCompleter = Completer<void>();
              await firebaseAuth.verifyPhoneNumber(
                    phoneNumber: "+91"+doc.get("Phone"),
                    verificationCompleted: (_){},
                    codeAutoRetrievalTimeout: (_) {},
                    verificationFailed: (error)  {
                      codeSentCompleter.complete();
                      Error = error.toString();
                    },
                    codeSent: (verificationId, forceResendingToken){
                      VerificationId=verificationId;
                      codeSentCompleter.complete();
                    },
              );
              await codeSentCompleter.future;
              if(Error!=null){
                throw(Error.toString());
              }
              else{
                emit(LoginOtpSentState(verificationId: VerificationId));
              }
            }
            catch(error){
              if(error.toString().contains("A network error (such as timeout, interrupted connection or unreachable host) has occurred.")||
                  error.toString().contains("An internal error has occurred. [ Failed to connect to www.googleapis.com"))
                {
                  emit(LoginErrorState(Error: "Could'nt Reacher The Server Check Your Internet Connection And Try Again"));
              }
              else if(error.toString().contains(" We have blocked all requests from this device due to unusual activity. Try again later.")){
                emit(LoginErrorState(Error: "Too Many Unsuccessful Attems To Login, Please Try Again After Some Time."));
              }
              else if(error.toString().contains(" This request is missing a valid app identifier, meaning that Play Integrity checks, and reCAPTCHA checks were unsuccessful. Please try again, or check the logcat for more details.")){
                emit(LoginErrorState(Error: "Couldn't Verify Captcha"));
              }
              else{
                debugPrint("This Error Occoured While Logging in : ${error.toString()}");
                emit(LoginErrorState(Error: error.toString()));
              }
            }
            
          } 
          else {
            throw ("Incorrect Password");
          }
        } 
        else {
          throw ("Invalid Username Or User Dose not Exists");
        }
      } 
      catch (error) {
        if (error.toString().contains("The service is currently unavailable. This is a most likely a transient condition and may be corrected by retrying with a backoff.")) {
          emit(LoginErrorState(Error: "Can't Reach The Server At The Moment"));
        } 
        else {
          emit(LoginErrorState(Error: error.toString()));
        }
      }
    });

    on<LoginErrorEvent>((event, emit) {
      emit(LoginErrorState(Error: event.Error));
    });
  }
}
