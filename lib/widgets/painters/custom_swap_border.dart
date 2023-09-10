import 'package:flutter/material.dart';

class CustomSwapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.002924006, size.height * 0.06884865);
    path_0.lineTo(size.width * 0.002923977, size.height * 0.9788378);
    path_0.lineTo(size.width * 0.4525205, size.height * 0.9788378);
    path_0.lineTo(size.width * 0.4782632, size.height * 0.9196554);
    path_0.lineTo(size.width * 0.9586871, size.height * 0.9196554);
    path_0.lineTo(size.width * 0.9960585, size.height * 0.8289122);
    path_0.lineTo(size.width * 0.9960585, size.height * 0.006756757);
    path_0.lineTo(size.width * 0.6330409, size.height * 0.006756757);
    path_0.lineTo(size.width * 0.6081871, size.height * 0.06884865);
    path_0.lineTo(size.width * 0.03947368, size.height * 0.06884865);
    path_0.lineTo(size.width * 0.002924006, size.height * 0.06884865);
    path_0.close();

    Paint paint_0_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_0_stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_stroke);

    // Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    // paint_0_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_stroke);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.8245614, size.height * 0.9758919);
    path_1.lineTo(size.width * 0.4751462, size.height * 0.9758919);

    Paint paint_1_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_1_stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_stroke);

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_fill);

    Path path_2 = Path();
    path_2.moveTo(size.width * 0.8421053, size.height * 0.9936081);
    path_2.lineTo(size.width * 0.8514532, size.height * 0.9622432);
    path_2.lineTo(size.width * 0.9502924, size.height * 0.9622432);
    path_2.lineTo(size.width * 0.9418889, size.height * 0.9936081);
    path_2.lineTo(size.width * 0.8421053, size.height * 0.9936081);
    path_2.close();

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.color = Color(0xffFF0049).withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
