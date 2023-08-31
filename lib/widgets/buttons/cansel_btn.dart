import 'package:flutter/material.dart';
import 'package:samurai_app/utils/colors.dart';
import 'package:samurai_app/utils/fonts.dart';

class ButtonCansel extends StatefulWidget {
  const ButtonCansel({super.key});

  @override
  State<ButtonCansel> createState() => _ButtonCanselState();
}

class _ButtonCanselState extends State<ButtonCansel> {
  @override
  Widget build(BuildContext context) {
    return Container(

      child: Stack(
        children: [
          Container(
            color: Colors.yellow,
            child: CustomPaint(
              painter: CanselButtonPainter(),
              child: Text("cansel".toUpperCase(), style: AppTypography.amazReg.copyWith(color: AppColors.textDark),)
              ),
          ),
        ],
      ),
    );
  }
}

//Copy this CustomPainter code to the Bottom of the File
class CanselButtonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.6987179, size.height * 0.1087028);
    path_0.lineTo(size.width * 0.6826923, size.height * 0.06521739);
    path_0.lineTo(size.width * 0.3942308, size.height * 0.06522457);
    path_0.lineTo(size.width * 0.4089564, size.height * 0.1087028);
    path_0.lineTo(size.width * 0.6987179, size.height * 0.1087028);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xff00FFFF).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.8557692, size.height * 0.1087028);
    path_1.lineTo(size.width * 0.8397436, size.height * 0.06521739);
    path_1.lineTo(size.width * 0.7435897, size.height * 0.06522457);
    path_1.lineTo(size.width * 0.7583141, size.height * 0.1087028);
    path_1.lineTo(size.width * 0.8557692, size.height * 0.1087028);
    path_1.close();

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = Color(0xff00FFFF).withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_fill);

    Path path_2 = Path();
    path_2.moveTo(size.width * 0.3633519, size.height * 0.1462296);
    path_2.lineTo(size.width * 0.3748410, size.height * 0.1809446);
    path_2.lineTo(size.width * 0.5505660, size.height * 0.1809398);
    path_2.lineTo(size.width * 0.9994744, size.height * 0.1809398);
    path_2.lineTo(size.width * 0.7975577, size.height * 0.9286261);
    path_2.lineTo(size.width * 0.5660442, size.height * 0.9286261);
    path_2.lineTo(size.width * 0.5556231, size.height * 0.9794652);
    path_2.lineTo(size.width * 0.1155199, size.height * 0.9666913);
    path_2.lineTo(0, size.height * 0.5857978);
    path_2.lineTo(0, size.height * 0.1462296);
    path_2.lineTo(size.width * 0.3633519, size.height * 0.1462296);
    path_2.close();

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_fill);

    Path path_3 = Path();
    path_3.moveTo(size.width * 0.3633519, size.height * 0.1462296);
    path_3.lineTo(size.width * 0.3748410, size.height * 0.1809446);
    path_3.lineTo(size.width * 0.5505660, size.height * 0.1809398);
    path_3.lineTo(size.width * 0.9994744, size.height * 0.1809398);
    path_3.lineTo(size.width * 0.7975577, size.height * 0.9286261);
    path_3.lineTo(size.width * 0.5660442, size.height * 0.9286261);
    path_3.lineTo(size.width * 0.5556231, size.height * 0.9794652);
    path_3.lineTo(size.width * 0.1155199, size.height * 0.9666913);
    path_3.lineTo(0, size.height * 0.5857978);
    path_3.lineTo(0, size.height * 0.1462296);
    path_3.lineTo(size.width * 0.3633519, size.height * 0.1462296);
    path_3.close();

    Paint paint_3_fill = Paint()..style = PaintingStyle.fill;
    paint_3_fill.color = Color(0xff00E3FF).withOpacity(0.03);
    canvas.drawPath(path_3, paint_3_fill);

    Path path_4 = Path();
    path_4.moveTo(size.width * 0.3748410, size.height * 0.1809446);
    path_4.lineTo(size.width * 0.3697237, size.height * 0.2004220);
    path_4.lineTo(size.width * 0.3719115, size.height * 0.2070315);
    path_4.lineTo(size.width * 0.3748410, size.height * 0.2070315);
    path_4.lineTo(size.width * 0.3748410, size.height * 0.1809446);
    path_4.close();
    path_4.moveTo(size.width * 0.3633519, size.height * 0.1462296);
    path_4.lineTo(size.width * 0.3684692, size.height * 0.1267520);
    path_4.lineTo(size.width * 0.3662814, size.height * 0.1201426);
    path_4.lineTo(size.width * 0.3633519, size.height * 0.1201426);
    path_4.lineTo(size.width * 0.3633519, size.height * 0.1462296);
    path_4.close();
    path_4.moveTo(size.width * 0.5505660, size.height * 0.1809398);
    path_4.lineTo(size.width * 0.5505660, size.height * 0.1548528);
    path_4.lineTo(size.width * 0.5505654, size.height * 0.1548528);
    path_4.lineTo(size.width * 0.5505660, size.height * 0.1809398);
    path_4.close();
    path_4.moveTo(size.width * 0.9994744, size.height * 0.1809398);
    path_4.lineTo(size.width * 1.005147, size.height * 0.1985589);
    path_4.lineTo(size.width * 1.016949, size.height * 0.1548528);
    path_4.lineTo(size.width * 0.9994744, size.height * 0.1548528);
    path_4.lineTo(size.width * 0.9994744, size.height * 0.1809398);
    path_4.close();
    path_4.moveTo(size.width * 0.7975577, size.height * 0.9286261);
    path_4.lineTo(size.width * 0.7975577, size.height * 0.9547130);
    path_4.lineTo(size.width * 0.8009423, size.height * 0.9547130);
    path_4.lineTo(size.width * 0.8032308, size.height * 0.9462457);
    path_4.lineTo(size.width * 0.7975577, size.height * 0.9286261);
    path_4.close();
    path_4.moveTo(size.width * 0.5660442, size.height * 0.9286261);
    path_4.lineTo(size.width * 0.5660442, size.height * 0.9025391);
    path_4.lineTo(size.width * 0.5620231, size.height * 0.9025391);
    path_4.lineTo(size.width * 0.5597276, size.height * 0.9137370);
    path_4.lineTo(size.width * 0.5660442, size.height * 0.9286261);
    path_4.close();
    path_4.moveTo(size.width * 0.5556231, size.height * 0.9794652);
    path_4.lineTo(size.width * 0.5555571, size.height * 1.005550);
    path_4.lineTo(size.width * 0.5596199, size.height * 1.005670);
    path_4.lineTo(size.width * 0.5619391, size.height * 0.9943543);
    path_4.lineTo(size.width * 0.5556231, size.height * 0.9794652);
    path_4.close();
    path_4.moveTo(size.width * 0.1155199, size.height * 0.9666913);
    path_4.lineTo(size.width * 0.1101577, size.height * 0.9853957);
    path_4.lineTo(size.width * 0.1123692, size.height * 0.9926891);
    path_4.lineTo(size.width * 0.1154538, size.height * 0.9927783);
    path_4.lineTo(size.width * 0.1155199, size.height * 0.9666913);
    path_4.close();
    path_4.moveTo(0, size.height * 0.5857978);
    path_4.lineTo(size.width * -0.007692308, size.height * 0.5857978);
    path_4.lineTo(size.width * -0.007692308, size.height * 0.5968174);
    path_4.lineTo(size.width * -0.005362244, size.height * 0.6045022);
    path_4.lineTo(0, size.height * 0.5857978);
    path_4.close();
    path_4.moveTo(0, size.height * 0.1462296);
    path_4.lineTo(0, size.height * 0.1201426);
    path_4.lineTo(size.width * -0.007692308, size.height * 0.1201426);
    path_4.lineTo(size.width * -0.007692308, size.height * 0.1462296);
    path_4.lineTo(0, size.height * 0.1462296);
    path_4.close();
    path_4.moveTo(size.width * 0.3799583, size.height * 0.1614670);
    path_4.lineTo(size.width * 0.3684692, size.height * 0.1267520);
    path_4.lineTo(size.width * 0.3582346, size.height * 0.1657072);
    path_4.lineTo(size.width * 0.3697237, size.height * 0.2004220);
    path_4.lineTo(size.width * 0.3799583, size.height * 0.1614670);
    path_4.close();
    path_4.moveTo(size.width * 0.5505654, size.height * 0.1548528);
    path_4.lineTo(size.width * 0.3748410, size.height * 0.1548576);
    path_4.lineTo(size.width * 0.3748410, size.height * 0.2070315);
    path_4.lineTo(size.width * 0.5505660, size.height * 0.2070267);
    path_4.lineTo(size.width * 0.5505654, size.height * 0.1548528);
    path_4.close();
    path_4.moveTo(size.width * 0.9994744, size.height * 0.1548528);
    path_4.lineTo(size.width * 0.5505660, size.height * 0.1548528);
    path_4.lineTo(size.width * 0.5505660, size.height * 0.2070267);
    path_4.lineTo(size.width * 0.9994744, size.height * 0.2070267);
    path_4.lineTo(size.width * 0.9994744, size.height * 0.1548528);
    path_4.close();
    path_4.moveTo(size.width * 0.8032308, size.height * 0.9462457);
    path_4.lineTo(size.width * 1.005147, size.height * 0.1985589);
    path_4.lineTo(size.width * 0.9938013, size.height * 0.1633209);
    path_4.lineTo(size.width * 0.7918846, size.height * 0.9110065);
    path_4.lineTo(size.width * 0.8032308, size.height * 0.9462457);
    path_4.close();
    path_4.moveTo(size.width * 0.5660442, size.height * 0.9547130);
    path_4.lineTo(size.width * 0.7975577, size.height * 0.9547130);
    path_4.lineTo(size.width * 0.7975577, size.height * 0.9025391);
    path_4.lineTo(size.width * 0.5660442, size.height * 0.9025391);
    path_4.lineTo(size.width * 0.5660442, size.height * 0.9547130);
    path_4.close();
    path_4.moveTo(size.width * 0.5619391, size.height * 0.9943543);
    path_4.lineTo(size.width * 0.5723603, size.height * 0.9435152);
    path_4.lineTo(size.width * 0.5597276, size.height * 0.9137370);
    path_4.lineTo(size.width * 0.5493071, size.height * 0.9645739);
    path_4.lineTo(size.width * 0.5619391, size.height * 0.9943543);
    path_4.close();
    path_4.moveTo(size.width * 0.1154538, size.height * 0.9927783);
    path_4.lineTo(size.width * 0.5555571, size.height * 1.005550);
    path_4.lineTo(size.width * 0.5556885, size.height * 0.9533783);
    path_4.lineTo(size.width * 0.1155859, size.height * 0.9406065);
    path_4.lineTo(size.width * 0.1154538, size.height * 0.9927783);
    path_4.close();
    path_4.moveTo(size.width * -0.005362244, size.height * 0.6045022);
    path_4.lineTo(size.width * 0.1101577, size.height * 0.9853957);
    path_4.lineTo(size.width * 0.1208821, size.height * 0.9479891);
    path_4.lineTo(size.width * 0.005362244, size.height * 0.5670935);
    path_4.lineTo(size.width * -0.005362244, size.height * 0.6045022);
    path_4.close();
    path_4.moveTo(size.width * -0.007692308, size.height * 0.1462296);
    path_4.lineTo(size.width * -0.007692308, size.height * 0.5857978);
    path_4.lineTo(size.width * 0.007692308, size.height * 0.5857978);
    path_4.lineTo(size.width * 0.007692308, size.height * 0.1462296);
    path_4.lineTo(size.width * -0.007692308, size.height * 0.1462296);
    path_4.close();
    path_4.moveTo(size.width * 0.3633519, size.height * 0.1201426);
    path_4.lineTo(0, size.height * 0.1201426);
    path_4.lineTo(0, size.height * 0.1723165);
    path_4.lineTo(size.width * 0.3633519, size.height * 0.1723165);
    path_4.lineTo(size.width * 0.3633519, size.height * 0.1201426);
    path_4.close();

    Paint paint_4_fill = Paint()..style = PaintingStyle.fill;
    paint_4_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_4, paint_4_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
