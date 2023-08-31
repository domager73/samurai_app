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

  static TextStyle amazObitW400White =
      amazObit17Dark.copyWith(fontSize: 34, color: Colors.white);

  static TextStyle spaceMonoW400 = _spaceMono.copyWith(
      color: Colors.white, fontWeight: FontWeight.w400, fontSize: 15);

  static TextStyle spaceMonoW700 = _spaceMono.copyWith(
      color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15);
}
