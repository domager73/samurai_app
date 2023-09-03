import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:samurai_app/components/pop_up_spinner.dart';
import 'package:samurai_app/components/storage.dart';
import 'package:samurai_app/data/music_manager.dart';
import 'package:samurai_app/pages/home/craft_page.dart';
import 'package:samurai_app/pages/home/home_main_page.dart';
import 'package:samurai_app/pages/home/wallet_page.dart';
import 'package:samurai_app/pages/pin_code_page.dart';
import 'package:samurai_app/utils/fonts.dart';
import 'package:samurai_app/widgets/popups/custom_popup.dart';

import '../components/anim_button.dart';
import '../components/bg.dart';
import 'home/account_page.dart';
import 'home/hero_mint_page.dart';
import 'home/heros_page.dart';
import 'home/samurai_mint_page.dart';

class HomePage extends StatefulWidget {
  final int initPageIdx;

  const HomePage({super.key, this.initPageIdx = 2});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedPage = 2;
  bool isMenuOpened = false;
  int craftSwitch = 0;
  int herosSwitch = 0;
  DateTime _lastUpdate = DateTime.now();

  late AudioPlayer audioPlayer;

  String craftSwitchKey = 'craftSwitch';

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
    ).then((value) {
      if (ModalRoute.of(context)!.settings.arguments != null) {
        if (ModalRoute.of(context)!.settings.arguments == 'wallet') {
          setState(() {
            selectedPage = 5;
          });
        }
        if (ModalRoute.of(context)!.settings.arguments == 'samurai') {
          setState(() {
            selectedPage = 0;
          });
        }

        if (ModalRoute.of(context)!.settings.arguments == 'heros') {
          setState(() {
            selectedPage = 1;
          });
        }
        if (ModalRoute.of(context)!.settings.arguments == 'heroMint0' || ModalRoute.of(context)!.settings.arguments == 'heroMint1') {
          herosSwitch = int.parse(ModalRoute.of(context)!.settings.arguments.toString().substring(8, 9));
          setState(() {
            selectedPage = 6;
          });
        }
        if (ModalRoute.of(context)!.settings.arguments == 'samuraiMint0' || ModalRoute.of(context)!.settings.arguments == 'samuraiMint1') {
          herosSwitch = int.parse(ModalRoute.of(context)!.settings.arguments.toString().substring(11, 12));
          setState(() {
            selectedPage = 8;
          });
        }
      }
    });

    GetIt.I<MusicManager>().screenChangePlayer.play().then((value) async {
      await GetIt.I<MusicManager>().screenChangePlayer.seek(Duration(seconds: 0));
    });

    craftSwitch = int.parse(AppStorage().read(craftSwitchKey) ?? '0');
    herosSwitch = int.parse(AppStorage().read(craftSwitchKey) ?? '0');
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('This is demo build'),
          content: const Text('Not for commercial use'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Add what should happen when the button is clicked here
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> updateBalances() async {
    if (_lastUpdate.microsecond < DateTime.now().subtract(const Duration(seconds: 30)).microsecond) {
      _lastUpdate = DateTime.now();
      AppStorage().updateUserWallet();
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    precacheImage(homeMainBg, context);
    precacheImage(homeForgeBg, context);
    precacheImage(homeStorageBg, context);
    precacheImage(heroMintWaterBg, context);
    precacheImage(heroMintFireBg, context);
    precacheImage(waterBg, context);
    precacheImage(fireBg, context);
    precacheImage(waterSamuraiImg, context);
    precacheImage(fireSamuraiImg, context);
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            image: selectedPage == 0 || selectedPage == 2 || selectedPage == 3 || selectedPage == 4 || selectedPage == 6
                ? DecorationImage(
                    image: selectedPage == 0
                        ? (craftSwitch == 0 ? waterBg : fireBg)
                        : selectedPage == 3
                            ? homeForgeBg
                            : selectedPage == 4
                                ? homeStorageBg
                                : selectedPage == 6
                                    ? (craftSwitch == 0 ? heroMintWaterBg : heroMintFireBg)
                                    : homeMainBg,
                    fit: BoxFit.fitWidth,
                  )
                : null),
        child: Stack(
          children: [
            if (!(selectedPage == 0 || selectedPage == 2 || selectedPage == 3 || selectedPage == 4 || selectedPage == 6))
              SizedBox(
                width: width,
                height: height,
                child: SvgPicture.asset(
                  'assets/background_gradient.svg',
                  fit: BoxFit.fitWidth,
                ),
              ),
            Container(
                width: width,
                height: height,
                padding: EdgeInsets.only(
                  top: 135 / 880 * height,
                  bottom: height - height * 0.9,
                ),
                child: getContent(width, height)),
            SizedBox(width: width, height: height, child: bottomNavigationAndAppBar(width, height, context)),
          ],
        ),
      ),
    );
  }

  Widget bottomNavigationAndAppBar(double width, double height, BuildContext context) {
    return Stack(
      children: [
        SizedBox(
            width: width,
            height: height,
            child: Column(children: [
              SizedBox(
                width: width,
                height: 112 / 880 * height,
                child: Stack(
                  children: [
                    SvgPicture.asset(
                      'assets/pages/homepage/appbar_background.svg',
                      width: width,
                      fit: BoxFit.fill,
                    ),
                    ValueListenableBuilder(
                      valueListenable: AppStorage().box.listenable(),
                      builder: (context, box, widget) {
                        final temp = box.get(
                          'user',
                          defaultValue: <String, dynamic>{},
                        );
                        Map<String, dynamic>? user;
                        if (temp != <String, dynamic>{}) {
                          user = Map.from(temp);
                        }
                        return Padding(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).viewPadding.top,
                            bottom: 12 / 880 * height,
                            left: 25 / 390 * width,
                            right: 25 / 390 * width,
                          ),
                          child: Center(
                            child: Row(
                              children: [
                                Material(
                                  color: Colors.transparent,
                                  child: PresButton(
                                    player: GetIt.I<MusicManager>().menuSettingsSignWaterPlayer, //menu
                                    onTap: () => setState(() {
                                      isMenuOpened = true;
                                    }),
                                    params: {'width': width},
                                    child: menuBtn,
                                  ),
                                ),
                                const Spacer(),
                                if (selectedPage == 5)
                                  AnimButton(
                                    player: GetIt.I<MusicManager>().menuSettingsSignWaterPlayer,
                                    shadowType: 2,
                                    onTap: () async {
                                      await GetIt.I<MusicManager>().popupSubmenuPlayer.play().then((value) async {
                                        await GetIt.I<MusicManager>().popupSubmenuPlayer.seek(Duration(seconds: 0));
                                      });
                                      openQr(width, height);
                                    }, // HERE
                                    child: SvgPicture.asset(
                                      'assets/pages/homepage/receive.svg',
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                const Spacer(),
                                if (selectedPage == 5)
                                  AnimButton(
                                      shadowType: 2,
                                      onTap: () async {
                                        showSpinner(context);

                                        await AppStorage().updateUserWallet();

                                        hideSpinner(context);
                                      },
                                      child: SvgPicture.asset(
                                        'assets/pages/homepage/trade.svg',
                                        fit: BoxFit.fitHeight,
                                      ))
                                else
                                  Row(children: [
                                    SvgPicture.asset(
                                      'assets/bnb_logo.svg',
                                      height: height * 0.04,
                                      fit: BoxFit.contain,
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(left: 10 / 390 * width, right: 20 / 390 * width),
                                        child: Text(double.parse(user?['bnb_balance'].toString() ?? '0.0').toStringAsFixed(5),
                                            style: GoogleFonts.spaceMono(
                                              fontSize: 16 / 844 * height,
                                              color: Colors.white,
                                            )))
                                  ]),
                                const Spacer(),
                                Material(
                                  color: Colors.transparent,
                                  child: selectedPage != 5
                                      ? PresButton(
                                          onTap: () {
                                            String? pin = AppStorage().read('pin');
                                            String? walletAdress = AppStorage().read('wallet_adress');
                                            String? walletMnemonic = AppStorage().read('wallet_mnemonic');
                                            if (walletAdress == null || walletMnemonic == null) {
                                              Navigator.pushReplacementNamed(context, '/createWallet');
                                            } else if (pin == null) {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                '/pin',
                                                arguments: PinCodePageType.create,
                                              );
                                            } else {
                                              Navigator.of(context).pushNamed(
                                                '/pin',
                                                arguments: PinCodePageType.enter,
                                              );
                                            }
                                          },
                                          params: {'width': width},
                                          child: menuWalletBtn)
                                      : AnimButton(
                                          player: GetIt.I<MusicManager>().menuSettingsSignWaterPlayer,
                                          shadowType: 2,
                                          onTap: () {
                                            Navigator.of(context).pushNamed('/settings');
                                          },
                                          child: SvgPicture.asset('assets/pages/homepage/settings.svg'),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: width,
                height: 190 / 880 * height,
                child: Stack(
                  children: [
                    IgnorePointer(
                        child: SvgPicture.asset(
                      'assets/pages/homepage/bottom_navigation_background.svg',
                      width: width,
                      fit: BoxFit.fill,
                    )),
                    Column(
                      children: [
                        const Spacer(),
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: 8 / 360 * height,
                          ),
                          child: SizedBox(
                            width: width,
                            height: 160 / 880 * height,
                            child: Flex(
                              direction: Axis.horizontal,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Spacer(flex: 3),
                                bottomNavigButton(
                                  SvgPicture.asset('assets/pages/homepage/page_1.svg', fit: BoxFit.fitHeight),
                                  height,
                                  0,
                                ),
                                const Spacer(flex: 1),
                                bottomNavigButton(
                                  SvgPicture.asset('assets/pages/homepage/page_2.svg', fit: BoxFit.fitHeight),
                                  height,
                                  1,
                                ),
                                const Spacer(flex: 1),
                                bottomNavigButton(
                                  SvgPicture.asset('assets/pages/homepage/page_3.svg', fit: BoxFit.fitHeight),
                                  height,
                                  2,
                                ),
                                const Spacer(flex: 1),
                                bottomNavigButton(
                                  SvgPicture.asset(
                                    'assets/pages/homepage/page_4.svg',
                                    fit: BoxFit.fitHeight,
                                  ),
                                  height,
                                  3,
                                ),
                                const Spacer(flex: 1),
                                bottomNavigButton(
                                  SvgPicture.asset('assets/pages/homepage/page_5.svg', fit: BoxFit.fitHeight),
                                  height,
                                  4,
                                ),
                                const Spacer(flex: 3),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ])),
        isMenuOpened ? SizedBox(width: width, height: height, child: getMenu(width, height, context)) : const SizedBox(),
      ],
    );
  }

  void openQr(double width, double height) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => SizedBox(
        width: width,
        height: height * 0.65,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
              child: SizedBox(
                width: width,
                height: height * 0.65,
                child: Image.asset(
                  'assets/modal_bottom_sheet_bg.png',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PresButton(
                        player: GetIt.I<MusicManager>().keyBackSignCloseX, // HERE
                        onTap: () async {
                          await GetIt.I<MusicManager>().popupDownSybMenuPlayer.play().then((value) async {
                            await GetIt.I<MusicManager>().popupDownSybMenuPlayer.seek(Duration(seconds: 0));
                          });

                          if (kDebugMode) {
                            print(AppStorage().read('wallet_adress')!);
                          }
                          Navigator.of(context).pop();
                        },
                        params: {'width': width},
                        child: backBtn,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                          child: Center(
                            child: FittedBox(
                              child: Text('receive', style: AppTypography.amazObitW400White),
                            ),
                          ),
                        ),
                      ),
                      AnimButton(
                        shadowType: 2,
                        onTap: () async {
                          showDialog(
                              context: context,
                              builder: ((context) => const CustomPopup(
                                    isError: false,
                                    text: 'This is a wallet linked to your game account. You can refill it in any convenient way by copying the address or using the QR code.\nAttention! Send tokens only on BEP20 (BSC) chain, otherwise the tokens will be lost!',
                                  )));
                        },
                        child: SvgPicture.asset(
                          'assets/pages/homepage/craft/info.svg',
                          height: width * 0.12,
                          width: width * 0.12,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(flex: 18),
                  Expanded(
                    flex: 200,
                    child: Container(
                      padding: EdgeInsets.all(width * 0.01),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: QrImageView(
                        data: AppStorage().read('wallet_adress')!,
                        version: QrVersions.auto,
                        eyeStyle: const QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(flex: 18),
                  FittedBox(
                      fit: BoxFit.fitHeight,
                      child: RichText(
                          text: TextSpan(
                        text: 'Your ',
                        style: AppTypography.spaceMonoW400,
                        children: [
                          TextSpan(
                            text: 'BEP20 (BSC)',
                            style: AppTypography.spaceMonoW400.copyWith(color: Colors.red),
                          ),
                          TextSpan(
                            text: ' Wallet Address:',
                            style: AppTypography.spaceMonoW400,
                          ),
                        ],
                      ))),
                  const Spacer(flex: 8),
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      AppStorage().read('wallet_adress')!,
                      style: AppTypography.spaceMonoW700,
                    ),
                  ),
                  const Spacer(flex: 18),
                  PresButton(
                    onTap: () async {
                      await Clipboard.setData(
                        ClipboardData(
                          text: AppStorage().read('wallet_adress')!,
                        ),
                      ).then(
                        (_) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.transparent,
                              padding: const EdgeInsets.only(top: 30),
                              content: Container(
                                  height: 0.1 * height,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF0D1238),
                                    borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
                                    boxShadow: [BoxShadow(color: Color(0x2FFFFFFF), blurRadius: 30, spreadRadius: 30, offset: Offset(0, 20))],
                                  ),
                                  alignment: Alignment.center,
                                  child: Text('Copied to your clipboard!'.toUpperCase(), style: TextStyle(fontSize: 0.036 * width, fontWeight: FontWeight.w700, color: const Color(0xFF00FFFF))))));
                          Navigator.of(context).pop();
                        },
                      );
                    },
                    params: {'text': 'copy address', 'width': width, 'height': height},
                    child: loginBtn,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).whenComplete(() async {
      await GetIt.I<MusicManager>()
          .popupDownSybMenuPlayer
          .play()
          .then((value) async {
        await GetIt.I<MusicManager>()
            .popupDownSybMenuPlayer
            .seek(Duration(seconds: 0));
      });
    });
  }

  Widget bottomNavigButton(Widget child, double height, int id) {
    return SizedBox(
        height: height * 0.105,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              color: Colors.transparent,
              height: height * (id == 2 ? 0.09 : 0.07),
              child: InkWell(
                onTap: () async {
                  await GetIt.I<MusicManager>().menuSettingsSignWaterPlayer.play().then((value) async {
                    await GetIt.I<MusicManager>().menuSettingsSignWaterPlayer.seek(Duration(seconds: 0));
                  });
                  setState(() {
                    selectedPage = id;
                  });
                  updateBalances();

                  await GetIt.I<MusicManager>().screenChangePlayer.play().then((value) async {
                    await GetIt.I<MusicManager>().screenChangePlayer.seek(Duration(seconds: 0));
                  });
                },
                borderRadius: BorderRadius.circular(100),
                child: Opacity(
                  opacity: selectedPage == id ? 1.0 : 0.5,
                  child: child,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: height * 0.005),
              child: Opacity(
                opacity: selectedPage == id ? 1.0 : 0.0,
                child: SvgPicture.asset(
                  'assets/pages/homepage/indicator.svg',
                  width: height * 0.005,
                  height: height * 0.005,
                ),
              ),
            )
          ],
        ));
  }

  Widget getMenu(double width, double height, BuildContext context) {
    precacheImage(backgroundLoginOpacity, context);
    return Container(
      width: width,
      height: height,
      color: const Color(0xFF0D1238).withOpacity(0.7),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.075,
        ),
        child: Column(
          children: [
            const Spacer(flex: 65),
            Expanded(
              flex: 630,
              child: Stack(
                children: [
                  Center(
                    child: Container(
                        height: height * 0.66,
                        width: width,
                        decoration: BoxDecoration(
                            color: const Color(0xFF020A38),
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                              color: const Color(0xFF00FFFF),
                            ),
                            image: const DecorationImage(
                              image: backgroundLoginOpacity,
                              fit: BoxFit.fitHeight,
                            ))),
                  ),
                  Column(
                    children: [
                      Expanded(
                        flex: 160,
                        child: Column(
                          children: [
                            Expanded(
                              flex: 85,
                              child: SvgPicture.asset(
                                'assets/pages/start/logo.svg',
                              ),
                            ),
                            Expanded(
                              flex: 69,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: SvgPicture.asset(
                                  'assets/pages/start/logo_text.svg',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(flex: 50),
                      Expanded(
                        flex: 301,
                        child: Column(
                          children: [
                            Expanded(
                              child: getMenuButton(
                                () => setState(() {
                                  selectedPage = 7;
                                  isMenuOpened = false;
                                }),
                                'ACCOUNT',
                                height,
                              ),
                            ),
                            Expanded(
                              child: getMenuButton(
                                () => Navigator.of(context).pushNamed('/viewWebChronic'),
                                'CHRONICLES',
                                height,
                              ),
                            ),
                            Expanded(
                              child: getMenuButton(
                                null,
                                'COUNTER',
                                height,
                              ),
                            ),
                            Expanded(
                              child: getMenuButton(
                                null,
                                'AR MASKS',
                                height,
                              ),
                            ),
                            Expanded(
                              child: getMenuButton(
                                null,
                                'CONTACTS',
                                height,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(flex: 63),
                      Expanded(
                        flex: 80,
                        child: PresButton(
                          player: GetIt.I<MusicManager>().keyBackSignCloseX,
                          onTap: () => setState(() {
                            isMenuOpened = false;
                          }),
                          params: const {},
                          child: menuCloseBtn,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(flex: 150),
          ],
        ),
      ),
    );
  }

  Widget getMenuButton(Function? onTap, String text, double height) {
    return Material(
      color: Colors.transparent,
      child: AnimButton(
        player: GetIt.I<MusicManager>().menuSettingsSignWaterPlayer,
        onTap: onTap != null ? () => onTap() : null,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'AmazObitaemOstrovItalic',
                color: onTap != null ? const Color(0xFF00FFFF) : const Color(0xFF9E9E9E),
                fontSize: height * 0.025,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getContent(double width, double height) {
    switch (selectedPage) {
      case 0:
        return getCraftPage(width, height);
      case 1:
        return getHerosPage(width, height);
      case 2:
        return HomeMainPage(
            watchSamurai: () => setState(() => selectedPage = 0),
            switchSamuraiType: (type) async {
              await GetIt.I<MusicManager>().menuSettingsSignWaterPlayer.play().then((value) async {
                await GetIt.I<MusicManager>().menuSettingsSignWaterPlayer.seek(Duration(seconds: 0));
              });

              AppStorage().write(craftSwitchKey, type.toString());
              setState(() {
                craftSwitch = type;
              });
            });
      case 3:
        return getForgePage(height);
      case 4:
        return getStoragePage(height);
      case 5:
        return const WalletPage();
      case 6:
        return getHeroMintPage(width, height);
      case 8:
        return getSamuariMintPage(width, height);
      case 7:
        return const AccountPage();
      default:
        return Center(
          child: Text(
            "Coming soon",
            style: TextStyle(
              fontFamily: 'AmazObitaemOstrovItalic',
              fontSize: height * 0.05,
              color: Colors.white,
            ),
          ),
        );
    }
  }

  Widget getCraftPage(double width, double height) {
    return Stack(
      children: [
        Padding(
            padding: EdgeInsets.only(top: 100 / 880 * (height - height * 0.10)),
            child: SizedBox(
              width: width,
              child: CraftPage(craftSwitch: craftSwitch),
            )),
        switchWaterFire(width, height, craftSwitch, (val) {
          AppStorage().write(craftSwitchKey, val.toString());
          setState(() {
            craftSwitch = val;
          });
        })
      ],
    );
  }

  Widget getForgePage(double height) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(flex: 1),
        Text(
          'Forge',
          style: AppTypography.amazObitWhite.copyWith(
                    fontSize: 44,
                    letterSpacing: 3
                  ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          '   COMING SOON...',
          style: GoogleFonts.spaceMono(
            fontSize: height * 0.02,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF00FFFF),
          ),
        ),
        const Spacer(flex: 13),
      ],
    );
  }

  Widget getStoragePage(double height) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(flex: 1),
        Text(
          'Storage',
          style: AppTypography.amazObitWhite.copyWith(
                    fontSize: 44,
                    letterSpacing: 3
                  ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          '   COMING SOON...',
          style: GoogleFonts.spaceMono(
            fontSize: height * 0.02,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF00FFFF),
          ),
        ),
        const Spacer(flex: 13),
      ],
    );
  }

  Widget switchWaterFire(double width, double height, int valueSwitch, Function onSwitch) {
    return Container(
      padding: EdgeInsets.only(left: width * 0.05, right: width * 0.05),
      child: Stack(
        children: [
          SvgPicture.asset(
            valueSwitch == 0 ? 'assets/pages/homepage/craft/water.svg' : 'assets/pages/homepage/craft/fire.svg',
            width: width * 0.9,
            height: 125 / 880 * (height - height * 0.10),
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  overlayColor: MaterialStateProperty.all(
                    Colors.transparent,
                  ),
                  onTap: () async {
                    onSwitch(0);
                    await GetIt.I<MusicManager>().menuSettingsSignWaterPlayer.play().then((value) async {
                      await GetIt.I<MusicManager>().menuSettingsSignWaterPlayer.seek(Duration(seconds: 0));
                    });
                  },
                  child: Container(
                    height: 100 / 880 * (height - height * 0.10),
                    width: width * 0.475,
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  overlayColor: MaterialStateProperty.all(
                    Colors.transparent,
                  ),
                  onTap: () async {
                    onSwitch(1);
                    await GetIt.I<MusicManager>().menuSettingsSignWaterPlayer.play().then((value) async {
                      await GetIt.I<MusicManager>().menuSettingsSignWaterPlayer.seek(Duration(seconds: 0));
                    });
                  },
                  child: Container(
                    height: 100 / 880 * (height - height * 0.10),
                    width: width * 0.475,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget getHerosPage(double width, double height) {
    return Stack(
      children: [
        Padding(
            padding: EdgeInsets.only(top: 43 / 880 * height),
            child: SizedBox(
              width: width,
              child: HerosPage(craftSwitch: craftSwitch),
            )),
        switchWaterFire(width, height, craftSwitch, (val) {
          AppStorage().write(craftSwitchKey, val.toString());
          setState(() {
            craftSwitch = val;
          });
        })
      ],
    );
  }

  Widget getHeroMintPage(double width, double height) {
    return Stack(
      children: [
        Padding(
            padding: EdgeInsets.only(top: 1 / 880 * height, left: width * 0.04, right: width * 0.04),
            child: SizedBox(
              width: width,
              child: HeroMintPage(craftSwitch: herosSwitch),
            )),
      ],
    );
  }

  Widget getSamuariMintPage(double width, double height) {
    return Stack(
      children: [
        Padding(
            padding: EdgeInsets.only(top: 1 / 880 * height, left: width * 0.04, right: width * 0.04),
            child: SizedBox(
              width: width,
              child: SamuraiMintPage(craftSwitch: herosSwitch),
            )),
      ],
    );
  }
}
