import 'package:flutter/material.dart';
import 'package:samurai_app/utils/fonts.dart';
import 'package:samurai_app/utils/gradients.dart';
import 'package:samurai_app/widgets/buttons/cansel_btn.dart';
import 'package:samurai_app/widgets/buttons/ok_btn.dart';
import 'package:samurai_app/widgets/buttons/yes_btn.dart';

class CustomPopup extends StatefulWidget {
  final String text;

  const CustomPopup({super.key, required this.text});

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
                    style: AppTypography.spaseMono16,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 17,
                  ),
                  // ButtonOk()
                  buildPopupActionRow()
                ],
              ),
            ),
          )),
    );
  }

  Widget buildPopupActionRow() {
    return const Stack(
      children: [
        ButtonYes(),
        ButtonCansel()
      ],
    );
  }
}

class PopupPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.8441176, size.height * 0.9941605);
    path_0.lineTo(size.width * 0.8535206, size.height * 0.9655062);
    path_0.lineTo(size.width * 0.9529412, size.height * 0.9655062);
    path_0.lineTo(size.width * 0.9444882, size.height * 0.9941605);
    path_0.lineTo(size.width * 0.8441176, size.height * 0.9941605);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xffFF0049).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.8264706, size.height * 0.9779753);
    path_1.lineTo(size.width * 0.4750000, size.height * 0.9779753);

    Paint paint_1_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_1_stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_stroke);

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_fill);

    Path path_2 = Path();
    path_2.moveTo(size.width * 0.6344676, size.height * 0.003086420);
    path_2.lineTo(size.width * 0.9975059, size.height * 0.003086420);
    path_2.lineTo(size.width * 0.9975059, size.height * 0.8424630);
    path_2.lineTo(size.width * 0.9607559, size.height * 0.9235123);
    path_2.lineTo(size.width * 0.4781353, size.height * 0.9235123);
    path_2.lineTo(size.width * 0.4775294, size.height * 0.9235123);
    path_2.lineTo(size.width * 0.4771000, size.height * 0.9244136);
    path_2.lineTo(size.width * 0.4516353, size.height * 0.9775802);
    //
    path_2.lineTo(size.width * 0.001470588, size.height * 0.9775802);
    path_2.lineTo(size.width * 0.001470612, size.height * 0.05981216);
    path_2.lineTo(size.width * 0.03676471, size.height * 0.05981216);
    path_2.lineTo(size.width * 0.6088235, size.height * 0.05981216);
    path_2.lineTo(size.width * 0.6094676, size.height * 0.05981216);
    path_2.lineTo(size.width * 0.6099029, size.height * 0.05882154);
    path_2.lineTo(size.width * 0.6344676, size.height * 0.003086420);
    path_2.close();

    Paint paint_2_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_2_stroke.color = Color(0xff00FFFF).withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_stroke);

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.shader = AppGradients.popupBack.createShader(Rect.fromPoints(Offset(0, 0), Offset(size.width, size.height)));
    ;
    canvas.drawPath(path_2, paint_2_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
