import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samurai_app/api/rest.dart';
import 'package:samurai_app/components/samurai_text_field.dart';
import 'package:samurai_app/components/storage.dart';
import 'package:samurai_app/widgets/popups/custom_popup.dart';

import '../components/anim_button.dart';
import '../components/bg.dart';
import '../components/pop_up_spinner.dart';
import '../components/show_error.dart';
import '../data/music_manager.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late Timer _timer;
  int? timerValue;
  bool isAgree = true;
  String email = '';
  String code = '';
  bool errorTerms = false;
  bool errorLoging = false;

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  void login() {
    if (email.isNotEmpty && isAgree) {
      showSpinner(context);
      Rest.checkCode(email, code).then((data) {
        final useTfa = AppStorage().read('use-tfa');
        AppStorage().write('jwt', data['jwt']).then((_) => AppStorage().updateUserWallet().then((_) {
              hideSpinner(context);
              Navigator.of(context).pushReplacementNamed('/home');
            }));
      }).catchError((e) {
        hideSpinner(context);
        debugPrint(e.toString());

        showDialog(
          context: context,
          builder: (context) => const CustomPopup(text: 'Wrong code', isError: true),
        );
      });
    } else {
      if (!isAgree) {
        setState(() {
          errorTerms = true;
        });
      }
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
                        right: width * 0.03),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/pages/start/logo.svg',
                            height: height * 0.12,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
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
                    padding: EdgeInsets.only(top: 28.0, left: width * 0.03, right: width * 0.03),
                    child: SamuraiTextField(
                      screeenHeight: height,
                      screeenWidth: width,
                      hint: "Email address",
                      onChanged: (value) => setState(() {
                        email = value;
                      }),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0, left: width * 0.03, right: width * 0.03),
                    child: SamuraiTextField(
                      screeenHeight: height,
                      screeenWidth: width,
                      hint: "Email verification code",
                      onChanged: (value) => setState(
                        () {
                          code = value;
                        },
                      ),
                      buttonWithTimerEnabled: true,
                      timerValue: timerValue,
                      keyboardType: TextInputType.number,
                      onTapTimerButton: () {
                        if (email.isEmpty) {
                          return;
                        }
                        Rest.sendCode(email);
                        setState(
                          () {
                            timerValue = 60;
                          },
                        );
                        _timer = Timer.periodic(
                          const Duration(seconds: 1),
                          (timer) {
                            if (!mounted) {
                              timer.cancel();
                            }
                            setState(
                              () {
                                timerValue = timerValue! - 1;
                                if (timerValue == 0) {
                                  setState(() {
                                    timerValue = null;
                                    timer.cancel();
                                  });
                                }
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 12, left: width * 0.03, right: width * 0.03),
                    child: Row(
                      children: [
                        Container(
                          width: height * 0.03,
                          height: height * 0.03,
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF00FFFF)),
                          ),
                          child: Checkbox(
                            value: isAgree,
                            onChanged: (value) async {
                              GetIt.I<MusicManager>().smallKeyWeaponPlayer.play().then((value) async {
                                await GetIt.I<MusicManager>().smallKeyWeaponPlayer.seek(Duration(seconds: 0));
                              });

                              setState(() {
                                errorTerms = false;
                                isAgree = !isAgree;
                              });
                            },
                            fillColor: MaterialStateProperty.all(
                              errorTerms ? Colors.red : Colors.transparent,
                            ),
                            checkColor: const Color(0xFF00FFFF),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                        FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              "  I agree",
                              style: GoogleFonts.spaceMono(
                                fontSize: height * 0.015,
                                height: 1.5,
                                color: Colors.white,
                              ),
                            )),
                        Expanded(
                          flex: 9,
                          child: InkWell(
                            onTap: () => {},
                            borderRadius: BorderRadius.circular(5),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    "Terms of Use", //TODO
                                    style: GoogleFonts.spaceMono(
                                      fontSize: height * 0.015,
                                      height: 1.5,
                                      color: const Color(0xFF00FFFF),
                                    ),
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                          ),
                        ),
                        FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              "&",
                              style: GoogleFonts.spaceMono(
                                fontSize: height * 0.015,
                                height: 1.5,
                                color: Colors.white,
                              ),
                            )),
                        Expanded(
                          flex: 10,
                          child: InkWell(
                            onTap: () => {}, //TODO
                            borderRadius: BorderRadius.circular(5),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    "Privacy Policy",
                                    style: GoogleFonts.spaceMono(
                                      fontSize: height * 0.015,
                                      height: 1.5,
                                      color: const Color(0xFF00FFFF),
                                    ),
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 28),
                    child: PresButton(
                      onTap: login,
                      params: {'text': 'login/sign up', 'width': width, 'height': height},
                      child: loginBtn,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double getTopPadding(double height, double keyboard) => height - keyboard < 28 ? 28 : height - keyboard;
}
