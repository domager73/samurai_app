//Copy this CustomPainter code to the Bottom of the File
import 'package:flutter/material.dart';

class TransferSamuraiPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.1744208, size.height * 0.9758919);
    path_0.lineTo(size.width * 0.5238363, size.height * 0.9758919);

    Paint paint_0_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_0_stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_stroke);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.1568769, size.height * 0.9936081);
    path_1.lineTo(size.width * 0.1475284, size.height * 0.9622432);
    path_1.lineTo(size.width * 0.04868977, size.height * 0.9622432);
    path_1.lineTo(size.width * 0.05709269, size.height * 0.9936081);
    path_1.lineTo(size.width * 0.1568769, size.height * 0.9936081);
    path_1.close();

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = Color(0xffFF0049).withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_fill);

    Path path_2 = Path();
    path_2.moveTo(size.width * 0.9960585, size.height * 0.06884865);
    path_2.lineTo(size.width * 0.9960585, size.height * 0.9788378);
    path_2.lineTo(size.width * 0.5464620, size.height * 0.9788378);
    path_2.lineTo(size.width * 0.5207193, size.height * 0.9196554);
    path_2.lineTo(size.width * 0.04029357, size.height * 0.9196554);
    path_2.lineTo(size.width * 0.002924240, size.height * 0.8289122);
    path_2.lineTo(size.width * 0.002924240, size.height * 0.006756757);
    path_2.lineTo(size.width * 0.3659415, size.height * 0.006756757);
    path_2.lineTo(size.width * 0.3907953, size.height * 0.06884865);
    path_2.lineTo(size.width * 0.9595088, size.height * 0.06884865);
    path_2.lineTo(size.width * 0.9960585, size.height * 0.06884865);
    path_2.close();

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
