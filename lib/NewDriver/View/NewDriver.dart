import 'dart:convert';

import 'package:admin/NewDriver/bloc/create_driver_bloc.dart';
import 'package:admin/global/Widgets/CustomBigElevatedButton.dart';
import 'package:admin/global/Widgets/CustomTextFormField.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart' as lottie;

class NewDriver extends StatefulWidget {
  const NewDriver({super.key});

  @override
  State<NewDriver> createState() => _NewDriverState();
}

class _NewDriverState extends State<NewDriver> {
  TextEditingController FirstName = TextEditingController();
  TextEditingController LastName = TextEditingController();
  TextEditingController Password1 = TextEditingController();
  TextEditingController Password2 = TextEditingController();
  TextEditingController LicenceNumber = TextEditingController();
  TextEditingController VehicleNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateDriverBloc, CreateDriverState>(
      listener: (context, state) {
        if (state is CreateDriverErrorState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.Error)));
        }
      },
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.black,
              iconSize: 25.0,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: Colors.lightGreen[300],
            title: Text(
              "New Driver",
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.02),
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                      child: Column(
                    children: [
                      lottie.Lottie.asset("assets/AddDriver.json",height: MediaQuery.of(context).size.height*0.2), 
                      SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                      customTextFormFeild(
                        labelText: "Driver First name",
                        controller: FirstName
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                      customTextFormFeild(
                        labelText: "Driver Last name",
                        controller: LastName
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                      customTextFormFeild(
                        labelText: "Driver Licence Number",
                        controller: LicenceNumber
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                      customTextFormFeild(
                        labelText: "Vehicle Number",
                        controller: VehicleNumber
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                      customTextFormFeild(
                        obscureText: true,
                        labelText: "Password Again",
                        controller: Password1
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                      customTextFormFeild(
                        obscureText: true,
                        labelText: "Password Again",
                        controller: Password2
                      ),
                    ],
                  )),
                  BlocConsumer<CreateDriverBloc, CreateDriverState>(
                    listener: (context, state) {
                       if(state is CreateDriverAddStopsState){
                        Navigator.of(context).pushNamed("/addStops",arguments:{
        "DrivingAllowed":true,
        "First Name":state.FirstName,
        "IsOn":false,
        "Last Name":state.LastName,
        "Licence Number":state.LicenceNumber.toString().toUpperCase(),
        "MarkerId":state.VehicleNumber.toString().toUpperCase(),
        "Password":sha256.convert(utf8.encode(state.Password.toString())).toString(),
        "Vehicle Number":state.VehicleNumber.toString().toUpperCase(),
        "langitude":"0",
        "latitude":"0",
        });
                      }
                    },
                    builder: (context, state) {
                      return Column(
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height*0.05,),
                          CustomBigElevatedButton(
                            context: context,
                            onPressed: state is CreateDriverLoadingState?
                              (){null;}
                              :
                              (){
                                try {
                                  if (FirstName.text.isEmpty ||Password1.text.isEmpty || Password2.text.isEmpty || LastName.text.isEmpty || LicenceNumber.text.isEmpty || VehicleNumber.text.isEmpty){
                                    throw("PLease Fill All Details");
                                  }
                                  else if (Password1.text == Password2.text) {
                                    if(Password1.text.length<10){
                                      throw ("Password is Too Short");
                                    }
                                    else if(!RegExp(r'^\S*$').hasMatch(VehicleNumber.text)){
                                      throw("Vehicle Number cannot contain space");
                                    }
                                    else if (!RegExp(r'^\S*$').hasMatch(LicenceNumber.text)){
                                      throw("Licence Number cannot contain space");
                                    }
                                    else{
                                      context.read<CreateDriverBloc>().add(
                                          CreateDriverSubmitEvent(
                                              FirstName: FirstName.text,
                                              LastName: LastName.text,
                                              LicenceNumber: LicenceNumber.text,
                                              Password: Password1.text,
                                              VehicleNumber: VehicleNumber.text));
                                    }
                                  } 
                                  else {
                                    throw ("Password Doesn't Match");
                                  }
                                } 
                                catch (error) {
                                  context.read<CreateDriverBloc>().add(
                                      CreateDriverErrorEvent(
                                          Error: error.toString()));
                                };
                              },
                              color: state is CreateDriverLoadingState?Colors.lightGreen[100]:Colors.lightGreen.shade300,
                              child: state is CreateDriverLoadingState?lottie.Lottie.asset("assets/loadingDotsGreen.json"):Text("Next",style: TextStyle(fontSize: 20, color: Colors.black),),
                              ),
                        ],
                      );
                    },
                  )
                ],
              ),
            ),
          )),
    );
  }
}
