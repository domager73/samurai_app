import 'package:flutter/material.dart';
import 'package:samurai_app/utils/colors.dart';
import 'package:samurai_app/utils/fonts.dart';
import 'package:samurai_app/utils/gradients.dart';
import 'package:samurai_app/widgets/buttons/cansel_btn.dart';
import 'package:samurai_app/widgets/buttons/custom_painter_button.dart';
import 'package:samurai_app/widgets/buttons/yes_btn.dart';
import 'package:samurai_app/widgets/painters/painter_ok.dart';
import 'package:samurai_app/widgets/painters/painter_popup.dart';

class PopupBuySamurai extends StatefulWidget {
  final String price;
  final String amountSamurai;

  final Function acceptFunction;
  final Function canselFunction;

  const PopupBuySamurai(
      {super.key,
      required this.acceptFunction,
      required this.canselFunction,
      required this.price,
      required this.amountSamurai});

  @override
  State<PopupBuySamurai> createState() => _PopupBuySamuraiState();
}

class _PopupBuySamuraiState extends State<PopupBuySamurai> {
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
                  RichText(
                      textAlign: TextAlign.start,
                      text:
                          TextSpan(style: AppTypography.spaseMono16, children: [
                        const TextSpan(text: 'Are you sure you want to buy'),
                        TextSpan(
                            text: ' ${widget.amountSamurai} ',
                            style: AppTypography.spaseMono16
                                .copyWith(color: AppColors.textBlue)),
                            const TextSpan(text: 'Samurai?'),
                      ])),
                  const SizedBox(
                    height: 14,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text("price:".toUpperCase(),
                        style: AppTypography.spaceMono13Sky),
                    const SizedBox(
                      width: 13,
                    ),
                    Text("${widget.price} BNB",
                        style: AppTypography.spaceMonoW700)
                  ]),
                  const SizedBox(
                    height: 20,
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
              child: ButtonCansel(
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
