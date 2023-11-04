import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:samurai_app/utils/global_constants.dart';

class CustomButton extends StatefulWidget {
  const CustomButton(
      {super.key,
      required this.onTap,
      required this.activeChild,
      required this.defaultChild,
      required this.player});
  final Function onTap;
  final Widget activeChild;
  final Widget defaultChild;
  final AudioPlayer player;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) async {
        await widget.player.play().then((value) async {
          await widget.player.seek(const Duration(seconds: 0));
        });

        isTapped = true;
        setState(() {});
        print(isTapped);

        await Future.delayed(GlobalConstants.animDuration);
        setState(() {
          isTapped = false;
        });

        widget.onTap();
        print(isTapped);
      },
      child: isTapped
          ? widget.activeChild
          : widget.defaultChild,
    );
  }
}
