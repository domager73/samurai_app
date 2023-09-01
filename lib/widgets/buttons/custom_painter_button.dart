import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:samurai_app/utils/fonts.dart';
import 'package:samurai_app/utils/global_constants.dart';

class CustomPainterButton extends StatefulWidget {
  final CustomPainter painter;
  final double width;
  final double height;
  final String text;
  final AudioPlayer? player;
  final Function onTap;

  const CustomPainterButton(
      {super.key,
      required this.painter,
      required this.height,
      required this.width,
      required this.text,
      required this.player,
      required this.onTap});

  @override
  State<CustomPainterButton> createState() => _CustomPainterButtonState();
}

class _CustomPainterButtonState extends State<CustomPainterButton> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          isTapped = true;
        });
        await Future.delayed(GlobalConstants.animDuration, () {});
        setState(() {
          isTapped = false;
        });

        widget.onTap();
      },
      child: SizedBox(
        child: Stack(alignment: Alignment.center, children: [
          ClipRect(
            child: Container(
              width: widget.width + 20,
              height: widget.height + 20,
              alignment: Alignment.center,
              child: Visibility(
                visible: isTapped,
                child: CustomPaint(
                  painter: widget.painter,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      width: widget.width,
                      height: widget.height,
                    ),
                  ),
                ),
              ),
            ),
          ),
          CustomPaint(
            painter: widget.painter,
            child: Container(
              padding: EdgeInsets.only(bottom: 5),
              alignment: Alignment.center,
              width: widget.width,
              height: widget.height,
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

