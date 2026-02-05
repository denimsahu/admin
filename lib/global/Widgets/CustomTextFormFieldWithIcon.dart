import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget CustomTextFieldWithIcon(
    {
      required BuildContext context,
      required IconData Icons,
      TextEditingController? controller,
      String? HintText,
      double? height,
      TextInputType?keyboardType,
      bool? obscureText,
      TextAlign?textAlign,
      int? maxLength,
      double? elevation,
      BorderRadius?  borderRadius,
      BoxBorder? border,
    })
    {
    return Material(
      elevation: elevation??10,
      borderRadius: borderRadius??BorderRadius.circular(25),
      child: Container(
              decoration: BoxDecoration(
                  borderRadius: borderRadius??BorderRadius.circular(25),
                  border: border??null,
                  ),
              width: MediaQuery.of(context).size.width,
              height: height??MediaQuery.of(context).size.height * 0.07,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons),
                  VerticalDivider(
                    color: Colors.black54,
                    endIndent: 10,
                    indent: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: TextFormField(
                      obscureText: obscureText??false,
                      keyboardType:keyboardType??TextInputType.text,
                        controller: controller,
                        textAlign: textAlign??TextAlign.center,
                        style: TextStyle(fontSize: 20.0),
                        decoration: InputDecoration(
                            hintText: HintText??"",
                            border: InputBorder.none),
                        inputFormatters: maxLength==null?[]:[
                                LengthLimitingTextInputFormatter(maxLength)
                              ],
                        ),
                  ),
                ],
              ),
            ),
    );
  }