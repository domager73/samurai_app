import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:samurai_app/api/rest.dart';
import 'package:samurai_app/components/pop_up_spinner.dart';
import 'package:samurai_app/components/samurai_text_field.dart';
import 'package:samurai_app/components/storage.dart';
import 'package:samurai_app/widgets/popups/custom_popup.dart';

import '../components/anim_button.dart';
import '../components/bg.dart';
import '../data/music_manager.dart';

class TfaPage extends StatefulWidget {
  const TfaPage({super.key});

  @override
  State<TfaPage> createState() => _TfaPageState();
}

class _TfaPageState extends State<TfaPage> {
  Timer? _timer;
  int? timerValue;
  String code = '';

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  void login(BuildContext context) {
    if (code.isNotEmpty) {
      showSpinner(context);
      Rest.check2faCode(code).then((data) {
        if (kDebugMode) {
          print(data);
        }
        AppStorage().write('tfacode', code).then((_) {
          hideSpinner(context);
          Navigator.of(context).pop(true);
        });
      }).catchError((e) {
        hideSpinner(context);
        debugPrint(e.toString());
          showDialog(
          context: context,
          builder: (context) => const CustomPopup(text: 'Wrong code', isError: true),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    precacheImage(backgroundLogin, context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF020A38),
      body: Stack(
        children: [
          Transform.translate(
            offset: Offset(0.0, -MediaQuery.of(context).viewInsets.bottom),
            child: SizedBox(
              width: width,
              height: height,
              child: const Image(
                image: backgroundLogin,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: getTopPadding(
                          height * 0.35,
                          MediaQuery.of(context).viewInsets.bottom,
                        ),
                        left: width * 0.03,
                        right: width * 0.03
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/pages/start/logo.svg',
                            height: height * 0.12,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: height * 0.03),
                            child: SvgPicture.asset(
                              'assets/pages/start/logo_text.svg',
                              height: height * 0.075,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: height * 0.08,
                        left: width * 0.03,
                        right: width * 0.03
                    ),
                    child: SamuraiTextField(
                      screeenHeight: height,
                      screeenWidth: width,
                      hint: "2FA code",
                      onChanged: (value) => setState(() {
                        code = value;
                      }),
                      buttonWithTimerEnabled: true,
                      timerValue: timerValue,
                      keyboardType: TextInputType.number,
                      onTapTimerButton: () {
                        final res = AppStorage().getUser();
                        if (kDebugMode) {
                          print(res);
                        }
                        if (res['email'] != null) {
                          Rest.sendTFACode(res['email']).then((res) {
                            if (!res) {
                              _timer?.cancel();
                              timerValue = null;
                            }
                          }).catchError((_) { });
                          setState(() {
                            timerValue = 60;
                          });
                          _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                            if (!mounted) {
                              timer.cancel();
                            }
                            setState(() {
                              timerValue = timerValue! - 1;
                              if (timerValue == 0) {
                                setState(() {
                                  timerValue = null;
                                  timer.cancel();
                                });
                              }
                            });
                          });
                        }
                      }
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: height * 0.02, bottom: height * 0.08),
                    child: PresButton(
                      onTap: () => login(context),
                      disabled: code.isEmpty,
                      params: {'text': 'enter code', 'width': width, 'height': height},
                      child: loginBtn,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: height * 0.04,
              left: width * 0.04
            ),
            child:PresButton(
              onTap: () => Navigator.of(context).pop(false),
              params: {'width': width},
              child: backBtn,
              player: GetIt.I<MusicManager>().keyBackSignCloseX,
            )
          )
        ],
      ),
    );
  }

  double getTopPadding(double height, double keyboard) {
    if (height - keyboard < 28) {
      return 28;
    } else {
      return height - keyboard;
    }
  }
}
