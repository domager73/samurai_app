import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:samurai_app/components/pop_up_spinner.dart';
import 'package:samurai_app/components/storage.dart';
import 'package:samurai_app/pages/home/account_page_components.dart';
import 'package:samurai_app/utils/enums.dart';
import 'package:samurai_app/utils/fonts.dart';
import 'package:samurai_app/widgets/buttons/custom_painter_button.dart';
import 'package:samurai_app/widgets/popups/custom_choose_popup.dart';

import '../../api/rest.dart';
import '../../components/anim_button.dart';
import '../../components/show_confirm.dart';
import '../../data/music_manager.dart';
import '../../main.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late final ScrollController scrollController;
  late bool googleAuthenticatorSwitch;
  late bool emailAuthenticatorSwitch;
  late bool soundSwitch;
  late bool tfaSwitch;
  late BehaviorSubject<bool> stream = BehaviorSubject<bool>.seeded(false);

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    googleAuthenticatorSwitch = false; //TODO
    emailAuthenticatorSwitch = false; //TODO
    soundSwitch = bool.parse(AppStorage().read(musicSwitchKey)!);
    final useTfa = AppStorage().read('use-tfa');
    tfaSwitch = useTfa != null && useTfa == '1';

    GetIt.I<MusicManager>().screenChangePlayer.play().then((value) async {
      await GetIt.I<MusicManager>()
          .screenChangePlayer
          .seek(Duration(seconds: 0));
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> setPlayer(bool value) async {
      if (value) {
        showSpinner(context);

        await MyApp.playPlayer(context);

        hideSpinner(context);
      } else {
        await MyApp.stopPlayer(context);
      }
    }

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return ValueListenableBuilder(
        valueListenable: AppStorage().box.listenable(),
        builder: (context, box, widget) {
          dynamic temp = box.get(
            'user',
            defaultValue: <String, dynamic>{},
          );
          temp = Map.from(temp);

          return Scaffold(
            backgroundColor: Colors.transparent,
            body: RawScrollbar(
              radius: const Radius.circular(36),
              thumbColor: const Color(0xFF00FFFF),
              thumbVisibility: true,
              controller: scrollController,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.07),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      Text(
                        'ACCOUNT',
                        style: AppTypography.amazObitW400White
                            .copyWith(fontSize: 36),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: SizedBox(
                          width: width * 0.86,
                          height: 144 / 340 * width * 0.86,
                          child: CustomPaint(
                            painter: AccountBorderPainter(),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FittedBox(
                                    child: Text(temp['email'] ?? '',
                                        style:
                                            AppTypography.spaseMono16.copyWith(
                                          fontWeight: FontWeight.w700,
                                        )),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  CustomPainterButton(
                                    player: GetIt.I<MusicManager>()
                                        .keyBackSignCloseX,
                                    onTap: () {
                                      GetIt.I<MusicManager>()
                                          .popupSubmenuPlayer
                                          .play()
                                          .then((value) =>
                                              GetIt.I<MusicManager>()
                                                  .popupSubmenuPlayer
                                                  .seek(Duration(seconds: 0)));
                                      AccountPageComponents
                                          .openChangeEmailModalPage(
                                        context: context,
                                        width: width,
                                        height: height,
                                      );
                                    },
                                    painter: ChangeEmailPointer(),
                                    height: 60,
                                    width: width * 0.5,
                                    text: 'Change',
                                    style: AppTypography.amazObit19Blue,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16 / 960 * height),
                        child: getMainAccountTextWidget(
                          height,
                          'Sound',
                          StreamBuilder<bool>(
                              stream: stream,
                              builder: (context, snapshot) {
                                return AbsorbPointer(
                                  absorbing: snapshot.data ?? false,
                                  child: Switch(
                                      activeColor: const Color(0xFF00FFFF),
                                      value: soundSwitch,
                                      onChanged: (value) async {
                                        stream.add(true);

                                        soundSwitch = value;
                                        setState(() {});

                                        await GetIt.I<MusicManager>()
                                            .smallKeyWeaponPlayer
                                            .play()
                                            .then((value) =>
                                                GetIt.I<MusicManager>()
                                                    .smallKeyWeaponPlayer
                                                    .seek(Duration.zero));

                                        AppStorage().write(
                                            musicSwitchKey, value.toString());
                                        log("changed music value $value");

                                        await setPlayer(value);

                                        await Future.delayed(
                                            Duration(milliseconds: 500));

                                        stream.add(false);
                                      }),
                                );
                              }),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16 / 960 * height),
                        child: getMainAccountTextWidget(
                          height,
                          'E-mail Authenticator',
                          Switch(
                            activeColor: const Color(0xFF00FFFF),
                            value: tfaSwitch,
                            onChanged: (value) => setState(() {
                              GetIt.I<MusicManager>()
                                  .smallKeyWeaponPlayer
                                  .play()
                                  .then((value) async {
                                await GetIt.I<MusicManager>()
                                    .smallKeyWeaponPlayer
                                    .seek(Duration(seconds: 0));
                              });

                              tfaSwitch = value;
                              AppStorage().write('use-tfa', value ? '1' : '0');
                              Rest.checkUpdateUserUseTfa(value);
                            }),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16 / 960 * height),
                        child: getMainAccountTextWidget(
                          height,
                          "Terms of Use",
                          IconButton(
                            onPressed: () async {
                              await GetIt.I<MusicManager>()
                                  .smallKeyLightningPlayer
                                  .play()
                                  .then((value) async {
                                await GetIt.I<MusicManager>()
                                    .smallKeyLightningPlayer
                                    .seek(Duration(seconds: 0));
                              });
                            }, //TODO
                            icon: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Color(0xFF00FFFF),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16 / 960 * height),
                        child: getMainAccountTextWidget(
                          height,
                          "Privacy Policy",
                          IconButton(
                            onPressed: () async {
                              await GetIt.I<MusicManager>()
                                  .smallKeyLightningPlayer
                                  .play()
                                  .then((value) async {
                                await GetIt.I<MusicManager>()
                                    .smallKeyLightningPlayer
                                    .seek(Duration(seconds: 0));
                              });
                            }, //TODO
                            icon: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Color(0xFF00FFFF),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16 / 960 * height),
                        child: getSecondaryAccountTextWidget(
                          height,
                          "Version",
                          AppStorage().read('appVer').toString(),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 3 / 96 * height),
                        child: getSeporator(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16 / 960 * height),
                        child: getSecondaryAccountTextWidget(
                          height,
                          "Total battles",
                          '0', //TODO
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16 / 960 * height),
                        child: getSeporator(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16 / 960 * height),
                        child: getSecondaryAccountTextWidget(
                          height,
                          "Earned RYO",
                          '0', //TODO
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16 / 960 * height),
                        child: getSeporator(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 3 / 96 * height),
                        child: PresButton(
                          player: GetIt.I<MusicManager>().keyBackSignCloseX,
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => CustomChoosePopup(
                                    acceptFunction: () async {
                                      await AppStorage().remove('jwt');
                                      await AppStorage().remove('user');
                                      if (mounted) {
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                          '/login',
                                          (route) => false,
                                        );
                                      }
                                    },
                                    canselFunction: () {
                                      Navigator.pop(context);
                                    },
                                    text: "Are you sure you want to get out?"));
                          },
                          params: {'width': width, 'height': height},
                          child: logoutBtn,
                        ),
                      ),
                      SizedBox(height: height * 0.05),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget getMainAccountTextWidget(
    double height,
    String title,
    Widget endWidget,
  ) {
    return SizedBox(
      height: 4 / 96 * height,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.spaceMono(
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontSize: 17 / 960 * height,
              ),
            ),
          ),
          SizedBox(
            height: 4 / 96 * height,
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: endWidget,
            ),
          ),
        ],
      ),
    );
  }

  Widget getSecondaryAccountTextWidget(
    double height,
    String title,
    String endTitle,
  ) {
    return SizedBox(
      height: 4 / 96 * height,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.spaceMono(
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontSize: 17 / 960 * height,
              ),
            ),
          ),
          Text(
            endTitle,
            style: GoogleFonts.spaceMono(
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontSize: 16 / 960 * height,
            ),
          ),
        ],
      ),
    );
  }

  Widget getSeporator() {
    return Container(
      width: double.infinity,
      height: 1,
      decoration: BoxDecoration(
        color: const Color(0xFF212121),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
        ),
      ),
    );
  }
}

class AccountBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.002924006, size.height * 0.2630035);
    path_0.lineTo(size.width * 0.002923977, size.height * 0.9962028);
    path_0.lineTo(size.width * 0.2947193, size.height * 0.9962028);
    path_0.lineTo(size.width * 0.3144444, size.height * 0.9417552);
    path_0.lineTo(size.width * 0.9501550, size.height * 0.9417552);
    path_0.lineTo(size.width * 0.9970760, size.height * 0.8002028);
    path_0.lineTo(size.width * 0.9970760, size.height * 0.008923916);
    path_0.lineTo(size.width * 0.6964854, size.height * 0.008923916);
    path_0.lineTo(size.width * 0.6803538, size.height * 0.05248035);
    path_0.lineTo(size.width * 0.07477281, size.height * 0.05248035);
    path_0.lineTo(size.width * 0.002924006, size.height * 0.2630035);
    path_0.close();

    Paint paint_0_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_0_stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_stroke);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.5438596, size.height * 0.008924056);
    path_1.lineTo(size.width * 0.07309942, size.height * 0.008923916);

    Paint paint_1_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_1_stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_stroke);

    Path path_2 = Path();
    path_2.moveTo(size.width * 0.9502924, size.height * 0.9889441);
    path_2.lineTo(size.width * 0.4415205, size.height * 0.9889441);

    Paint paint_2_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_2_stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class ChangeEmailPointer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.7301980, size.height * 0.9380020);
    path_0.lineTo(size.width * 0.2735827, size.height * 0.9380020);

    Paint paint_0_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.005940594;
    paint_0_stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_stroke);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.2500000, size.height * 0.7924720);
    path_1.lineTo(size.width * 0.2485866, size.height * 0.7924720);
    path_1.lineTo(size.width * 0.2478683, size.height * 0.7973900);
    path_1.lineTo(size.width * 0.2364564, size.height * 0.8755200);
    path_1.lineTo(size.width * 0.002475248, size.height * 0.8755200);
    path_1.lineTo(size.width * 0.002475248, size.height * 0.5796920);
    path_1.lineTo(size.width * 0.1305094, size.height * 0.02352060);
    path_1.lineTo(size.width * 0.9975248, size.height * 0.02352060);
    path_1.lineTo(size.width * 0.9975248, size.height * 0.4198940);
    path_1.lineTo(size.width * 0.9058960, size.height * 0.7924720);
    path_1.lineTo(size.width * 0.2500000, size.height * 0.7924720);
    path_1.close();

    Paint paint_1_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_1_stroke.color = Color(0xff00FFFF).withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_stroke);

    Path path_2 = Path();
    path_2.moveTo(size.width * 0.8286782, size.height * 0.9809880);
    path_2.lineTo(size.width * 0.8445050, size.height * 0.8855220);
    path_2.lineTo(size.width * 0.9014109, size.height * 0.8855220);
    path_2.lineTo(size.width * 0.8871832, size.height * 0.9809880);
    path_2.lineTo(size.width * 0.8286782, size.height * 0.9809880);
    path_2.close();

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.color = Color(0xffFF0049).withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_fill);

    Path path_3 = Path();
    path_3.moveTo(size.width * 0.7475248, size.height * 0.9809880);
    path_3.lineTo(size.width * 0.7633515, size.height * 0.8855220);
    path_3.lineTo(size.width * 0.8202574, size.height * 0.8855220);
    path_3.lineTo(size.width * 0.8060347, size.height * 0.9809880);
    path_3.lineTo(size.width * 0.7475248, size.height * 0.9809880);
    path_3.close();

    Paint paint_3_fill = Paint()..style = PaintingStyle.fill;
    paint_3_fill.color = Color(0xffFF0049).withOpacity(1.0);
    canvas.drawPath(path_3, paint_3_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
