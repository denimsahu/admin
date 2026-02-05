import 'package:admin/Login/verifyOtp/View/Verify_Otp.dart';
import 'package:admin/Login/login/bloc/login_bloc.dart';
import 'package:admin/global/Widgets/CustomBigElevatedButton.dart';
import 'package:admin/global/Widgets/CustomTextFormFieldWithIcon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart' as lottie;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  TextEditingController Username = TextEditingController();
  TextEditingController Password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
        body: SingleChildScrollView(
          child: BlocConsumer<LoginBloc, LoginState>(
              listener: (BuildContext context, state) {
              if (state is LoginSuccessState) {
          Navigator.popAndPushNamed(context, '/home');
              } else if (state is LoginErrorState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.Error)));
              } else if (state is LoginOtpSentState) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      VerifyOtp(verificationid: state.verificationId)));
              }
            }, builder: (BuildContext context, state) {
              if (state is LoginVerifyCaptachState) {
                return SafeArea(
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height*0.07,),
                        Image.asset("assets/reCaptcha.png",height: MediaQuery.of(context).size.height*0.3,),
                        SizedBox(height: MediaQuery.of(context).size.height*0.07,),
                        Text(
                          "Verify CaptCha",
                          style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                        CircularProgressIndicator.adaptive(),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                        Text("Loading....."),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                        Text(
                          "Don't Go Back Or Click Referesh",
                          style: TextStyle(fontStyle: FontStyle.italic),
                        )
                      ],
                    ),
                  ),
                );
              }
              return Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              lottie.Lottie.asset("assets/loginPersonAnimation.json",
                  height: MediaQuery.of(context).size.height * 0.35),
              // SizedBox(height: MediaQuery.of(context).size.height*0.03,),
              Text(
                "Welcome Admin",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Column(
                children: [
                  Text(
                    "Login In To Manage Your Fleet At",
                    style: TextStyle(fontSize: 23.0),
                  ),
                  Text(
                    "Your Finger Tips.",
                    style: TextStyle(fontSize: 23.0),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
              ),
        
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(children: [
                  CustomTextFieldWithIcon(
                      context: context,
                      Icons: Icons.person,
                      HintText: "Username",
                      controller: Username),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  CustomTextFieldWithIcon(
                      context: context,
                      Icons: Icons.key,
                      HintText: "Password",
                      controller: Password,
                      obscureText: true),
                ]),
              ),
        
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.12,
              ),
              BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  return CustomBigElevatedButton(
                    context: context,
                    onPressed:state is LoginLoadingState?(){null;}:() async {
                      String username = Username.value.text;
                      String password = Password.value.text;
                      if (username.isEmpty || password.isEmpty) {
                        context.read<LoginBloc>().add(LoginErrorEvent(
                            Error: "Empty Username Or password"));
                      }
                      else if (!RegExp(r'^\S*$').hasMatch(username)){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid Username")));
                      } 
                      else {
                        context.read<LoginBloc>().add(LoginSubmitEvent(
                            Username: username, Password: password));
                      }
                    },
                    color: state is LoginLoadingState?Colors.lightGreen.shade100:Colors.lightGreen.shade300,
                    text: state is LoginLoadingState?null:"Login",
                    child: state is LoginLoadingState?lottie.Lottie.asset("assets/loadingDotsGreen.json"):null,
                  );
                },
              )
            ],
          ),
              );
            }),
        ));
  }
}
