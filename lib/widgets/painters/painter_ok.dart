import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class ButtonOkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.8560606, size.height * 0.9688911);
    path_0.lineTo(size.width * 0.3636364, size.height * 0.9688911);

    Paint paint0Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint0Stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_0, paint0Stroke);

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_0, paint0Fill);

    Path path_1 = Path();
    path_1.moveTo(0, size.height * 0.9688889);
    path_1.lineTo(0, size.height * 0.6247111);
    path_1.lineTo(size.width * 0.1980689, 0);
    path_1.lineTo(size.width, 0);
    path_1.lineTo(size.width, size.height * 0.4561067);
    path_1.lineTo(size.width * 0.8575682, size.height * 0.8766133);
    path_1.lineTo(size.width * 0.3446970, size.height * 0.8766133);
    path_1.lineTo(size.width * 0.3261348, size.height * 0.9688889);
    path_1.lineTo(0, size.height * 0.9688889);
    path_1.close();

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.color = AppColors.textBlue.withOpacity(1.0);
    canvas.drawPath(path_1, paint1Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
