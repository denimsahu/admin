import 'package:flutter/material.dart';

Widget CustomBigElevatedButton({
  required BuildContext context,
  required Function onPressed,
  String? text,
  Widget? child,
  Color? color,
  double? elevation,
}

) {
  return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
      height: 50.0,
      child: ElevatedButton(
        onPressed: () {
          onPressed();
        },
        child: text!=null?Text(
              text,
              style: TextStyle(fontSize: 20, color: Colors.black),
            ):
            child,
        style: ElevatedButton.styleFrom(
          elevation: elevation??10.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            backgroundColor:color??Colors.blue.shade200),
      ));
}
