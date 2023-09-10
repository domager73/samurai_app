import 'package:flutter/material.dart';
import 'package:samurai_app/utils/gradients.dart';

class PopupPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.8441176, size.height * 0.9941605);
    path_0.lineTo(size.width * 0.8535206, size.height * 0.9655062);
    path_0.lineTo(size.width * 0.9529412, size.height * 0.9655062);
    path_0.lineTo(size.width * 0.9444882, size.height * 0.9941605);
    path_0.lineTo(size.width * 0.8441176, size.height * 0.9941605);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = const Color(0xffFF0049).withOpacity(1.0);
    canvas.drawPath(path_0, paint0Fill);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.8264706, size.height * 0.9779753);
    path_1.lineTo(size.width * 0.4750000, size.height * 0.9779753);

    Paint paint1Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint1Stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_1, paint1Stroke);

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.color = const Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_1, paint1Fill);

    Path path_2 = Path();
    path_2.moveTo(size.width * 0.6344676, size.height * 0.003086420);
    path_2.lineTo(size.width * 0.9975059, size.height * 0.003086420);
    path_2.lineTo(size.width * 0.9975059, size.height * 0.8424630);
    path_2.lineTo(size.width * 0.9607559, size.height * 0.9235123);
    path_2.lineTo(size.width * 0.4781353, size.height * 0.9235123);
    path_2.lineTo(size.width * 0.4775294, size.height * 0.9235123);
    path_2.lineTo(size.width * 0.4771000, size.height * 0.9244136);
    path_2.lineTo(size.width * 0.4516353, size.height * 0.9775802);
    //
    path_2.lineTo(size.width * 0.001470588, size.height * 0.9775802);
    path_2.lineTo(size.width * 0.001470612, size.height * 0.05981216);
    path_2.lineTo(size.width * 0.03676471, size.height * 0.05981216);
    path_2.lineTo(size.width * 0.6088235, size.height * 0.05981216);
    path_2.lineTo(size.width * 0.6094676, size.height * 0.05981216);
    path_2.lineTo(size.width * 0.6099029, size.height * 0.05882154);
    path_2.lineTo(size.width * 0.6344676, size.height * 0.003086420);
    path_2.close();

    Paint paint2Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint2Stroke.color = const Color(0xff00FFFF).withOpacity(1.0);
    canvas.drawPath(path_2, paint2Stroke);

    Paint paint2Fill = Paint()..style = PaintingStyle.fill;
    paint2Fill.shader = AppGradients.popupBack.createShader(Rect.fromPoints(const Offset(0, 0), Offset(size.width, size.height)));
    
    canvas.drawPath(path_2, paint2Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
