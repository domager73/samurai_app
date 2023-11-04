import 'package:flutter/material.dart';
import 'package:samurai_app/utils/fonts.dart';
import 'package:samurai_app/widgets/buttons/cansel_btn.dart';
import 'package:samurai_app/widgets/buttons/yes_btn.dart';
import 'package:samurai_app/widgets/painters/painter_popup.dart';

class CustomChoosePopup extends StatefulWidget {
  final String text;

  final Function acceptFunction;
  final Function canselFunction;

  const CustomChoosePopup({super.key, required this.acceptFunction, required this.canselFunction, required this.text});

  @override
  State<CustomChoosePopup> createState() => _CustomChoosePopupState();
}

class _CustomChoosePopupState extends State<CustomChoosePopup> {
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
                    style: AppTypography.spaseMono16.copyWith(color: Colors.white),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  buildActionButtonsRow()
                ],
              ),
            ),
          )),
    );
  }

  Widget buildActionButtonsRow() {
    return SizedBox(
      width: 288,
      height: 40,
      child: Stack(
        children: [
          Align(
              alignment: Alignment.topLeft,
              child: ButtonCancel(
                onTap: () async {
                  widget.canselFunction();
                },
              )),

          
          Align(
              alignment: Alignment.bottomRight,
              child: ButtonYes(
                onTap: () async {
                  widget.acceptFunction();
                },
              )),
        ],
      ),
    );
  }
}
