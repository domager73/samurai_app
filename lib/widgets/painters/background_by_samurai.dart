import 'package:flutter/material.dart';

class BackgroundBySamuraiPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    Path path_0 = Path();
    path_0.moveTo(size.width*0.1890027,size.height*0.02464791);
    path_0.lineTo(size.width*0.1893871,size.height*0.02525286);
    path_0.lineTo(size.width*0.1899871,size.height*0.02525286);
    path_0.lineTo(size.width*0.7663667,size.height*0.02525286);
    path_0.lineTo(size.width*0.7668539,size.height*0.02525286);
    path_0.lineTo(size.width*0.7672180,size.height*0.02482835);
    path_0.lineTo(size.width*0.7784078,size.height*0.01178486);
    path_0.lineTo(size.width*0.9814976,size.height*0.01178486);
    path_0.lineTo(size.width*0.9987181,size.height*0.03436834);
    path_0.lineTo(size.width*0.9987181,size.height*0.9774172);
    path_0.lineTo(size.width*0.9827821,size.height*0.9983161);
    path_0.lineTo(size.width*0.7245360,size.height*0.9983161);
    path_0.lineTo(size.width*0.7172077,size.height*0.9887068);
    path_0.lineTo(size.width*0.7168334,size.height*0.9882152);
    path_0.lineTo(size.width*0.7163026,size.height*0.9882152);
    path_0.lineTo(size.width*0.2849820,size.height*0.9882152);
    path_0.lineTo(size.width*0.2844512,size.height*0.9882152);
    path_0.lineTo(size.width*0.2840743,size.height*0.9887068);
    path_0.lineTo(size.width*0.2767486,size.height*0.9983161);
    path_0.lineTo(size.width*0.01847456,size.height*0.9983161);
    path_0.lineTo(size.width*0.001281893,size.height*0.9773802);
    path_0.lineTo(size.width*0.001281893,size.height*0.03608854);
    path_0.lineTo(size.width*0.01847459,size.height*0.01515186);
    path_0.lineTo(size.width*0.1829686,size.height*0.01515186);
    path_0.close();

    Paint paint_0_stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width*0.002563786;
    paint_0_stroke.color=Color(0xff00ffff).withOpacity(1.0);
    canvas.drawPath(path_0,paint_0_stroke);

    Paint paint_0_fill = Paint()..style=PaintingStyle.fill;
    paint_0_fill.color = Color(0xff00ffff).withOpacity(0.08);
    canvas.drawPath(path_0,paint_0_fill);

    Path path_1 = Path();
    path_1.moveTo(size.width*0.4830692,0);
    path_1.lineTo(size.width*0.4751897,size.height*0.01105819);
    path_1.lineTo(size.width*0.3333333,size.height*0.01105634);
    path_1.lineTo(size.width*0.3405743,0);
    path_1.close();

    Paint paint_1_fill = Paint()..style=PaintingStyle.fill;
    paint_1_fill.color = Color(0xffff0049).withOpacity(1.0);
    canvas.drawPath(path_1,paint_1_fill);

    Path path_2 = Path();
    path_2.moveTo(size.width*0.5602974,0);
    path_2.lineTo(size.width*0.5524180,size.height*0.01105819);
    path_2.lineTo(size.width*0.5051333,size.height*0.01105634);
    path_2.lineTo(size.width*0.5123744,0);
    path_2.close();

    Paint paint_2_fill = Paint()..style=PaintingStyle.fill;
    paint_2_fill.color = Color(0xffff0049).withOpacity(1.0);
    canvas.drawPath(path_2,paint_2_fill);

    Path path_3 = Path();
    path_3.moveTo(size.width*0.7526026,0);
    path_3.lineTo(size.width*0.7447206,size.height*0.01105819);
    path_3.lineTo(size.width*0.6256411,size.height*0.01105634);
    path_3.lineTo(size.width*0.6328821,0);
    path_3.close();

    Paint paint_3_fill = Paint()..style=PaintingStyle.fill;
    paint_3_fill.color = Color(0xff00ffff).withOpacity(1.0);
    canvas.drawPath(path_3,paint_3_fill);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}