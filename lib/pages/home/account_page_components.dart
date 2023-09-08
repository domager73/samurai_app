import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../api/rest.dart';
import '../../components/anim_button.dart';
import '../../components/bg.dart';
import '../../components/pop_up_spinner.dart';
import '../../components/samurai_text_field.dart';
import '../../components/show_error.dart';
import '../../components/storage.dart';
import 'package:get_it/get_it.dart';
import 'package:samurai_app/data/music_manager.dart';

class AccountPageComponents {
  static Future<void> openChangeEmailModalPage({
    required BuildContext context,
    required double width,
    required double height,
  }) async {
    Timer _timer;
    Timer _timer2;
    int? timerValueOld;
    int? timerValueNew;
    bool isAgree = false;

    TextEditingController newEmailController = TextEditingController();
    TextEditingController newEmailCodeController = TextEditingController();
    TextEditingController oldEmailCodeController = TextEditingController();

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) => GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: StatefulBuilder(
                builder: (context, StateSetter setState) => Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                      image: DecorationImage(
                          image: modalBottomsheetBg, fit: BoxFit.fill)),
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(28.0, 28.0, 28.0, 0.0),
                    // content padding
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            PresButton(
                              player: GetIt.I<MusicManager>().keyBackSignCloseX,
                              onTap: () async {
                                await GetIt.I<MusicManager>()
                                    .popupDownSybMenuPlayer
                                    .play()
                                    .then((value) async {
                                  await GetIt.I<MusicManager>()
                                      .popupDownSybMenuPlayer
                                      .seek(const Duration(seconds: 0));
                                });

                                Navigator.of(context).pop();
                              },
                              params: {'width': width},
                              child: backBtn,
                            ),
                            FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Center(
                                child: Text(
                                  'change',
                                  style: TextStyle(
                                    fontFamily: 'AmazObitaemOstrovItalic',
                                    fontSize: 37 / 844 * height,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: width * 0.12,
                              width: width * 0.12,
                            ),
                          ],
                        ),
                        Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Text(
                              "ENTER NEW E-MAIL",
                              style: GoogleFonts.spaceMono(
                                fontSize: 16 / 844 * height,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            )),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: SamuraiTextField(
                              controller: newEmailController,
                              screeenHeight: height,
                              screeenWidth: width,
                              hint: "New Email address",
                              keyboardType: TextInputType.emailAddress,
                            )),
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 16.0, left: 10.0, right: 10.0),
                            child: SamuraiTextField(
                                screeenHeight: height,
                                screeenWidth: width,
                                controller: oldEmailCodeController,
                                hint: "Old email code",
                                keyboardType: TextInputType.number,
                                buttonWithTimerEnabled: true,
                                timerValue: timerValueOld,
                                onTapTimerButton: () {
                                  Rest.changeMyEmail();
                                  setState(() {
                                    timerValueOld = 60;
                                  });
                                  _timer = Timer.periodic(
                                    const Duration(seconds: 1),
                                    (timer) {
                                      setState(() {
                                        timerValueOld = timerValueOld! - 1;
                                        if (timerValueOld == 0) {
                                          setState(() {
                                            timerValueOld = null;
                                            timer.cancel();
                                          });
                                        }
                                      });
                                    },
                                  );
                                })),
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 16.0, left: 10.0, right: 10.0),
                            child: SamuraiTextField(
                                screeenHeight: height,
                                screeenWidth: width,
                                controller: newEmailCodeController,
                                hint: "New email code",
                                keyboardType: TextInputType.number,
                                buttonWithTimerEnabled: true,
                                timerValue: timerValueNew,
                                onTapTimerButton: () {
                                  if (newEmailController.text.length >= 5) {
                                    Rest.changeEmail(newEmailController.text);
                                    setState(() {
                                      timerValueNew = 60;
                                    });
                                    _timer2 = Timer.periodic(
                                      const Duration(seconds: 1),
                                      (timer) {
                                        setState(() {
                                          timerValueNew = timerValueNew! - 1;
                                          if (timerValueNew == 0) {
                                            setState(() {
                                              timerValueNew = null;
                                              timer.cancel();
                                            });
                                          }
                                        });
                                      },
                                    );
                                  }
                                })),
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0,
                                left: 10.0,
                                right: 10.0,
                                bottom: 10.0),
                            child: PresButton(
                              onTap: () async {
                                showSpinner(context);

                                String request = await Rest.checkNewEmailCode(
                                    newEmailController.text,
                                    oldEmailCodeController.text,
                                    newEmailCodeController.text);

                                if (request == "true") {
                                  AppStorage().updateUserWallet();

                                  hideSpinner(context);
                                  Navigator.of(context).pop();
                                } else if ('is already registered. Please use unregistered email' ==
                                    request) {
                                  hideSpinner(context);
                                  showError(context,
                                          '\'${newEmailController.text}\' ${request}')
                                      .then((_) => Navigator.of(context).pop());
                                } else {
                                  hideSpinner(context);
                                  showError(context, request)
                                      .then((_) => Navigator.of(context).pop());
                                }
                              },
                              disabled: !(newEmailController.text.isNotEmpty &&
                                  oldEmailCodeController.text.isNotEmpty &&
                                  newEmailCodeController.text.isNotEmpty),
                              params: {
                                'text': 'confirm',
                                'width': width,
                                'height': height
                              },
                              child: loginBtn,
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            )).whenComplete(() async {
      await GetIt.I<MusicManager>()
          .popupDownSybMenuPlayer
          .play()
          .then((value) async {
        await GetIt.I<MusicManager>()
            .popupDownSybMenuPlayer
            .seek(const Duration(seconds: 0));
      });
    });
  }
}
