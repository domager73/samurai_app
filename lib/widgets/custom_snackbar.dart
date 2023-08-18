import 'package:flutter/material.dart';

SnackBar buildCustomSnackbar(BuildContext context, String text, bool isFire) {
  return SnackBar(
      padding: EdgeInsets.only(top: 30),
      backgroundColor: Colors.transparent,
      elevation: 0,
      
      content: Container(
        height: MediaQuery.sizeOf(context).height * 0.1,
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
          color: Color(0xFF0D1238),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          boxShadow: [BoxShadow(color: isFire? Color(0xFFFF0049) : Color(0xFF2FFFFF), blurRadius: 30, spreadRadius: 15, offset: Offset(0, 20))],
        ),
        child: Center(
          child: Text(text, style: TextStyle(fontSize: 0.021 * MediaQuery.sizeOf(context).height, fontWeight: FontWeight.w700, color: isFire ? Color(0xFFFF0049) : Color(0xFF2FFFFF))),
        ),
      ));
}
