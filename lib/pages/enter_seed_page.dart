import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samurai_app/pages/pin_code_page.dart';
import 'package:trust_wallet_core_lib/trust_wallet_core_ffi.dart';
import 'package:trust_wallet_core_lib/trust_wallet_core_lib.dart';

import '../api/rest.dart';
import '../components/anim_button.dart';
import '../components/pop_up_spinner.dart';
import '../components/storage.dart';
import '../data/music_manager.dart';

class EnterSeedPage extends StatefulWidget {
  const EnterSeedPage({super.key});

  @override
  State<EnterSeedPage> createState() => _EnterSeedPageState();
}

class _EnterSeedPageState extends State<EnterSeedPage> {

  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  Future<void> enterSeed(BuildContext context) async {
    showSpinner(context);
    try {
      HDWallet wallet = HDWallet.createWithMnemonic(textController.text);
      String walletAddres = wallet.getAddressForCoin(
        TWCoinType.TWCoinTypePolygon,
      );
      debugPrint(
        wallet.getAddressForCoin(TWCoinType.TWCoinTypePolygon),
      );
      await AppStorage().write(
        'wallet_adress',
        walletAddres,
      );
      debugPrint(
        wallet.mnemonic(),
      );
      await AppStorage().write(
        'wallet_mnemonic',
        wallet.mnemonic(),
      );
      await Rest.updateWalletAddress(walletAddres);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    if (mounted) {
      hideSpinner(context);
      AppStorage().updateUserWallet();
      Navigator.pushReplacementNamed(
        context,
        '/pin',
        arguments: PinCodePageType.create,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: width,
            height: height,
            child: Image.asset(
              'assets/modal_bottom_sheet_bg.png',
              fit: BoxFit.fill,
            ),
          ),
          InkWell(
            overlayColor: MaterialStateProperty.all(
              Colors.transparent,
            ),
            onTap: () => FocusScope.of(context).unfocus(),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        PresButton(
                          onTap: () => Navigator.of(context).pop(),
                          params: {'width': width},
                          child: backBtn,
                          player: GetIt.I<MusicManager>().keyBackSignCloseX,
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'enter seed',
                              style: TextStyle(
                                fontFamily: 'AmazObitaemOstrovItalic',
                                fontSize: 37 / 844 * height,
                                color: Colors.white,
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
                    Text(
                      'phrase',
                      style: TextStyle(
                        fontFamily: 'AmazObitaemOstrovItalic',
                        fontSize: 37 / 844 * height,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 24 / 844 * height),
                    Text(
                      "Write down your Seed Phrase\nseparated by a space without commas",
                      style: GoogleFonts.spaceMono(
                        fontSize: 13 / 844 * height,
                        fontWeight: FontWeight.w400,
                        height: 15 / 13,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24 / 844 * height),
                    SizedBox(
                      width: width - 56,
                      height: 206 / 340 * (width - 56),
                      child: Stack(
                        children: [
                          SvgPicture.asset(
                            'assets/enter_seed_border.svg',
                            width: width - 56,
                            height: 206 / 340 * (width - 56),
                            fit: BoxFit.fill,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 37 / 390 * width,
                              vertical: 19 / 844 * height,
                            ),
                            child: TextField(
                              controller: textController,
                              keyboardType: TextInputType.multiline,
                              expands: true,
                              minLines: null,
                              maxLines: null,
                              decoration: InputDecoration.collapsed(
                                hintText: "Your seed phrase",
                                hintStyle: GoogleFonts.spaceMono(
                                  fontSize: height * 0.02,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                              style: GoogleFonts.spaceMono(
                                fontSize: height * 0.02,
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                                color: Colors.white,
                              ),
                              cursorColor: const Color(0xFF00FFFF),
                              cursorRadius: const Radius.circular(5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24 / 844 * height),
                    PresButton(
                      onTap: () => enterSeed(context),
                      params: {'text': 'confirm', 'width': width, 'height': height},
                      child: loginBtn,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
