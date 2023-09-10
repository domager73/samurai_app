import 'package:flutter/material.dart';

class ButtonLoginPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    Path path_0 = Path();
    path_0.moveTo(size.width*0.08770369,size.height*0.2358491);
    path_0.lineTo(size.width*0.01704545,size.height*0.5154802);
    path_0.lineTo(size.width*0.01704545,size.height*0.8113208);
    path_0.lineTo(size.width*0.3019318,size.height*0.8113208);
    path_0.lineTo(size.width*0.3210000,size.height*0.7358519);
    path_0.lineTo(size.width*0.3210227,size.height*0.7359123);
    path_0.lineTo(size.width*0.3210227,size.height*0.7358491);
    path_0.lineTo(size.width*0.9365682,size.height*0.7358491);
    path_0.lineTo(size.width*0.9829545,size.height*0.5522708);
    path_0.lineTo(size.width*0.9829545,size.height*0.1792453);
    path_0.lineTo(size.width*0.6904006,size.height*0.1792453);
    path_0.lineTo(size.width*0.6763438,size.height*0.2348726);
    path_0.lineTo(size.width*0.6761364,size.height*0.2342962);
    path_0.lineTo(size.width*0.6761364,size.height*0.2358491);
    path_0.lineTo(size.width*0.08770369,size.height*0.2358491);
    path_0.close();

    Paint paint0Fill = Paint()..style=PaintingStyle.fill;
    paint0Fill.color = Color(0xff00FFFF).withOpacity(1.0);
    canvas.drawPath(path_0,paint0Fill);

    Path path_1 = Path();
    path_1.moveTo(size.width*0.7685028,size.height*0.8301887);
    path_1.lineTo(size.width*0.3352273,size.height*0.8301887);
    path_1.lineTo(size.width*0.3181818,size.height*0.9009434);
    path_1.lineTo(size.width*0.07244318,size.height*0.9009434);

    Paint paint1Stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width*0.002965057;
    paint1Stroke.color=Colors.white.withOpacity(1.0);
    canvas.drawPath(path_1,paint1Stroke);

    Path path_2 = Path();
    path_2.moveTo(size.width*0.5042983,size.height*0.1603774);
    path_2.lineTo(size.width*0.07954545,size.height*0.1603774);
    path_2.lineTo(size.width*0.02130682,size.height*0.3915094);

    Paint paint2Stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width*0.002965057;
    paint2Stroke.color=Colors.white.withOpacity(1.0);
    canvas.drawPath(path_2,paint2Stroke);

    Path path_3 = Path();
    path_3.moveTo(size.width*0.3636364,size.height*0.9433962);
    path_3.lineTo(size.width*0.3764205,size.height*0.8962264);
    path_3.lineTo(size.width*0.5497159,size.height*0.8962264);
    path_3.lineTo(size.width*0.5369318,size.height*0.9433962);
    path_3.lineTo(size.width*0.3636364,size.height*0.9433962);
    path_3.close();

    Paint paint3Fill = Paint()..style=PaintingStyle.fill;
    paint3Fill.color = Color(0xffFF0049).withOpacity(1.0);
    canvas.drawPath(path_3,paint3Fill);

    Path path_4 = Path();
    path_4.moveTo(size.width*0.7869318,size.height*0.08490566);
    path_4.lineTo(size.width*0.7997159,size.height*0.03773585);
    path_4.lineTo(size.width*0.9730114,size.height*0.03773585);
    path_4.lineTo(size.width*0.9602273,size.height*0.08490566);
    path_4.lineTo(size.width*0.7869318,size.height*0.08490566);
    path_4.close();

    Paint paint4Fill = Paint()..style=PaintingStyle.fill;
    paint4Fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_4,paint4Fill);

    Path path_5 = Path();
    path_5.moveTo(size.width*0.6420455,size.height*0.9433962);
    path_5.lineTo(size.width*0.6548295,size.height*0.8962264);
    path_5.lineTo(size.width*0.6860795,size.height*0.8962264);
    path_5.lineTo(size.width*0.6732955,size.height*0.9433962);
    path_5.lineTo(size.width*0.6420455,size.height*0.9433962);
    path_5.close();

    Paint paint5Fill = Paint()..style=PaintingStyle.fill;
    paint5Fill.color = Color(0xffFF0049).withOpacity(1.0);
    canvas.drawPath(path_5,paint5Fill);

    Path path_6 = Path();
    path_6.moveTo(size.width*0.6903409,size.height*0.9433962);
    path_6.lineTo(size.width*0.7031250,size.height*0.8962264);
    path_6.lineTo(size.width*0.7343750,size.height*0.8962264);
    path_6.lineTo(size.width*0.7215909,size.height*0.9433962);
    path_6.lineTo(size.width*0.6903409,size.height*0.9433962);
    path_6.close();

    Paint paint6Fill = Paint()..style=PaintingStyle.fill;
    paint6Fill.color = Color(0xffFF0049).withOpacity(1.0);
    canvas.drawPath(path_6,paint6Fill);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}