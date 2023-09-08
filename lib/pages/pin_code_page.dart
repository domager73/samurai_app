import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:samurai_app/components/storage.dart';
import 'package:samurai_app/data/music_manager.dart';
import 'package:samurai_app/widgets/popups/custom_popup.dart';
import 'package:trust_wallet_core_lib/trust_wallet_core_ffi.dart';
import 'package:trust_wallet_core_lib/trust_wallet_core_lib.dart';

import '../api/rest.dart';
import '../components/pop_up_spinner.dart';

enum PinCodePageType { create, confirm, enter, createNewWalletAndPinCode }

class PinCodePage extends StatefulWidget {
  const PinCodePage({super.key});

  @override
  State<PinCodePage> createState() => _PinCodePageState();
}

class _PinCodePageState extends State<PinCodePage> {
  String pinCode = '';
  bool isConfirmationStep = false;
  String firstAttempt = '';

  @override
  void initState(){
    super.initState();

    GetIt.I<MusicManager>().screenChangePlayer.play().then((value) async {
      await GetIt.I<MusicManager>()
          .screenChangePlayer
          .seek(Duration(seconds: 0));
    });
  }

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
            padding: EdgeInsets.symmetric(horizontal: 35 / 390 * width),
            child: Column(
              children: [
                const Spacer(flex: 3),
                SizedBox(
                  width: 320 / 390 * width,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      isConfirmationStep
                          ? "Confirm the code"
                          : ModalRoute.of(context)!.settings.arguments == PinCodePageType.create
                              ? "create the code"
                              : "enter the code",
                      style: const TextStyle(
                        fontFamily: 'AmazObitaemOstrovItalic',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const Spacer(flex: 2),
                getIndicator(width, height),
                const Spacer(flex: 2),
                getKeyboard(width, height),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getIndicator(double width, double height) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        getDot(0, width),
        getDot(1, width),
        getDot(2, width),
        getDot(3, width),
      ],
    );
  }

  Widget getDot(int id, double width) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 5 / 390 * width,
      ),
      width: 30 / 390 * width,
      height: 35 / 390 * width,
      child: Stack(
        children: [
          Center(
            child: SvgPicture.asset(
              'assets/pin_indicator_1.svg',
              fit: BoxFit.fitWidth,
              width: 12 / 390 * width,
              color: pinCode.length > id ? const Color(0xFF00FFFF) : Colors.white,
            ),
          ),
          Center(
            child: SvgPicture.asset(
              'assets/pin_indicator_2.svg',
              fit: BoxFit.fitWidth,
              width: 30 / 390 * width,
              color: pinCode.length == id ? const Color(0xFF00FFFF) : Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  Widget getKeyboard(double width, double height) {
    return Column(
      children: [
        Row(
          children: [
            getButton(
              width,
              height,
              '1',
            ),
            getButton(
              width,
              height,
              '2',
            ),
            getButton(
              width,
              height,
              '3',
            ),
          ],
        ),
        Row(
          children: [
            getButton(
              width,
              height,
              '4',
            ),
            getButton(
              width,
              height,
              '5',
            ),
            getButton(
              width,
              height,
              '6',
            ),
          ],
        ),
        Row(
          children: [
            getButton(
              width,
              height,
              '7',
            ),
            getButton(
              width,
              height,
              '8',
            ),
            getButton(
              width,
              height,
              '9',
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () async {
                  await GetIt.I<MusicManager>().keyBackSignCloseX.play().then((value) async {
                    await GetIt.I<MusicManager>().keyBackSignCloseX.seek(Duration(seconds: 0));
                  });

                  ModalRoute.of(context)!.settings.arguments == PinCodePageType.create
                      ? Navigator.pushReplacementNamed(
                          context,
                          '/home',
                        )
                      : Navigator.of(context).pop();
                },
                borderRadius: BorderRadius.circular(8.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: SizedBox(
                    height: 40 / 844 * height * 1.2,
                    child: Center(
                      child: SizedBox(
                        height: 50 / 844 * height,
                        width: 170 / 844 * height,
                        child: SvgPicture.asset(
                          'assets/keyboard_back.svg',
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            getButton(
              width,
              height,
              '0',
            ),
            Expanded(
              child: InkWell(
                onTap: () async {
                  await GetIt.I<MusicManager>().menuSettingsSignWaterPlayer.play().then((value) async {
                    await GetIt.I<MusicManager>().menuSettingsSignWaterPlayer.seek(Duration(seconds: 0));
                  });

                  if (pinCode.isNotEmpty) {
                    setState(() {
                      pinCode = pinCode.substring(0, pinCode.length - 1);
                    });
                  }
                },
                borderRadius: BorderRadius.circular(8.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: SizedBox(
                    height: 40 / 844 * height * 1.2,
                    child: Center(
                      child: SizedBox(
                        height: 20 / 844 * height,
                        width: 40 / 844 * height,
                        child: SvgPicture.asset(
                          pinCode.isEmpty ? 'assets/keyboard_symb_dis.svg' : 'assets/keyboard_symb.svg',
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget getButton(double width, double height, String id) {
    return Expanded(
      child: InkWell(
        onTap: () async {
          await GetIt.I<MusicManager>().numbersCodePlayer.play().then((value) async {
            await GetIt.I<MusicManager>().numbersCodePlayer.seek(Duration(seconds: 0));
          });

          if (pinCode.length < 4) {
            setState(() {
              pinCode += id;
            });
            if (pinCode.length == 4) {
              handleEnteredPinCode(height);
            }
          }
        },
        borderRadius: BorderRadius.circular(8.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            id,
            style: TextStyle(
              fontFamily: 'AmazObitaemOstrovItalic',
              fontSize: 40 / 844 * height,
              color: const Color(0xFF00FFFF),
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void handleEnteredPinCode(double height) async {
    if (ModalRoute.of(context)!.settings.arguments == PinCodePageType.create) {
      if (isConfirmationStep) {
        if (pinCode == firstAttempt) {
          await AppStorage().write('pin', pinCode);

          Navigator.of(context).pushNamedAndRemoveUntil(
            '/home',
            (route) => false,
            arguments: 'wallet',
          );
        } else {
          setState(() {
            pinCode = '';
            isConfirmationStep = false;
          });
          await showDialog(
          context: context,
          builder: (context) => const CustomPopup(text: 'Codes do not match, please try again.', isError: true),
        );
        }
      } else {
        setState(() {
          isConfirmationStep = true;
          firstAttempt = pinCode;
          pinCode = '';
        });
      }
    } else if (ModalRoute.of(context)!.settings.arguments == PinCodePageType.enter) {
      String? validCode = AppStorage().read('pin');
      if (pinCode == validCode) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/home',
          (route) => false,
          arguments: 'wallet',
        );
      } else {
        setState(() {
          pinCode = '';
        });
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
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
                child: Text('Invalid code'.toUpperCase(), style: TextStyle(fontSize: 0.021 * height, fontWeight: FontWeight.w700, color: const Color(0xFFFF0049)))),
          ),
        );
      }
    } else if(ModalRoute.of(context)!.settings.arguments == PinCodePageType.createNewWalletAndPinCode){
      if (isConfirmationStep) {
        showSpinner(context);
        try {
          HDWallet wallet = HDWallet();
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
        }
        
        AppStorage().updateUserWallet();
        await AppStorage().write('pin', pinCode);
        
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/home',
              (route) => false,
          arguments: 'wallet',
        );
      }else{
        setState(() {
          isConfirmationStep = true;
          firstAttempt = pinCode;
          pinCode = '';
        });
      }
    }
  }
}
