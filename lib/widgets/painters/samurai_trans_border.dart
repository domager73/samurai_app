import 'package:flutter/material.dart';

class SamuraiTransferBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.9982639, size.height * 0.008547009);
    path_0.lineTo(size.width * 0.3357351, size.height * 0.008547009);
    path_0.lineTo(size.width * 0.2676049, size.height * 0.1935462);
    path_0.lineTo(size.width * 0.004202361, size.height * 0.1935462);
    path_0.lineTo(size.width * 0.003472222, size.height * 0.5243632);
    path_0.lineTo(size.width * 0.003472222, size.height * 0.9947692);
    path_0.lineTo(size.width * 0.2326389, size.height * 0.9947692);
    path_0.lineTo(size.width * 0.3439288, size.height * 0.9947692);
    path_0.lineTo(size.width * 0.9635417, size.height * 0.9947692);
    path_0.lineTo(size.width * 0.9982639, size.height * 0.9100598);
    path_0.lineTo(size.width * 0.9982639, size.height * 0.008547009);
    path_0.close();

    Paint paint0Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint0Stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_0, paint0Stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
