import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:samurai_app/utils/colors.dart';
import 'package:samurai_app/utils/fonts.dart';
import 'package:samurai_app/utils/global_constants.dart';

class ButtonCansel extends StatefulWidget {
  final Function onTap;

  const ButtonCansel({super.key, required this.onTap});

  @override
  State<ButtonCansel> createState() => _ButtonCanselState();
}

class _ButtonCanselState extends State<ButtonCansel> {
  bool isTapped = false;

  void _onTap() async {
    widget.onTap();

    setState(() {
      isTapped = true;
    });

    await Future.delayed(GlobalConstants.animDuration);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: AnimatedContainer(
        duration: GlobalConstants.animDuration,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRect(
              child: Container(
                color: Colors.transparent,
                width: 155 + 20,
                height: 38.2 + 20,
                alignment: Alignment.center,
                child: Visibility(
                  visible: isTapped,
                  child: CustomPaint(
                    painter: CanselButtonPainter(),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        width: 155,
                        height: 38.2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: CustomPaint(
                  painter: CanselButtonPainter(),
                  child: Container(
                      alignment: Alignment.center,
                      width: 155,
                      height: 38.2,
                      child: Text(
                        "cansel".toUpperCase(),
                        style: AppTypography.amazObit17Dark
                            .copyWith(color: Colors.white),
                      ))),
            ),
          ],
        ),
      ),
    );
  }
}

class CanselButtonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return getCanselButtonPath(size);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class CanselButtonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.6987179, size.height * 0.04651930);
    path_0.lineTo(size.width * 0.6826923, 0);
    path_0.lineTo(size.width * 0.3942308, size.height * 0.000007723651);
    path_0.lineTo(size.width * 0.4089564, size.height * 0.04651930);
    path_0.lineTo(size.width * 0.6987179, size.height * 0.04651930);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xff00FFFF).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.8557692, size.height * 0.04651930);
    path_1.lineTo(size.width * 0.8397436, 0);
    path_1.lineTo(size.width * 0.7435897, size.height * 0.000007723651);
    path_1.lineTo(size.width * 0.7583141, size.height * 0.04651930);
    path_1.lineTo(size.width * 0.8557692, size.height * 0.04651930);
    path_1.close();

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = Color(0xff00FFFF).withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_fill);

    Path path_2 = Path();
    path_2.moveTo(size.width * 0.3633519, size.height * 0.08666419);
    path_2.lineTo(size.width * 0.3748410, size.height * 0.1238012);
    path_2.lineTo(size.width * 0.5505660, size.height * 0.1237960);
    path_2.lineTo(size.width * 0.9994744, size.height * 0.1237960);
    path_2.lineTo(size.width * 0.7975577, size.height * 0.9236465);
    path_2.lineTo(size.width * 0.5660442, size.height * 0.9236465);
    path_2.lineTo(size.width * 0.5556231, size.height * 0.9780326);
    path_2.lineTo(size.width * 0.1155199, size.height * 0.9643674);
    path_2.lineTo(0, size.height * 0.5569000);
    path_2.lineTo(0, size.height * 0.08666419);
    path_2.lineTo(size.width * 0.3633519, size.height * 0.08666419);
    path_2.close();

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.color = Colors.transparent;

    canvas.drawPath(path_2, paint_2_fill);

    Path path_3 = getCanselButtonPath(size);

    Paint paint_3_fill = Paint()..style = PaintingStyle.fill;
    paint_3_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_3, paint_3_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

Path getCanselButtonPath(Size size) {
  Path path_3 = Path();
  path_3.moveTo(size.width * 0.3748410, size.height * 0.1238012);
  path_3.lineTo(size.width * 0.3697237, size.height * 0.1446374);
  path_3.lineTo(size.width * 0.3719115, size.height * 0.1517081);
  path_3.lineTo(size.width * 0.3748410, size.height * 0.1517081);
  path_3.lineTo(size.width * 0.3748410, size.height * 0.1238012);
  path_3.close();
  path_3.moveTo(size.width * 0.3633519, size.height * 0.08666419);
  path_3.lineTo(size.width * 0.3684692, size.height * 0.06582767);
  path_3.lineTo(size.width * 0.3662814, size.height * 0.05875721);
  path_3.lineTo(size.width * 0.3633519, size.height * 0.05875721);
  path_3.lineTo(size.width * 0.3633519, size.height * 0.08666419);
  path_3.close();
  path_3.moveTo(size.width * 0.5505660, size.height * 0.1237960);
  path_3.lineTo(size.width * 0.5505660, size.height * 0.09588907);
  path_3.lineTo(size.width * 0.5505654, size.height * 0.09588907);
  path_3.lineTo(size.width * 0.5505660, size.height * 0.1237960);
  path_3.close();
  path_3.moveTo(size.width * 0.9994744, size.height * 0.1237960);
  path_3.lineTo(size.width * 1.005147, size.height * 0.1426444);
  path_3.lineTo(size.width * 1.016949, size.height * 0.09588907);
  path_3.lineTo(size.width * 0.9994744, size.height * 0.09588907);
  path_3.lineTo(size.width * 0.9994744, size.height * 0.1237960);
  path_3.close();
  path_3.moveTo(size.width * 0.7975577, size.height * 0.9236465);
  path_3.lineTo(size.width * 0.7975577, size.height * 0.9515535);
  path_3.lineTo(size.width * 0.8009423, size.height * 0.9515535);
  path_3.lineTo(size.width * 0.8032308, size.height * 0.9424953);
  path_3.lineTo(size.width * 0.7975577, size.height * 0.9236465);
  path_3.close();
  path_3.moveTo(size.width * 0.5660442, size.height * 0.9236465);
  path_3.lineTo(size.width * 0.5660442, size.height * 0.8957395);
  path_3.lineTo(size.width * 0.5620231, size.height * 0.8957395);
  path_3.lineTo(size.width * 0.5597276, size.height * 0.9077186);
  path_3.lineTo(size.width * 0.5660442, size.height * 0.9236465);
  path_3.close();
  path_3.moveTo(size.width * 0.5556231, size.height * 0.9780326);
  path_3.lineTo(size.width * 0.5555571, size.height * 1.005937);
  path_3.lineTo(size.width * 0.5596199, size.height * 1.006065);
  path_3.lineTo(size.width * 0.5619391, size.height * 0.9939605);
  path_3.lineTo(size.width * 0.5556231, size.height * 0.9780326);
  path_3.close();
  path_3.moveTo(size.width * 0.1155199, size.height * 0.9643674);
  path_3.lineTo(size.width * 0.1101577, size.height * 0.9843767);
  path_3.lineTo(size.width * 0.1123692, size.height * 0.9921791);
  path_3.lineTo(size.width * 0.1154538, size.height * 0.9922744);
  path_3.lineTo(size.width * 0.1155199, size.height * 0.9643674);
  path_3.close();
  path_3.moveTo(0, size.height * 0.5569000);
  path_3.lineTo(size.width * -0.007692308, size.height * 0.5569000);
  path_3.lineTo(size.width * -0.007692308, size.height * 0.5686884);
  path_3.lineTo(size.width * -0.005362244, size.height * 0.5769093);
  path_3.lineTo(0, size.height * 0.5569000);
  path_3.close();
  path_3.moveTo(0, size.height * 0.08666419);
  path_3.lineTo(0, size.height * 0.05875721);
  path_3.lineTo(size.width * -0.007692308, size.height * 0.05875721);
  path_3.lineTo(size.width * -0.007692308, size.height * 0.08666419);
  path_3.lineTo(0, size.height * 0.08666419);
  path_3.close();
  path_3.moveTo(size.width * 0.3799583, size.height * 0.1029647);
  path_3.lineTo(size.width * 0.3684692, size.height * 0.06582767);
  path_3.lineTo(size.width * 0.3582346, size.height * 0.1075007);
  path_3.lineTo(size.width * 0.3697237, size.height * 0.1446374);
  path_3.lineTo(size.width * 0.3799583, size.height * 0.1029647);
  path_3.close();
  path_3.moveTo(size.width * 0.5505654, size.height * 0.09588907);
  path_3.lineTo(size.width * 0.3748410, size.height * 0.09589419);
  path_3.lineTo(size.width * 0.3748410, size.height * 0.1517081);
  path_3.lineTo(size.width * 0.5505660, size.height * 0.1517030);
  path_3.lineTo(size.width * 0.5505654, size.height * 0.09588907);
  path_3.close();
  path_3.moveTo(size.width * 0.9994744, size.height * 0.09588907);
  path_3.lineTo(size.width * 0.5505660, size.height * 0.09588907);
  path_3.lineTo(size.width * 0.5505660, size.height * 0.1517030);
  path_3.lineTo(size.width * 0.9994744, size.height * 0.1517030);
  path_3.lineTo(size.width * 0.9994744, size.height * 0.09588907);
  path_3.close();
  path_3.moveTo(size.width * 0.8032308, size.height * 0.9424953);
  path_3.lineTo(size.width * 1.005147, size.height * 0.1426444);
  path_3.lineTo(size.width * 0.9938013, size.height * 0.1049479);
  path_3.lineTo(size.width * 0.7918846, size.height * 0.9047977);
  path_3.lineTo(size.width * 0.8032308, size.height * 0.9424953);
  path_3.close();
  path_3.moveTo(size.width * 0.5660442, size.height * 0.9515535);
  path_3.lineTo(size.width * 0.7975577, size.height * 0.9515535);
  path_3.lineTo(size.width * 0.7975577, size.height * 0.8957395);
  path_3.lineTo(size.width * 0.5660442, size.height * 0.8957395);
  path_3.lineTo(size.width * 0.5660442, size.height * 0.9515535);
  path_3.close();
  path_3.moveTo(size.width * 0.5619391, size.height * 0.9939605);
  path_3.lineTo(size.width * 0.5723603, size.height * 0.9395744);
  path_3.lineTo(size.width * 0.5597276, size.height * 0.9077186);
  path_3.lineTo(size.width * 0.5493071, size.height * 0.9621023);
  path_3.lineTo(size.width * 0.5619391, size.height * 0.9939605);
  path_3.close();
  path_3.moveTo(size.width * 0.1154538, size.height * 0.9922744);
  path_3.lineTo(size.width * 0.5555571, size.height * 1.005937);
  path_3.lineTo(size.width * 0.5556885, size.height * 0.9501256);
  path_3.lineTo(size.width * 0.1155859, size.height * 0.9364628);
  path_3.lineTo(size.width * 0.1154538, size.height * 0.9922744);
  path_3.close();
  path_3.moveTo(size.width * -0.005362244, size.height * 0.5769093);
  path_3.lineTo(size.width * 0.1101577, size.height * 0.9843767);
  path_3.lineTo(size.width * 0.1208821, size.height * 0.9443605);
  path_3.lineTo(size.width * 0.005362244, size.height * 0.5368907);
  path_3.lineTo(size.width * -0.005362244, size.height * 0.5769093);
  path_3.close();
  path_3.moveTo(size.width * -0.007692308, size.height * 0.08666419);
  path_3.lineTo(size.width * -0.007692308, size.height * 0.5569000);
  path_3.lineTo(size.width * 0.007692308, size.height * 0.5569000);
  path_3.lineTo(size.width * 0.007692308, size.height * 0.08666419);
  path_3.lineTo(size.width * -0.007692308, size.height * 0.08666419);
  path_3.close();
  path_3.moveTo(size.width * 0.3633519, size.height * 0.05875721);
  path_3.lineTo(0, size.height * 0.05875721);
  path_3.lineTo(0, size.height * 0.1145712);
  path_3.lineTo(size.width * 0.3633519, size.height * 0.1145712);
  path_3.lineTo(size.width * 0.3633519, size.height * 0.05875721);
  path_3.close();

  return path_3;
}
