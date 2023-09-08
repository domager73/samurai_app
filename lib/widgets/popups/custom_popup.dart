import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:samurai_app/utils/colors.dart';
import 'package:samurai_app/utils/fonts.dart';
import 'package:samurai_app/widgets/buttons/custom_painter_button.dart';
import 'package:samurai_app/widgets/painters/painter_ok.dart';
import 'package:samurai_app/widgets/painters/painter_popup.dart';

import '../../data/music_manager.dart';

class CustomPopup extends StatefulWidget {
  final String text;

  final bool isError;

  const CustomPopup({
    super.key,
    required this.text,
    required this.isError,
  });

  @override
  State<CustomPopup> createState() => _CustomPopupState();
}

class _CustomPopupState extends State<CustomPopup> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Dialog(
      insetPadding: EdgeInsets.zero,
      elevation: 0,
      shadowColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      child: Container(
          alignment: Alignment.center,
          width: size.width * 0.872,
          constraints: const BoxConstraints(
            minHeight: 200,
          ),
          child: CustomPaint(
            painter: PopupPainter(),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 33),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.text,
                    style: AppTypography.spaseMono16.copyWith(color: widget.isError ? AppColors.textRed : Colors.white),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  CustomPainterButton(
                      painter: ButtonOkPainter(),
                      height: 43.2,
                      width: 132,
                      text: "OK",
                      player: GetIt.I<MusicManager>().keyBackSignCloseX,
                      onTap: () {
                        Navigator.pop(context);
                      }, style: AppTypography.amazObit17Dark,)
                ],
              ),
            ),
          )),
    );
  }
}

