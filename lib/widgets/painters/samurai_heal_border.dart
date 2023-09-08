import 'package:flutter/material.dart';

class SamuraiHealBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.1126280, size.height * 0.05846404);
    path_0.lineTo(size.width * 0.1233311, size.height * 0.01063830);
    path_0.lineTo(size.width * 0.3138717, size.height * 0.01063830);
    path_0.lineTo(size.width * 0.3042509, size.height * 0.05846404);
    path_0.lineTo(size.width * 0.1126280, size.height * 0.05846404);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xff00FFFF).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.003413003, size.height * 0.5052149);
    path_1.lineTo(size.width * 0.003412969, size.height * 0.9945766);
    path_1.lineTo(size.width * 0.1767696, size.height * 0.9945766);
    path_1.lineTo(size.width * 0.1997935, size.height * 0.9147894);
    path_1.lineTo(size.width * 0.9588840, size.height * 0.9147894);
    path_1.lineTo(size.width * 0.9965870, size.height * 0.7924489);
    path_1.lineTo(size.width * 0.9965870, size.height * 0.01585351);
    path_1.lineTo(size.width * 0.3396457, size.height * 0.01585351);
    path_1.lineTo(size.width * 0.3174061, size.height * 0.1115979);
    path_1.lineTo(size.width * 0.1145812, size.height * 0.1115979);
    path_1.lineTo(size.width * 0.003413003, size.height * 0.5052149);
    path_1.close();

    Paint paint_1_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_1_stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
