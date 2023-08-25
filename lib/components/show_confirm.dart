import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samurai_app/components/anim_button.dart';
import 'package:get_it/get_it.dart';
import 'package:samurai_app/data/music_manager.dart';
import 'bg.dart';

Future<void> showConfirm(BuildContext context, dynamic text, Function onConfirm, {String? price}) async {
  await showDialog<bool>(
    context: context,
    builder: (context) => ConfirmDialog(text.toString(), onConfirm, price),
  );
}

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog(this.text, this.onConfirm, this.price, {super.key});
  final String text;
  final Function onConfirm;
  final String? price;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    precacheImage(backgroundDialog, context);

    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: GoogleFonts.spaceMono()),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    int countLines = (textPainter.size.width / (width - width * 0.2)).ceil();
    countLines += (RegExp(r'[\n]')).allMatches(text).length * 2;
    final heightText = countLines * textPainter.size.height;
    //print("heightText=$heightText lines=$countLines len=${err.toString().length} width=$width height=$height");
    final hCont = heightText + width * 0.33;

    return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: EdgeInsets.only(top: width * 0.3, bottom: width * 0.3, left: width * 0.02, right: width * 0.02),
        child: Container(
            height: hCont + (price != null ? width * 0.085 : 0),
            width: width - width * 0.16,
            decoration: const BoxDecoration(
              image: DecorationImage(image: backgroundDialog, fit: BoxFit.fill),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(padding: EdgeInsets.only(top: width * 0.06, left: width * 0.05, right: width * 0.05), child: Text(text.toString(), textAlign: TextAlign.center, softWrap: true, style: GoogleFonts.spaceMono(fontSize: width * 0.04, color: Colors.white))),
                if (price != null)
                  Padding(
                      padding: EdgeInsets.only(top: width * 0.02, left: width * 0.05, right: width * 0.05, bottom: width * 0.01),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text('PRICE: ', textAlign: TextAlign.center, softWrap: true, style: GoogleFonts.spaceMono(fontSize: width * 0.035, color: const Color(0xFF00FFFF), fontWeight: FontWeight.w700)),
                        Text(price!, textAlign: TextAlign.center, softWrap: true, style: GoogleFonts.spaceMono(fontSize: width * 0.035, color: Colors.white, fontWeight: FontWeight.w700))
                      ])),
                Padding(
                    padding: EdgeInsets.only(bottom: width * 0.05),
                    child: Stack(alignment: AlignmentDirectional.topStart, children: [
                      Container(
                          margin: EdgeInsets.only(left: width * 0.00),
                          height: width * 0.099,
                          width: width * 0.35,
                          child: AnimButton(
                            player: GetIt.I<MusicManager>().okCanselTransPlayer,
                            shadowType: 1,
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: SvgPicture.asset(
                              'assets/pages/dialog/cancel_btn.svg',
                              fit: BoxFit.fitWidth,
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.only(left: width * 0.29, top: width * 0.015),
                          height: width * 0.099,
                          width: width * 0.35,
                          child: AnimButton(
                            player: GetIt.I<MusicManager>().okCanselTransPlayer,
                            shadowType: 1,
                            onTap: () {
                              onConfirm();
                            },
                            child: SvgPicture.asset(
                              'assets/pages/dialog/yes_btn.svg',
                              fit: BoxFit.fitWidth,
                            ),
                          ))
                    ]))
              ],
            )));
  }
}
