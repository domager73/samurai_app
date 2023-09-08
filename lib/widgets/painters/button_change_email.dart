import 'package:flutter/material.dart';

class ChangeEmailPointer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.7301980, size.height * 0.9380020);
    path_0.lineTo(size.width * 0.2735827, size.height * 0.9380020);

    Paint paint_0_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.005940594;
    paint_0_stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_stroke);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.2500000, size.height * 0.7924720);
    path_1.lineTo(size.width * 0.2485866, size.height * 0.7924720);
    path_1.lineTo(size.width * 0.2478683, size.height * 0.7973900);
    path_1.lineTo(size.width * 0.2364564, size.height * 0.8755200);
    path_1.lineTo(size.width * 0.002475248, size.height * 0.8755200);
    path_1.lineTo(size.width * 0.002475248, size.height * 0.5796920);
    path_1.lineTo(size.width * 0.1305094, size.height * 0.02352060);
    path_1.lineTo(size.width * 0.9975248, size.height * 0.02352060);
    path_1.lineTo(size.width * 0.9975248, size.height * 0.4198940);
    path_1.lineTo(size.width * 0.9058960, size.height * 0.7924720);
    path_1.lineTo(size.width * 0.2500000, size.height * 0.7924720);
    path_1.close();

    Paint paint_1_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_1_stroke.color = Color(0xff00FFFF).withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_stroke);

    Path path_2 = Path();
    path_2.moveTo(size.width * 0.8286782, size.height * 0.9809880);
    path_2.lineTo(size.width * 0.8445050, size.height * 0.8855220);
    path_2.lineTo(size.width * 0.9014109, size.height * 0.8855220);
    path_2.lineTo(size.width * 0.8871832, size.height * 0.9809880);
    path_2.lineTo(size.width * 0.8286782, size.height * 0.9809880);
    path_2.close();

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.color = Color(0xffFF0049).withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_fill);

    Path path_3 = Path();
    path_3.moveTo(size.width * 0.7475248, size.height * 0.9809880);
    path_3.lineTo(size.width * 0.7633515, size.height * 0.8855220);
    path_3.lineTo(size.width * 0.8202574, size.height * 0.8855220);
    path_3.lineTo(size.width * 0.8060347, size.height * 0.9809880);
    path_3.lineTo(size.width * 0.7475248, size.height * 0.9809880);
    path_3.close();

    Paint paint_3_fill = Paint()..style = PaintingStyle.fill;
    paint_3_fill.color = Color(0xffFF0049).withOpacity(1.0);
    canvas.drawPath(path_3, paint_3_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
