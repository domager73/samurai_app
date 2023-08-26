import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:samurai_app/components/storage.dart';
import 'package:samurai_app/pages/home/account_page_components.dart';
import 'package:samurai_app/utils/enums.dart';

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
  final AudioPlayer player = AudioPlayer();

  late final ScrollController scrollController;
  late bool googleAuthenticatorSwitch;
  late bool emailAuthenticatorSwitch;
  late bool soundSwitch;
  late bool tfaSwitch;

  @override
  void initState() {
    super.initState();

    setSwitchAsset();

    scrollController = ScrollController();
    googleAuthenticatorSwitch = false; //TODO
    emailAuthenticatorSwitch = false; //TODO
    soundSwitch = bool.parse(AppStorage().read(musicSwitchKey)!);
    print(bool.parse(AppStorage().read(musicSwitchKey)!));
    final useTfa = AppStorage().read('use-tfa');
    tfaSwitch = useTfa != null && useTfa == '1';

    GetIt.I<MusicManager>().screenChangePlayer.play().then((value) async {
      await GetIt.I<MusicManager>().screenChangePlayer.seek(Duration(seconds: 0));
    });
  }

  Future<void> setSwitchAsset() async {
    player.setAsset(MusicAssets.smallKeyWeaoponLighning);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                        style: TextStyle(
                          fontFamily: 'AmazObitaemOstrovItalic',
                          color: Colors.white,
                          fontSize: 38 / 960 * height,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: SizedBox(
                          width: width * 0.86,
                          height: 144 / 340 * width * 0.86,
                          child: Stack(
                            children: [
                              SvgPicture.asset(
                                'assets/pages/account/border.svg',
                                width: width * 0.86,
                              ),
                              Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      temp['email'] ?? '',
                                      style: GoogleFonts.spaceMono(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        fontSize: 16 / 960 * height,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 2 / 96 * height),
                                      child: PresButton(
                                        player: GetIt.I<MusicManager>().keyBackSignCloseX,
                                        onTap: () {
                                          GetIt.I<MusicManager>().popupSubmenuPlayer.play().then((value) => GetIt.I<MusicManager>().popupSubmenuPlayer.seek(Duration(seconds: 0)));
                                          AccountPageComponents.openChangeEmailModalPage(
                                            context: context,
                                            width: width,
                                            height: height,
                                          );
                                        },
                                        params: {'width': width, 'height': height},
                                        child: changeEmailBtn,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16 / 960 * height),
                        child: getMainAccountTextWidget(
                          height,
                          'Sound',
                          Switch(
                              // here
                              activeColor: const Color(0xFF00FFFF),
                              value: soundSwitch,
                              onChanged: (value) async {
                                // GetIt.I<MusicManager>().smallKeyWeaponPlayer.play().then((value) async {
                                //   await GetIt.I<MusicManager>().smallKeyWeaponPlayer.seek(Duration(seconds: 0));
                                // });
                                await player.play().then((value) => player.seek(Duration.zero));

                                soundSwitch = value;
                                AppStorage().write(musicSwitchKey, value.toString());
                                log("changed music value $value");

                                setState(() {});

                                if (value) {
                                  await MyApp.playPlayer(context);
                                } else {
                                  await MyApp.stopPlayer(context);
                                }
                              }),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16 / 960 * height),
                        child: getMainAccountTextWidget(
                          height,
                          '2FA',
                          Switch(
                            activeColor: const Color(0xFF00FFFF),
                            value: tfaSwitch,
                            onChanged: (value) => setState(() {
                              GetIt.I<MusicManager>().smallKeyWeaponPlayer.play().then((value) async {
                                await GetIt.I<MusicManager>().smallKeyWeaponPlayer.seek(Duration(seconds: 0));
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
                              await GetIt.I<MusicManager>().smallKeyLightningPlayer.play().then((value) async {
                                await GetIt.I<MusicManager>().smallKeyLightningPlayer.seek(Duration(seconds: 0));
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
                              await GetIt.I<MusicManager>().smallKeyLightningPlayer.play().then((value) async {
                                await GetIt.I<MusicManager>().smallKeyLightningPlayer.seek(Duration(seconds: 0));
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
                            showConfirm(context, 'Are you sure you want to get out?', () async {
                              await AppStorage().remove('jwt');
                              await AppStorage().remove('user');
                              if (mounted) {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/login',
                                  (route) => false,
                                );
                              }
                            });
                          },
                          params: {'width': width, 'height': height},
                          child: logoutBtn,
                        ),
                      ),
                      SizedBox(height: height * 0.03),
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
