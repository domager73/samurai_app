import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samurai_app/api/rest.dart';
import 'package:samurai_app/components/storage.dart';
import 'package:samurai_app/pages/pin_code_page.dart';
import 'package:trust_wallet_core_lib/trust_wallet_core_ffi.dart';
import 'package:trust_wallet_core_lib/trust_wallet_core_lib.dart';

import '../components/anim_button.dart';
import '../components/bg.dart';
import '../components/pop_up_spinner.dart';
import '../data/music_manager.dart';

class CreateWallet extends StatefulWidget {
  const CreateWallet({super.key});

  @override
  State<CreateWallet> createState() => _CreateWalletState();
}

class _CreateWalletState extends State<CreateWallet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    precacheImage(backgroundLogin, context);
    return Scaffold(
      backgroundColor: const Color(0xFF020A38),
      body: Stack(
        children: [
          SizedBox(
            width: width,
            height: height,
            child: const Image(
              image: backgroundLogin,
              fit: BoxFit.fitHeight,
            ),
          ),
          Center(
            child: Column(
              children: [
                Row(children: [
                  Padding(
                      padding: EdgeInsets.only(
                          top: height * 0.06, left: height * 0.02),
                      child: PresButton(
                        player: GetIt.I<MusicManager>().keyBackSignCloseX,
                        onTap: () => Navigator.pushReplacementNamed(
                          context,
                          '/home',
                        ),
                        params: {'width': width},
                        child: backBtn,
                      )),
                ]),
                const Spacer(
                  flex: 10,
                ),
                PresButton(
                  onTap: () {
                    AppStorage().updateUserWallet();
                    Navigator.pushReplacementNamed(
                      context,
                      '/pin',
                      arguments: PinCodePageType.createNewWalletAndPinCode,
                    );
                  },
                  params: {
                    'text': 'create wallet',
                    'width': width,
                    'height': height
                  },
                  child: loginBtn,
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      'or',
                      style: GoogleFonts.spaceMono(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 0.9375,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                PresButton(
                  onTap: () => Navigator.of(context).pushNamed('/enterSeed'),
                  params: {
                    'text': 'enter seed',
                    'width': width,
                    'height': height
                  },
                  child: loginBtn,
                ),
                const Spacer(
                  flex: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
