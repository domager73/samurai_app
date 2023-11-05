import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:samurai_app/utils/colors.dart';
import 'package:samurai_app/utils/fonts.dart';
import 'package:samurai_app/utils/global_constants.dart';

import '../../data/music_manager.dart';

class ButtonYes extends StatefulWidget {
  final Function onTap;

  const ButtonYes({super.key, required this.onTap});

  @override
  State<ButtonYes> createState() => _ButtonYesState();
}

class _ButtonYesState extends State<ButtonYes> {
  bool isTapped = false;

  void _onTap() async {
    GetIt.I<MusicManager>().keyBackSignCloseX.play().then((value) async {
      await GetIt.I<MusicManager>()
          .keyBackSignCloseX
          .seek(const Duration(seconds: 0));
    });

    setState(() {
      isTapped = true;
    });

    await Future.delayed(GlobalConstants.animDuration, () {
      setState(() {
        isTapped = false;
      });
    });

    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        _onTap();
      },
      child: AnimatedContainer(
        decoration: isTapped
            ? const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(80),
                    topLeft: Radius.circular(80)),
                boxShadow: [
                    BoxShadow(
                        color: AppColors.textBlue,
                        spreadRadius: 0.5,
                        blurRadius: 10,
                        offset: Offset(2, 2))
                  ])
            : const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(80),
                    topLeft: Radius.circular(80)),
              ),
        duration: GlobalConstants.animDuration,
        child: CustomPaint(
          painter: ButtonYesPainter(),
          child: Container(
            width: 156,
            height: 38.2,
            alignment: Alignment.center,
            child: Text(
              "yes".toUpperCase(),
              style: AppTypography.amazObit17Dark
                  .copyWith(color: AppColors.textDark),
            ),
          ),
        ),
      ),
    );
  }
}

class ButtonYesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.6785064, 0);
    path_0.lineTo(size.width * 0.6683397, size.height * 0.03801905);
    path_0.lineTo(size.width * 0.6152840, size.height * 0.03801571);
    path_0.lineTo(size.width * 0.5746718, size.height * 0.03801595);
    path_0.lineTo(size.width * 0.2011904, size.height * 0.03801595);
    path_0.lineTo(size.width * -0.000002151878, size.height * 0.8569119);
    path_0.lineTo(size.width * 0.4991673, size.height * 0.8569119);
    path_0.lineTo(size.width * 0.5149224, size.height * 0.9068048);
    path_0.lineTo(size.width * 0.8980769, size.height * 0.8974238);
    path_0.lineTo(size.width, size.height * 0.4814310);
    path_0.lineTo(size.width, 0);
    path_0.lineTo(size.width * 0.6785064, 0);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = const Color(0xff00FFFF).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.4871795, size.height * 1.000007);
    path_1.lineTo(size.width * 0.4711538, size.height * 0.9523810);
    path_1.lineTo(size.width * 0.1826923, size.height * 0.9523881);
    path_1.lineTo(size.width * 0.1974179, size.height * 1.000007);
    path_1.lineTo(size.width * 0.4871795, size.height * 1.000007);
    path_1.close();

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = const Color(0xffFF0049).withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_fill);

    Path path_2 = Path();
    path_2.moveTo(size.width * 0.1299705, size.height * 1.000007);
    path_2.lineTo(size.width * 0.1139449, size.height * 0.9523810);
    path_2.lineTo(size.width * 0.01779096, size.height * 0.9523881);
    path_2.lineTo(size.width * 0.03251641, size.height * 1.000007);
    path_2.lineTo(size.width * 0.1299705, size.height * 1.000007);
    path_2.close();

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.color = const Color(0xffFF0049).withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
