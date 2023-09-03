//Copy this CustomPainter code to the Bottom of the File
import 'package:flutter/material.dart';

class TransferSamuraiPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.9960585, size.height * 0.06979178);
    path_0.lineTo(size.width * 0.9960585, size.height * 0.9922466);
    path_0.lineTo(size.width * 0.5464620, size.height * 0.9922466);
    path_0.lineTo(size.width * 0.5207193, size.height * 0.9322534);
    path_0.lineTo(size.width * 0.04029357, size.height * 0.9322534);
    path_0.lineTo(size.width * 0.002924240, size.height * 0.8402671);
    path_0.lineTo(size.width * 0.002924240, size.height * 0.006849315);
    path_0.lineTo(size.width * 0.3659415, size.height * 0.006849315);
    path_0.lineTo(size.width * 0.3907953, size.height * 0.06979178);
    path_0.lineTo(size.width * 0.9595088, size.height * 0.06979178);
    path_0.lineTo(size.width * 0.9960585, size.height * 0.06979178);
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
