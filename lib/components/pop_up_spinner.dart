import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:samurai_app/data/music_manager.dart';

Future<void> showSpinner(BuildContext context, {bool? barrierDismissible = false}) async {
  await GetIt.I<MusicManager>().menuSettingsSignWaterPlayer.play().then((value) async {
    await GetIt.I<MusicManager>().menuSettingsSignWaterPlayer.seek(Duration(seconds: 0));
  });

  showDialog(context: context, barrierDismissible: false, builder: (_) => reqtangleSpinner(context));
}

void hideSpinner(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop();
}

Widget reqtangleSpinner(context) => Center(
        child: Container(
      width: MediaQuery.of(context).size.width * 0.2,
      height: MediaQuery.of(context).size.width * 0.2,
      decoration: const ShapeDecoration(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(14.0),
          ),
        ),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xff8A898E)),
        ),
      ),
    ));
