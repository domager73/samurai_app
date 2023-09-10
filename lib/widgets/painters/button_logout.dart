import 'package:flutter/material.dart';

class ButtonLogoutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.8560606, size.height * 0.9784178);
    path_0.lineTo(size.width * 0.3636364, size.height * 0.9784178);

    Paint paint_0_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_0_stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_stroke);

    Path path_1 = Path();
    path_1.moveTo(0, size.height * 0.9784156);
    path_1.lineTo(0, size.height * 0.6342378);
    path_1.lineTo(size.width * 0.1980689, size.height * 0.009526911);
    path_1.lineTo(size.width, size.height * 0.009526911);
    path_1.lineTo(size.width, size.height * 0.4656333);
    path_1.lineTo(size.width * 0.8575682, size.height * 0.8861400);
    path_1.lineTo(size.width * 0.3446970, size.height * 0.8861400);
    path_1.lineTo(size.width * 0.3261348, size.height * 0.9784156);
    path_1.lineTo(0, size.height * 0.9784156);
    path_1.close();

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = Color(0xff00FFFF).withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
