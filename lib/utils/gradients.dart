import 'package:flutter/material.dart';
import 'package:samurai_app/utils/colors.dart';

abstract class AppGradients {
  static RadialGradient popupBack = RadialGradient(
    colors: [AppColors.popupBackRed, AppColors.popupBackDark],
    center: Alignment.topCenter,
    radius: 0.8,
  );
}
