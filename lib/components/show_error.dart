import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samurai_app/components/anim_button.dart';
import 'package:samurai_app/data/music_manager.dart';

import 'bg.dart';

Future<void> showError(BuildContext context, dynamic err, {int type = 0}) async {
  await GetIt.I<MusicManager>().modalTextExplainPlayer.play().then((value) async {
    await GetIt.I<MusicManager>().modalTextExplainPlayer.seek(Duration(seconds: 0));
  });

  await showDialog(
    context: context,
    builder: (context) => ErrorDialog(err.toString(), type),
  );
}

class ErrorDialog extends StatelessWidget {
  const ErrorDialog(this.err, this.type, {super.key});
  final String err;
  final int type;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    precacheImage(backgroundDialog, context);
    final fSz = height * (type == 0 ? 0.021 : 0.0167);

    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: err.toString(), style: GoogleFonts.spaceMono(fontSize: fSz, color: type == 0 ? const Color(0xFFFF0049) : Colors.white)),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    int countLines = (textPainter.size.width / (width - width * 0.2)).ceil();
    countLines += (RegExp(r'[\n]')).allMatches(err.toString()).length * 2;
    final heightText = countLines * textPainter.size.height;

    final hCont = heightText + height * (type == 0 ? 0.236 : 0.188);

    return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: EdgeInsets.only(top: height * 0.25, bottom: height * 0.25, left: width * 0.02, right: width * 0.02),
        child: Container(
            height: hCont,
            width: width - width * 0.16,
            decoration: const BoxDecoration(
              image: DecorationImage(image: backgroundDialog, fit: BoxFit.fill),
            ),
            child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                  padding: EdgeInsets.only(left: width * 0.04, right: width * 0.04, top: height * 0.04),
                  height: hCont - height * 0.125,
                  child: Text(err.toString(), style: GoogleFonts.spaceMono(fontSize: fSz, color: type == 0 ? const Color(0xFFFF0049) : Colors.white), maxLines: 10, softWrap: true)),
              Container(
                  padding: EdgeInsets.only(top: height * 0.00),
                  height: height * 0.1,
                  child: AnimButton(
                    shadowType: 1,
                    onTap: () async {
                      await GetIt.I<MusicManager>().okCanselTransPlayer.play().then((value) async {
                        await GetIt.I<MusicManager>().okCanselTransPlayer.seek(Duration(seconds: 0));
                      });
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(
                      'assets/pages/dialog/ok_btn.svg',
                      fit: BoxFit.fitWidth,
                    ),
                  ))
            ])));
  }
}

Future<void> showError0(BuildContext context, dynamic err) async {
  await GetIt.I<MusicManager>().modalTextExplainPlayer.play().then((value) async {
    await GetIt.I<MusicManager>().modalTextExplainPlayer.seek(Duration(seconds: 0));
  });

  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Error'),
      content: Text(err.toString()),
      actions: [
        Padding(
            padding: const EdgeInsets.only(top: 1.0, bottom: 0.0, left: 30.0, right: 0.0),
            child: SizedBox(
                height: 63,
                child: TextButton(
                    onPressed: () async{
                                            await GetIt.I<MusicManager>().okCanselTransPlayer.play().then((value) async {
                        await GetIt.I<MusicManager>().okCanselTransPlayer.seek(Duration(seconds: 0));
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('OK', style: TextStyle(fontSize: 17, color: Colors.white)))))
      ],
    ),
  );
}
