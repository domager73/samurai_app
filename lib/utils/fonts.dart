import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static TextStyle SPReg = GoogleFonts.spaceMono(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle amazReg = TextStyle(fontFamily: "AmazObitaemOstrovItalic", fontWeight: FontWeight.w400);

  static TextStyle amazLabelMedium = amazReg.copyWith(fontSize: 34);
}
