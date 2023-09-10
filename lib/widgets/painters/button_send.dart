import 'package:flutter/material.dart';

class ButtonSendPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    Path path_0 = Path();
    path_0.moveTo(0,size.height*0.2156840);
    path_0.lineTo(size.width*0.004389806,size.height*0.2156840);
    path_0.lineTo(size.width*0.1464115,0);
    path_0.lineTo(size.width,0);
    path_0.lineTo(size.width,size.height*0.6666660);
    path_0.lineTo(size.width*0.7805090,size.height);
    path_0.lineTo(0,size.height);
    path_0.lineTo(0,size.height*0.2156840);
    path_0.close();

    Paint paint0Fill = Paint()..style=PaintingStyle.fill;
    paint0Fill.color = Color(0xff00FFFF).withOpacity(1.0);
    canvas.drawPath(path_0,paint0Fill);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}