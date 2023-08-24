import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/anim_button.dart';
import '../components/show_confirm.dart';
import '../components/storage.dart';
import '../data/music_manager.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: height,
            width: width,
            child: SvgPicture.asset(
              'assets/background_gradient.svg',
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 25 / 390 * width,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).viewPadding.top * 1.25,
                ),
                Row(
                  children: [
                    PresButton(
                      onTap: () => Navigator.of(context).pop(),
                      params: {'width': width},
                      child: backBtn,
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.05,
                        ),
                        child: Center(
                          child: Text(
                            'settings',
                            style: TextStyle(
                              fontFamily: 'AmazObitaemOstrovItalic',
                              fontSize: 37 / 844 * height,
                              color: Colors.white,
                            ),
                            maxLines: 1,
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
                const Spacer(flex: 70),
                settingsButton(
                  height,
                  width,
                  'SEED PHRASE',
                  onTap: () {
                    showConfirm(context,
                        'Anyone who knows your wallet\'s seed phrase will be able to access it. Make sure no one sees your screen now!',
                        () {
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed('/seed');
                    });
                  },
                ),
                separator(width),
                settingsButton(
                  height,
                  width,
                  'TRANSACTION HISTORY',
                  isActive: false,
                ),
                separator(width),
                settingsButton(
                  height,
                  width,
                  'SIGN OUT',
                  onTap: () async {
                    await GetIt.I<MusicManager>()
                        .keyBackSignCloseX
                        .play()
                        .then((value) async {
                      await GetIt.I<MusicManager>()
                          .keyBackSignCloseX
                          .seek(Duration(seconds: 0));
                    });

                    await AppStorage().remove('pin');
                    await AppStorage().remove('wallet_adress');
                    await AppStorage().remove('wallet_mnemonic');
                    await AppStorage().remove('user');
                    if (mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/createWallet',
                        (route) => false,
                      );
                    }
                  },
                ),
                const Spacer(flex: 500),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget settingsButton(
    double height,
    double width,
    String textData, {
    bool isActive = true,
    Function? onTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: height * 0.01,
      ),
      child: InkWell(
        onTap: isActive ? () => onTap!() : null,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: 340 / 390 * width,
          padding: EdgeInsets.symmetric(
            vertical: height * 0.02,
          ),
          child: Center(
            child: Text(
              textData,
              style: GoogleFonts.spaceMono(
                fontSize: 20 / 844 * height,
                height: 1.5,
                fontWeight: FontWeight.w700,
                color: isActive
                    ? const Color(0xFF00FFFF)
                    : const Color(0xFF9D9D9D).withOpacity(0.3),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget separator(double width) {
    return Container(
      width: 340 / 390 * width,
      height: 1,
      color: Colors.white.withOpacity(0.3),
    );
  }
}
