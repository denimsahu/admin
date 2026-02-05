import 'package:admin/Login/verifyOtp/bloc/verify_otp_bloc.dart';
import 'package:admin/global/Widgets/CustomBigElevatedButton.dart';
import 'package:admin/global/Widgets/CustomTextFormFieldWithIcon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart'as lottie;

class VerifyOtp extends StatefulWidget {
  final String verificationid;
  const VerifyOtp({super.key, required this.verificationid});

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  TextEditingController Otp = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              children: [
                lottie.Lottie.asset(
                  "assets/verifyOtpAnimation.json",
                  height: MediaQuery.of(context).size.height*0.3
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Text("Verify OTP" , style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.w500),),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                Column(
                  children: [
                    Text(
                      "We Have Sent a 6 Digit OTP to Your",
                      style: TextStyle(fontSize: 20.0),
                    ),
                    Text(
                      "Register Mobile Number",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.13),
                Container(
                    margin: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width*0.1),
                    child: CustomTextFieldWithIcon(
                      keyboardType: TextInputType.number,
                      context: context,
                      Icons: Icons.password_sharp,
                      controller: Otp,
                      HintText: "Enter 6 Digit OTP",
                      textAlign: TextAlign.center,
                      maxLength: 6
                    ),
                  ),
                SizedBox(height: MediaQuery.of(context).size.height*0.19,),
                BlocConsumer<VerifyOtpBloc, VerifyOtpState>(
                  listener: (context, state) {
                      if (state is VerifyOtpSuccessState) {
                        Navigator.pop(context);
                        Navigator.popAndPushNamed(context, '/home');
                      } 
                      else if (state is VerifyOtpErrorState) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(state.Error.toString())));
                      }
                    },
                  builder: (context, state) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width*0.01),
                      child: CustomBigElevatedButton(
                        text: state is VerifyOtpLoadingState?null:"Verify",
                        child: state is VerifyOtpLoadingState?lottie.Lottie.asset("assets/loadingDotsGreen.json"):null,
                        color: state is VerifyOtpLoadingState?Colors.lightGreen.shade100:Colors.lightGreen.shade300,
                        context: context,
                        onPressed: state is VerifyOtpLoadingState?(){null;}:() async {
                            context.read<VerifyOtpBloc>().add(VerifyOtpSubmitEvent(
                                otp: Otp.text.toString(),
                                verificationid: widget.verificationid));
                          }
                        ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      );
  }
}
