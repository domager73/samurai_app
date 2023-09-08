import 'package:flutter/material.dart';

class AccountBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.002924006, size.height * 0.2630035);
    path_0.lineTo(size.width * 0.002923977, size.height * 0.9962028);
    path_0.lineTo(size.width * 0.2947193, size.height * 0.9962028);
    path_0.lineTo(size.width * 0.3144444, size.height * 0.9417552);
    path_0.lineTo(size.width * 0.9501550, size.height * 0.9417552);
    path_0.lineTo(size.width * 0.9970760, size.height * 0.8002028);
    path_0.lineTo(size.width * 0.9970760, size.height * 0.008923916);
    path_0.lineTo(size.width * 0.6964854, size.height * 0.008923916);
    path_0.lineTo(size.width * 0.6803538, size.height * 0.05248035);
    path_0.lineTo(size.width * 0.07477281, size.height * 0.05248035);
    path_0.lineTo(size.width * 0.002924006, size.height * 0.2630035);
    path_0.close();

    Paint paint_0_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_0_stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_stroke);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.5438596, size.height * 0.008924056);
    path_1.lineTo(size.width * 0.07309942, size.height * 0.008923916);

    Paint paint_1_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_1_stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_stroke);

    Path path_2 = Path();
    path_2.moveTo(size.width * 0.9502924, size.height * 0.9889441);
    path_2.lineTo(size.width * 0.4415205, size.height * 0.9889441);

    Paint paint_2_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_2_stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
