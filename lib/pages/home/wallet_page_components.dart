import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samurai_app/components/pop_up_spinner.dart';
import 'package:samurai_app/data/music_manager.dart';
import 'package:samurai_app/widgets/custom_swap_border.dart';
import 'package:trust_wallet_core_lib/trust_wallet_core_lib.dart';
import '../../api/rest.dart';
import '../../api/wallet.dart';
import '../../components/anim_button.dart';
import '../../components/bg.dart';
import '../../components/comma_formatter.dart';
import '../../components/samurai_text_field.dart';
import '../../components/show_error.dart';
import '../../components/storage.dart';
import '../tfa_page.dart';

class WalletPageComponents {
  static void transferSamurai(BuildContext context, String mode, HDWallet wallet, String text, String? tokenAdress, String token, String typeToken, String walletAddress) {
    if (text.isEmpty) {
      return;
    }
    showSpinner(context);
    if (token == 'USDT' || token == 'CLC' || token == 'RYO') {
      if (mode == 'inGame') {
        WalletAPI.transferERC20Bnb(wallet, tokenAdress!, double.tryParse(text) ?? 0.0, null, 'assets/usdt.abi.json').then((_) {
          hideSpinner(context);
          Navigator.of(context).pop();
        }).catchError((e) {
          hideSpinner(context);
          showError(context, 'Insufficient funds').then((_) => Navigator.of(context).pop());
        });
      } else if (mode == 'inChain') {
        Rest.transfer(
          WalletAPI.chainIdBnb,
          double.tryParse(text) ?? 0.0,
          typeToken,
          walletAddress,
        ).then((_) {
          hideSpinner(context);
          Navigator.of(context).pop();
        }).catchError((e) {
          hideSpinner(context);
          showError(context, 'Insufficient funds').then((_) => Navigator.of(context).pop());
        });
      }
    } else if (token == 'BNB') {
      if (mode == 'inGame') {
        WalletAPI.transferBNB(
          wallet,
          double.tryParse(text) ?? 0.0,
          null,
        ).then((_) {
          hideSpinner(context);
          Navigator.of(context).pop();
        }).catchError((e) {
          hideSpinner(context);
          showError(context, 'Insufficient funds').then((_) => Navigator.of(context).pop());
        });
      } else if (mode == 'inChain') {
        Rest.transfer(
          WalletAPI.chainIdBnb,
          double.tryParse(text) ?? 0.0,
          typeToken,
          walletAddress,
        ).then((_) {
          hideSpinner(context);
          Navigator.of(context).pop();
        }).catchError((e) {
          hideSpinner(context);
          showError(context, 'Insufficient funds').then((_) => Navigator.of(context).pop());
        });
      } else {
        hideSpinner(context);
        showError(context, 'Token error').then((_) => Navigator.of(context).pop());
      }
    }
  }

  static Future<void> openSwapModalPage({
    required BuildContext context,
    required double width,
    required double height,
    required HDWallet wallet,
    String? tokenAdress,
    required String token,
    required String typeToken,
    required String walletAddress,
    required String iconPath,
    required double balance,
    required double balanceGame,
    required String gasName,
    required double gas,
  }) async {
    String mode = 'inGame';
    TextEditingController controller = TextEditingController();

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (context, StateSetter setState) => GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  image: DecorationImage(image: modalBottomsheetBg, fit: BoxFit.fill)),
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28.0, 28.0, 28.0, 0.0), //  padding
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PresButton(
                          onTap: () => Navigator.of(context).pop(),
                          params: {'width': width},
                          child: backBtn,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                          child: Text(
                            'swap',
                            style: TextStyle(
                              fontFamily: 'AmazObitaemOstrovItalic',
                              fontSize: 37 / 844 * height,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                          ),
                        ),
                        AnimButton(
                          shadowType: 2,
                          onTap: () async {
                            showError(context, 'Send your tokens TO GAME to use them in the game. Send your tokens TO WALLET to use them outside of the game.', type: 2);
                          },
                          child: SvgPicture.asset(
                            'assets/pages/homepage/craft/info.svg',
                            height: width * 0.12,
                            width: width * 0.12,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: width * 0.02, bottom: 30),
                      child: SvgPicture.asset(
                        iconPath,
                        height: height * 0.11,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    CustomPaint(
                      painter: CustomSwapPainter(),
                      child: Container(
                          padding: const EdgeInsets.all(30),
                          width: width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.end, children: [
                                      SizedBox(
                                        width: width * 0.116,
                                        child: Text(
                                          textAlign: TextAlign.start,
                                          "from".toUpperCase(),
                                          style: GoogleFonts.spaceMono(fontWeight: FontWeight.w800, fontSize: 13, color: Colors.white, textStyle: TextStyle(height: 1)),
                                        ),
                                      ),
                                      Text(
                                        mode == 'inGame' ? 'WALLET' : 'GAME',
                                        textHeightBehavior: TextHeightBehavior(),
                                        style: GoogleFonts.spaceMono(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 20, textStyle: TextStyle(height: 0.927)),
                                        textAlign: TextAlign.start,
                                      ),
                                    ]),
                                    Container(color: Colors.white.withOpacity(0.6), height: 1, margin: const EdgeInsets.only(top: 22, bottom: 16)),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          width: width * 0.116,
                                          child: Text(
                                            "to".toUpperCase(),
                                            style: GoogleFonts.spaceMono(fontWeight: FontWeight.w800, fontSize: 13, color: Colors.white, textStyle: TextStyle(height: 1)),
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                        Text(
                                          textAlign: TextAlign.start,
                                          mode == 'inGame' ? 'GAME' : 'WALLET',
                                          style: GoogleFonts.spaceMono(fontWeight: FontWeight.w700, color: Colors.white, textStyle: TextStyle(height: 0.9), fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: width * 0.25,
                                child: AnimButton(
                                  shadowType: 2,
                                  onTap: () => setState(() {
                                    mode == 'inGame' ? mode = 'inChain' : mode = 'inGame';
                                  }),
                                  child: SvgPicture.asset(
                                    'assets/swap_change_bt.svg',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),
                    Padding(
                        padding: EdgeInsets.only(bottom: width * 0.02, top: 40),
                        child: SamuraiTextField(
                            screeenHeight: height,
                            screeenWidth: width,
                            hint: 'Amount',
                            keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: true),
                            inputFormatters: [
                              CommaFormatter(),
                              FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*[.]?[0-9]*')),
                            ],
                            controller: controller,
                            onChanged: (_) => setState(() {}),
                            allButton: () => setState(() {
                                  controller.text = mode == 'inGame' ? balance.toString() : balanceGame.toString();
                                }))),
                    Container(
                        width: width,
                        padding: EdgeInsets.symmetric(
                          vertical: width * 0.02,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Available: ${num.parse(mode == 'inGame' ? balance.toStringAsFixed(5) : balanceGame.toStringAsFixed(5))} $token",
                              style: GoogleFonts.spaceMono(
                                fontSize: 13 / 844 * height,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Gas: ${gas.toStringAsFixed(9)} $gasName",
                              style: GoogleFonts.spaceMono(
                                fontSize: 13 / 844 * height,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )),
                    Padding(
                        padding: EdgeInsets.only(
                          bottom: width * 0.02,
                        ),
                        child: PresButton(
                          onTap: () {
                            final useTfa = AppStorage().read('use-tfa');
                            if (useTfa != null && useTfa == '1') {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const TfaPage())).then((res) {
                                if (res) {
                                  transferSamurai(context, mode, wallet, controller.text, tokenAdress, token, typeToken, walletAddress);
                                }
                              });
                            } else {
                              transferSamurai(context, mode, wallet, controller.text, tokenAdress, token, typeToken, walletAddress);
                            }
                          },
                          disabled: (controller.text.isEmpty) || ((double.tryParse(controller.text) ?? 0.0) <= 0) || ((double.tryParse(controller.text) ?? 0.0) > (mode == 'inGame' ? balance : balanceGame)),
                          params: {'text': 'confirm', 'width': width, 'height': height},
                          child: loginBtn,
                        )),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  static void openToGameModalPage(
      {required BuildContext context,
      required double width,
      required double height,
      required HDWallet wallet,
      required String tokenAdress,
      required int tokenId,
      required String tokenName,
      required String iconPath,
      required int balance,
      required double gas,
      required String gasName,
      required bool isbnb}) {
    TextEditingController controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (context, StateSetter setState) => GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SizedBox(
              width: width,
              height: height * 0.55,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                    child: SizedBox(
                      width: width,
                      height: height * 0.55,
                      child: Image.asset(
                        'assets/modal_bottom_sheet_bg.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  InkWell(
                    overlayColor: MaterialStateProperty.all(
                      Colors.transparent,
                    ),
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              PresButton(
                                onTap: () => Navigator.of(context).pop(),
                                params: {'width': width},
                                child: backBtn,
                              ),
                              Expanded(
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                                    child: Center(
                                      child: Text(
                                        "to game",
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
                              ),
                              SizedBox(
                                height: width * 0.12,
                                width: width * 0.12,
                              ),
                            ],
                          ),
                          MediaQuery.of(context).viewInsets.bottom == 0 ? const Spacer(flex: 17) : Container(),
                          MediaQuery.of(context).viewInsets.bottom == 0
                              ? Expanded(
                                  flex: 85,
                                  child: SvgPicture.asset(
                                    iconPath,
                                    width: width * 0.4,
                                    fit: BoxFit.fitHeight,
                                  ),
                                )
                              : Container(),
                          const Spacer(flex: 25),
                          SamuraiTextField(
                              screeenHeight: height,
                              screeenWidth: width,
                              hint: 'Amount',
                              keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: false),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*')),
                              ],
                              controller: controller,
                              onChanged: (_) => setState(() {}),
                              allButton: () => setState(() {
                                    controller.text = balance.toString();
                                  })),
                          const Spacer(flex: 15),
                          SizedBox(
                              width: width,
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(
                                  "Available: $balance $tokenName",
                                  style: GoogleFonts.spaceMono(
                                    fontSize: 13 / 844 * height,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "Gas: ${gas.toStringAsFixed(9)} $gasName",
                                  style: GoogleFonts.spaceMono(
                                    fontSize: 13 / 844 * height,
                                    color: Colors.white,
                                  ),
                                ),
                              ])),
                          const Spacer(flex: 10),
                          SizedBox(
                            height: MediaQuery.of(context).viewInsets.bottom / 2,
                          ),
                          PresButton(
                            onTap: () {
                              if (controller.text.isEmpty) {
                                return;
                              }
                              showSpinner(context);
                              if (isbnb) {
                                WalletAPI.transfer1155Bnb(wallet, tokenAdress, tokenId, int.tryParse(controller.text) ?? 0, null).then((_) {
                                  hideSpinner(context);
                                  Navigator.of(context).pop();
                                }).catchError((e) {
                                  if (kDebugMode) {
                                    print(e);
                                  }
                                  hideSpinner(context);
                                  showError(context, 'Insufficient funds').then((_) => Navigator.of(context).pop());
                                });
                              } else {
                                /*WalletAPI.transferERC1155(
                              wallet,
                              tokenAdress,
                              tokenId,
                              int.tryParse(controller.text) ?? 0,
                              null,
                            ).then((_) {
                              hideSpinner(context);
                              Navigator.of(context).pop();
                            }).catchError((e) {
                              if (kDebugMode) {
                                print(e);
                              }
                              hideSpinner(context);
                              showError(context, 'Insufficient funds')
                                  .then((_) => Navigator.of(context).pop());
                            });*/
                              }
                            },
                            disabled: (controller.text.isEmpty) || (double.tryParse(controller.text) ?? 0) <= 0 || (double.tryParse(controller.text) ?? 0) > balance,
                            params: {'text': 'confirm', 'width': width, 'height': height},
                            child: loginBtn,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  static void openTransferModalPageSamurai({
    required BuildContext context,
    required double width,
    required double height,
    required HDWallet wallet,
    required String tokenAdress,
    int? tokenId,
    required String iconPath,
    required String tokenName,
    required String typeToken,
    required double balance,
    required String gasName,
    required double gas,
  }) {
    TextEditingController adressController = TextEditingController();
    TextEditingController amountController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (context, StateSetter setState) => GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  image: DecorationImage(image: modalBottomsheetBg, fit: BoxFit.fill)),
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28.0, 28.0, 28.0, 0.0), // content padding
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      PresButton(
                        onTap: () => Navigator.of(context).pop(),
                        params: {'width': width},
                        child: backBtn,
                      ),
                      FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: width * 0.05,
                              ),
                              child: Center(
                                  child: Text(
                                ' withdraw',
                                style: TextStyle(
                                  fontFamily: 'AmazObitaemOstrovItalic',
                                  fontSize: 37 / 844 * height,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                              )))),
                    ]),
                    Padding(
                        padding: EdgeInsets.only(top: height * 0.02, bottom: height * 0.02),
                        child: SvgPicture.asset(
                          iconPath,
                          height: height * 0.11,
                          fit: BoxFit.fitHeight,
                        )),
                    Padding(
                        padding: EdgeInsets.only(top: height * 0.02),
                        child: SamuraiTextField(
                          screeenHeight: height,
                          screeenWidth: width,
                          hint: "To address",
                          controller: adressController,
                          onChanged: (_) => setState(() {}),
                        )),
                    Padding(
                        padding: EdgeInsets.only(top: height * 0.02, bottom: height * 0.01),
                        child: SamuraiTextField(
                            screeenHeight: height,
                            screeenWidth: width,
                            hint: 'Amount',
                            keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: true),
                            inputFormatters: [
                              CommaFormatter(),
                              tokenId != null ? FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*')) : FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*[.]?[0-9]*')),
                            ],
                            controller: amountController,
                            onChanged: (_) => setState(() {}),
                            allButton: () => setState(() {
                                  amountController.text = tokenId != null ? balance.toStringAsFixed(0) : balance.toString();
                                }))),
                    SizedBox(
                        width: width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Available: ${tokenId != null ? balance.toStringAsFixed(0) : num.parse(balance.toStringAsFixed(5))} ${tokenName.toUpperCase()}",
                              style: GoogleFonts.spaceMono(
                                fontSize: 13 / 844 * height,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Gas: ${gas.toStringAsFixed(9)} $gasName",
                              style: GoogleFonts.spaceMono(
                                fontSize: 13 / 844 * height,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )),
                    Padding(
                        padding: EdgeInsets.only(top: height * 0.02, bottom: height * 0.01),
                        child: PresButton(
                          onTap: () {
                            if (adressController.text.isEmpty || amountController.text.isEmpty) {
                              return;
                            }
                            showSpinner(context);
                            if (tokenName.toUpperCase() == 'USDT' || tokenName.toUpperCase() == 'CLC' || tokenName.toUpperCase() == 'RYO') {
                              WalletAPI.transferERC20Bnb(wallet, tokenAdress, double.tryParse(amountController.text) ?? 0.0, adressController.text, 'assets/usdt.abi.json').then((_) {
                                hideSpinner(context);
                                Navigator.of(context).pop();
                              }).catchError((e) {
                                hideSpinner(context);
                                showError(context, 'Insufficient funds').then((_) => Navigator.of(context).pop());
                              });
                            } else if (tokenName.toUpperCase() == 'BNB') {
                              WalletAPI.transferBNB(
                                wallet,
                                double.tryParse(amountController.text) ?? 0.0,
                                adressController.text,
                              ).then((_) {
                                hideSpinner(context);
                                Navigator.of(context).pop();
                              }).catchError((e) {
                                hideSpinner(context);
                                showError(context, 'Insufficient funds').then((_) => Navigator.of(context).pop());
                              });
                            } else if (tokenName.toUpperCase() == 'BB' || tokenName.toLowerCase() == 'BA' || tokenName.toLowerCase() == 'GWS' || tokenName.toLowerCase() == 'GFS') {
                              WalletAPI.transfer1155Bnb(wallet, tokenAdress, tokenId!, int.tryParse(amountController.text) ?? 0, adressController.text).then((_) {
                                hideSpinner(context);
                                Navigator.of(context).pop();
                              }).catchError((e) {
                                hideSpinner(context);
                                showError(context, 'Insufficient funds').then((_) => Navigator.of(context).pop());
                              });
                            }
                          },
                          disabled: adressController.text.isEmpty || amountController.text.isEmpty || (double.tryParse(amountController.text) ?? 0.0) <= 0 || (double.tryParse(amountController.text) ?? 0.0) > balance,
                          params: {'text': 'confirm', 'width': width, 'height': height},
                          child: loginBtn,
                        )),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  static void openTransferModalPageHero({required BuildContext context, required double width, required double height, required HDWallet wallet, required String iconPath, required int heroId}) {
    TextEditingController addressController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (context, StateSetter setState) => GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  image: DecorationImage(image: modalBottomsheetBg, fit: BoxFit.fill)),
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28.0, 28.0, 28.0, 0.0), // content padding
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      PresButton(
                        onTap: () => Navigator.of(context).pop(),
                        params: {'width': width},
                        child: backBtn,
                      ),
                      FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: width * 0.05,
                              ),
                              child: Center(
                                  child: Text(
                                ' withdraw',
                                style: TextStyle(
                                  fontFamily: 'AmazObitaemOstrovItalic',
                                  fontSize: 37 / 844 * height,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                              )))),
                    ]),
                    Padding(
                        padding: EdgeInsets.only(top: height * 0.02, bottom: height * 0.02),
                        child: SvgPicture.asset(
                          iconPath,
                          height: height * 0.11,
                          fit: BoxFit.fitHeight,
                        )),
                    Padding(
                        padding: EdgeInsets.only(top: height * 0.02),
                        child: SamuraiTextField(
                          screeenHeight: height,
                          screeenWidth: width,
                          hint: "To address",
                          controller: addressController,
                          onChanged: (_) => setState(() {}),
                        )),
                    Padding(
                        padding: EdgeInsets.only(top: height * 0.02, bottom: height * 0.01),
                        child: PresButton(
                          onTap: () async {
                            if (addressController.text.isEmpty) {
                              return;
                            }
                            showSpinner(context);

                            await WalletAPI.transferHero(wallet, addressController.text, heroId).then((value) {
                              hideSpinner(context);
                              Navigator.pop(context);
                            });
                          },
                          disabled: addressController.text.isEmpty,
                          params: {'text': 'confirm', 'width': width, 'height': height},
                          child: loginBtn,
                        )),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
