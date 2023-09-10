import 'package:flutter/material.dart';

SnackBar buildCustomSnackbar(BuildContext context, String text, bool isFire) {
  return SnackBar(
      duration: const Duration(seconds: 2),
      padding: const EdgeInsets.only(top: 30),
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        height: MediaQuery.sizeOf(context).height * 0.1,
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
          color: const Color(0xFF0D1238),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
                color: isFire ? const Color(0xFFFF0049) : const Color(0xFF2FFFFF),
                blurRadius: 30,
                spreadRadius: 15,
                offset: const Offset(0, 20))
          ],
        ),
        child: Center(
          child: Text(text,
              style: TextStyle(
                  fontSize: 0.021 * MediaQuery.sizeOf(context).height,
                  fontWeight: FontWeight.w700,
                  color: isFire ? const Color(0xFFFF0049) : const Color(0xFF2FFFFF))),
        ),
      ));
}
