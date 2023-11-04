import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:samurai_app/api/rest.dart';
import 'package:samurai_app/components/samurai_text_field.dart';
import 'package:samurai_app/components/storage.dart';
import 'package:samurai_app/utils/colors.dart';
import 'package:samurai_app/utils/fonts.dart';
import 'package:samurai_app/widgets/buttons/custom_painter_button.dart';
import 'package:samurai_app/widgets/popups/custom_popup.dart';

import '../components/bg.dart';
import '../components/pop_up_spinner.dart';
import '../data/music_manager.dart';
import '../widgets/painters/button_login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late Timer _timer;
  int? timerValue;
  bool isAgree = false;
  String email = '';
  String code = '';
  bool errorTerms = false;
  bool errorLoging = false;

  bool errorEmailField = false;
  bool errorCodeField = false;

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  void login() {
    if (email.isNotEmpty && code.isNotEmpty && isAgree) {
      setState(() {
        errorEmailField = email.isEmpty;
        errorCodeField = code.isEmpty;
      });

      showSpinner(context);
      Rest.checkCode(email, code).then((data) {
        final useTfa = AppStorage().read('use-tfa');
        AppStorage()
            .write('jwt', data['jwt'])
            .then((_) => AppStorage().updateUserWallet().then((_) {
                  hideSpinner(context);
                  Navigator.of(context).pushReplacementNamed('/home');
                }));
      }).catchError((e) {
        hideSpinner(context);
        debugPrint(e.toString());

        showDialog(
          context: context,
          builder: (context) =>
              const CustomPopup(text: 'Wrong code', isError: true),
        );
      });
    } else {
      setState(() {
        if (!isAgree) {
          errorTerms = true;
        }

        errorEmailField = email.isEmpty;
        errorCodeField = code.isEmpty;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    precacheImage(backgroundLogin, context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Container(
            width: width,
            height: height,
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: backgroundLogin,
              fit: BoxFit.fitHeight,
            )),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(
                    'assets/pages/start/logo.png',
                    height: height * 0.22,
                    fit: BoxFit.fill,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 28.0, left: width * 0.03, right: width * 0.03),
                    child: SamuraiTextField(
                      screeenHeight: height,
                      screeenWidth: width,
                      withError: errorEmailField,
                      hint: "Email address",
                      onChanged: (value) => setState(() {
                        email = value;
                      }),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 16.0, left: width * 0.03, right: width * 0.03),
                    child: SamuraiTextField(
                      screeenHeight: height,
                      screeenWidth: width,
                      withError: errorCodeField,
                      hint: "Email code",
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
                    padding: EdgeInsets.only(
                        top: 12, left: width * 0.03, right: width * 0.03),
                    child: Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: height * 0.03,
                          height: height * 0.03,
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF00FFFF)),
                          ),
                          child: Checkbox(
                            side: MaterialStateBorderSide.resolveWith(
                                (states) => BorderSide(
                                    width: 2,
                                    color: errorTerms
                                        ? Colors.red
                                        : Colors.transparent)),
                            value: isAgree,
                            onChanged: (value) async {
                              GetIt.I<MusicManager>()
                                  .smallKeyWeaponPlayer
                                  .play()
                                  .then((value) async {
                                await GetIt.I<MusicManager>()
                                    .smallKeyWeaponPlayer
                                    .seek(Duration(seconds: 0));
                              });

                              setState(() {
                                errorTerms = false;
                                isAgree = !isAgree;
                              });
                            },
                            fillColor: MaterialStateProperty.all(
                              Colors.transparent,
                            ),
                            checkColor: const Color(0xFF00FFFF),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: FittedBox(
                            child: RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text: "I agree ",
                                  style: AppTypography.spaceMonoW400),
                              TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {},
                                  text: "Terms of Use",
                                  style: AppTypography.spaceMonoW400.copyWith(
                                      color: AppColors.textBlue, fontSize: 14)),
                              TextSpan(
                                  text: " & ",
                                  style: AppTypography.spaceMonoW400),
                              TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {},
                                  text: "Privacy Policy",
                                  style: AppTypography.spaceMonoW400
                                      .copyWith(color: AppColors.textBlue)),
                            ])),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 28),
                    child: CustomPainterButton(
                      onTap: login,
                      width: width,
                      height: 112,
                      painter: ButtonLoginPainter(),
                      text: 'login/sing up',
                      player:
                          GetIt.I<MusicManager>().menuSettingsSignWaterPlayer,
                      style:
                          AppTypography.amazObit17Dark.copyWith(fontSize: 22),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  double getTopPadding(double height, double keyboard) =>
      height - keyboard < 28 ? 28 : height - keyboard;
}
