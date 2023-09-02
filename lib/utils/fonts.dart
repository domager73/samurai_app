import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

class AppTypography {
  static final _spaceMono = GoogleFonts.spaceMono();
  static const _amazObit = TextStyle(fontFamily: "AmazObitaemOstrovItalic");

  static TextStyle spaseMono16 = _spaceMono.copyWith(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static TextStyle amazObit17Dark = _amazObit.copyWith(
      fontWeight: FontWeight.w400, color: AppColors.textDark, fontSize: 17);

  static TextStyle amazObit19Blue = _amazObit.copyWith(
      fontWeight: FontWeight.w400,
      color: AppColors.textBlue,
      fontSize: 19,
      letterSpacing: 3);

  static TextStyle amazObit20Blue = _amazObit.copyWith(
      color: AppColors.textBlue,
      fontSize: 20,);

  static TextStyle amazObitWhite = _amazObit.copyWith(
      fontFamily: 'AmazObitaemOstrovItalic',
      color: Colors.white,
      height: 0.9,
    );

  static TextStyle amazObitW400White =
      amazObit17Dark.copyWith(fontSize: 34, color: Colors.white);

  static TextStyle spaceMonoW400 = _spaceMono.copyWith(
      color: Colors.white, fontWeight: FontWeight.w400, fontSize: 15);

  static TextStyle spaceMonoW700White17 = _spaceMono.copyWith(
      fontWeight: FontWeight.w700,
      color: Colors.white,
      fontSize: 17,
    );

  static TextStyle spaceMonoW700Blue16 = _spaceMono.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textBlue,
  );

  static TextStyle spaceMonoW700Red16 = _spaceMono.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textRed,
  );

  static TextStyle spaceMonoW700WhiteOpacity = _spaceMono.copyWith(
    fontWeight: FontWeight.w700,
    color: Colors.white.withOpacity(0.15),
    fontSize: 52,
  );

  static TextStyle spaceMonoW700 = _spaceMono.copyWith(
      color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15, letterSpacing: 1);

  static TextStyle spaceMono13Sky = _spaceMono.copyWith(
    color: AppColors.textBlue,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    letterSpacing: 1
  );

  static TextStyle spaceMonoBold20 = _spaceMono.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1,
  );

  static TextStyle spaceMonoReg13White = _spaceMono.copyWith(
    fontSize: 13,
    color: Colors.white,
    fontWeight: FontWeight.w400,
    height: 1,
  );

  static TextStyle spaceMonoBold13 = _spaceMono.copyWith(
    fontSize: 13, fontWeight: FontWeight.w700,
    color: Colors.white
  );

  static TextStyle spaceMonoBold10 = _spaceMono.copyWith(
    fontSize: 10, fontWeight: FontWeight.w700,
    color: Colors.white
  );
}
