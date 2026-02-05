import 'package:flutter/material.dart';

Widget customTextFormFeild({
  TextEditingController? controller, 
  bool? obscureText,
  String? labelText,
  TextAlign? textAlign, 
  String? obscuringCharacter,
  }){
  return TextFormField(
            obscuringCharacter: obscuringCharacter??'•',
            obscureText: obscureText??false,
            textAlign: textAlign??TextAlign.start,
            decoration:
                InputDecoration(
                  labelText: labelText??"",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                ),
            controller: controller
        );
}