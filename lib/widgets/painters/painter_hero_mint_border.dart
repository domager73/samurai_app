import 'package:flutter/material.dart';

//Copy this CustomPainter code to the Bottom of the File
class HeroMintBorderPainter extends CustomPainter {
  final Color color;
  HeroMintBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.8245614, size.height * 0.9659485);
    path_0.lineTo(size.width * 0.5921053, size.height * 0.9659485);

    Paint paint_0_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_0_stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_stroke);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.8421053, size.height * 0.9921919);
    path_1.lineTo(size.width * 0.8514532, size.height * 0.9457465);
    path_1.lineTo(size.width * 0.9502924, size.height * 0.9457465);
    path_1.lineTo(size.width * 0.9418889, size.height * 0.9921919);
    path_1.lineTo(size.width * 0.8421053, size.height * 0.9921919);
    path_1.close();

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = Color(0xffFF0049).withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_fill);

    Path path_2 = Path();
    path_2.moveTo(size.width * 0.002924006, size.height * 0.2487768);
    path_2.lineTo(size.width * 0.002923977, size.height * 0.9659515);
    path_2.lineTo(size.width * 0.5636316, size.height * 0.9659515);
    path_2.lineTo(size.width * 0.5893743, size.height * 0.8783091);
    path_2.lineTo(size.width * 0.9586871, size.height * 0.8783091);
    path_2.lineTo(size.width * 0.9960585, size.height * 0.7439242);
    path_2.lineTo(size.width * 0.9960585, size.height * 0.01208374);
    path_2.lineTo(size.width * 0.3319825, size.height * 0.01208374);
    path_2.lineTo(size.width * 0.3011696, size.height * 0.1172545);
    path_2.lineTo(size.width * 0.03801170, size.height * 0.1172545);
    path_2.lineTo(size.width * 0.002924006, size.height * 0.2487768);
    path_2.close();

    Paint paint_2_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_2_stroke.color = color.withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
