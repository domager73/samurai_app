import 'package:flutter/material.dart';

class DropDownListBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.5081304, size.height * 0.9905660);
    path_0.lineTo(size.width * 0.002173913, size.height * 0.9905660);
    path_0.lineTo(size.width * 0.002173913, size.height * 0.4868962);
    path_0.lineTo(size.width * 0.09911261, size.height * 0.009433962);
    path_0.lineTo(size.width * 0.7024783, size.height * 0.009433962);
    path_0.lineTo(size.width * 0.7264783, size.height * 0.009433962);
    path_0.lineTo(size.width * 0.9978261, size.height * 0.009433962);
    path_0.lineTo(size.width * 0.9978261, size.height * 0.6716396);
    path_0.lineTo(size.width * 0.9378826, size.height * 0.9905660);
    path_0.lineTo(size.width * 0.5081304, size.height * 0.9905660);
    path_0.close();

    Paint paint_0_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;


    paint_0_stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_stroke);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
