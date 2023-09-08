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
import '../../widgets/painters/account_border.dart';
import '../../widgets/painters/button_change_email.dart';

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
                                    textPadding: EdgeInsets.only(bottom: 10),
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