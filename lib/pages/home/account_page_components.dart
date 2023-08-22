import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    int? timerValue;
    bool isAgree = false;
    String email = '';
    String code = '';
    String newcode = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (context, StateSetter setState) => Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
              image: DecorationImage(image: modalBottomsheetBg, fit: BoxFit.fill)),
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28.0, 28.0, 28.0, 0.0), // content padding
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Row(
                  children: [
                    PresButton(
                      player: GetIt.I<MusicManager>().popupDownSybMenuPlayer,
                      onTap: () => Navigator.of(context).pop(),
                      params: {'width': width},
                      child: backBtn,
                    ),
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.1,
                        ),
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
                    ),
                    SizedBox(
                      height: width * 0.12,
                      width: width * 0.12,
                    ),
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
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
                      screeenHeight: height,
                      screeenWidth: width,
                      hint: "New Email address",
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) => setState(
                        () {
                          email = value;
                        },
                      ),
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 16.0, left: 10.0, right: 10.0),
                    child: SamuraiTextField(
                        screeenHeight: height,
                        screeenWidth: width,
                        hint: "Old email verification code",
                        keyboardType: TextInputType.number,
                        onChanged: (value) => setState(() {
                              code = value;
                            }),
                        buttonWithTimerEnabled: true,
                        timerValue: timerValue,
                        onTapTimerButton: () {
                          if (email.isNotEmpty) {
                            Rest.changeEmail(email);
                            setState(() {
                              timerValue = 60;
                            });
                            _timer = Timer.periodic(
                              const Duration(seconds: 1),
                              (timer) {
                                setState(() {
                                  timerValue = timerValue! - 1;
                                  if (timerValue == 0) {
                                    setState(() {
                                      timerValue = null;
                                      timer.cancel();
                                    });
                                  }
                                });
                              },
                            );
                          }
                        })),
                Padding(
                    padding: const EdgeInsets.only(top: 16.0, left: 10.0, right: 10.0),
                    child: SamuraiTextField(
                      screeenHeight: height,
                      screeenWidth: width,
                      hint: "New Email verification code",
                      keyboardType: TextInputType.number,
                      onChanged: (value) => setState(() {
                        newcode = value;
                      }),
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
                    child: PresButton(
                      onTap: () async {
                        if (email.isNotEmpty && code.isNotEmpty && newcode.isNotEmpty) {
                          showSpinner(context);
                          Rest.checkNewEmailCode(email, code, newcode).then((_) {
                            AppStorage().updateUserWallet().then((_) {
                              hideSpinner(context);
                              Navigator.of(context).pop();
                            }).catchError((e) {
                              hideSpinner(context);
                            });
                          }).catchError((e) {
                            hideSpinner(context);
                            if (kDebugMode) {
                              print(e);
                            }
                            showError(context, 'Wrong code').then((_) => Navigator.of(context).pop());
                          });
                        }
                      },
                      disabled: !(email.isNotEmpty && code.isNotEmpty && newcode.isNotEmpty),
                      params: {'text': 'confirm', 'width': width, 'height': height},
                      child: loginBtn,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
