import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:samurai_app/utils/colors.dart';
import 'package:samurai_app/utils/fonts.dart';

class ButtonOk extends StatefulWidget {
  const ButtonOk({super.key});

  @override
  State<ButtonOk> createState() => ButtonOkState();
}

class ButtonOkState extends State<ButtonOk> {
  final Duration _duration = Duration(milliseconds: 100);
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          isTapped = true;
        });
        await Future.delayed(_duration, () {
          Navigator.pop(context);
        });
        setState(() {
          isTapped = false;
        });
      },
      child: AnimatedContainer(
        duration: _duration,
        child: Stack(alignment: Alignment.center, children: [
          ClipRect(
            child: Container(
              width: 132 + 20,
              height: 43.6 + 20,
              alignment: Alignment.center,
              child: Visibility(
                visible: isTapped,
                child: CustomPaint(
                  painter: ButtonOkPainter(),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      width: 132,
                      height: 43.6,
                    ),
                  ),
                ),
              ),
            ),
          ),
          CustomPaint(
            painter: ButtonOkPainter(),
            child: Container(
              padding: EdgeInsets.only(bottom: 5),
              alignment: Alignment.center,
              width: 132,
              height: 43.6,
              child: Text(
                'OK',
                style: AppTypography.amazObit17Dark,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class ButtonOkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.8560606, size.height * 0.9688911);
    path_0.lineTo(size.width * 0.3636364, size.height * 0.9688911);

    Paint paint_0_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_0_stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_stroke);

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);

    Path path_1 = Path();
    path_1.moveTo(0, size.height * 0.9688889);
    path_1.lineTo(0, size.height * 0.6247111);
    path_1.lineTo(size.width * 0.1980689, 0);
    path_1.lineTo(size.width, 0);
    path_1.lineTo(size.width, size.height * 0.4561067);
    path_1.lineTo(size.width * 0.8575682, size.height * 0.8766133);
    path_1.lineTo(size.width * 0.3446970, size.height * 0.8766133);
    path_1.lineTo(size.width * 0.3261348, size.height * 0.9688889);
    path_1.lineTo(0, size.height * 0.9688889);
    path_1.close();

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = Color(0xff00FFFF).withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
