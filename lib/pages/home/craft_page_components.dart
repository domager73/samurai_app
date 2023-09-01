import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samurai_app/components/show_error.dart';
import 'package:samurai_app/components/storage.dart';
import 'package:samurai_app/data/music_manager.dart';
import 'package:samurai_app/pages/tfa_page.dart';
import 'package:samurai_app/utils/fonts.dart';
import 'package:samurai_app/widgets/popups/custom_choose_popup.dart';

import '../../api/rest.dart';
import '../../api/wallet.dart';
import '../../components/anim_button.dart';
import '../../components/pop_up_spinner.dart';
import '../../components/samurai_text_field.dart';
import '../../components/show_confirm.dart';
import '../../widgets/popups/custom_popup.dart';

class CraftPageComponents {
  static Future<void> openTransferModalPage({
    required BuildContext context,
    required double width,
    required double height,
    required String samuraiTypeIngame,
    required int balance,
    required int lockedBalance,
    required double gas,
    required double balanceWithdraw,
    required String samuraiTypeRegular,
    required String samuraiTypeGenesis,
    required int samuraiGenesisBalance,
  }) async {
    String mode = 'toFree';
    String modeWithdraw = 'REGULAR';
    TextEditingController controller = TextEditingController();
    TextEditingController controllerWithdraw = TextEditingController();
    int switchMode = 0;

    Widget tabIngame(BuildContext context, double width, double height, String samuraiTypeIngame, int balance, lockedBalance, String mode, Function onShitchMode, Function onAllBtn) {
      return StatefulBuilder(
          builder: (context, StateSetter setState) => GestureDetector(
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(top: width * 0.0, bottom: width * 0.04, left: width * 0.02, right: width * 0.02),
                      child: SizedBox(
                        height: width * 0.37,
                        child: Stack(
                          children: [
                            SvgPicture.asset(
                              'assets/pages/homepage/craft/transfer_border.svg',
                              fit: BoxFit.fitWidth,
                              width: width - width * 0.14,
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: width * 0.175, left: width * 0.04),
                                child: SvgPicture.asset(
                                  'assets/pages/homepage/craft/transfer_line.svg',
                                  fit: BoxFit.fitWidth,
                                  width: width - width * 0.54,
                                )),
                            Row(
                              children: [
                                const Spacer(flex: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Spacer(flex: 20),
                                    Expanded(
                                        flex: 47,
                                        child: Row(children: [
                                          Text(
                                            'FROM',
                                            style: GoogleFonts.spaceMono(
                                              fontWeight: FontWeight.w700,
                                              fontSize: width * 0.028,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Padding(
                                              padding: EdgeInsets.only(left: width * 0.04),
                                              child: FittedBox(
                                                fit: BoxFit.fitHeight,
                                                child: Text(
                                                  mode == 'toArmy' ? 'FREE' : 'ARMY',
                                                  style: GoogleFonts.spaceMono(
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ))
                                        ])),
                                    const Spacer(flex: 30),
                                    Expanded(
                                      flex: 47,
                                      child: Row(children: [
                                        Text(
                                          'TO  ',
                                          style: GoogleFonts.spaceMono(
                                            fontWeight: FontWeight.w700,
                                            fontSize: width * 0.028,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(left: width * 0.04),
                                            child: FittedBox(
                                              fit: BoxFit.fitHeight,
                                              child: Text(
                                                mode == 'toArmy' ? 'ARMY' : 'FREE',
                                                style: GoogleFonts.spaceMono(
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ))
                                      ]),
                                    ),
                                    const Spacer(flex: 28),
                                  ],
                                ),
                                const Spacer(flex: 24),
                                Expanded(
                                  flex: 15,
                                  child: AnimButton(
                                    shadowType: 2,
                                    player: GetIt.I<MusicManager>().okCanselTransPlayer,
                                    onTap: () {
                                      onShitchMode();
                                    },
                                    child: SvgPicture.asset(
                                      'assets/swap_change_bt.svg',
                                      fit: BoxFit.fitWidth,
                                      height: height * 0.1,
                                    ),
                                  ),
                                ),
                                const Spacer(flex: 6),
                              ],
                            ),
                          ],
                        ),
                      )),
                  Padding(
                      padding: EdgeInsets.only(bottom: width * 0.04),
                      child: SamuraiTextField(
                          screeenHeight: height,
                          screeenWidth: width,
                          hint: 'Amount',
                          keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: false),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*')),
                          ],
                          controller: controller,
                          onChanged: (_) {
                            setState(() {});
                          },
                          allButton: () {
                            onAllBtn();
                          })),
                  Padding(
                      padding: EdgeInsets.only(bottom: width * 0.02),
                      child: Row(children: [
                        Text(
                          "Available: ${mode == 'toArmy' ? balance : lockedBalance} ",
                          style: GoogleFonts.spaceMono(
                            fontSize: 13 / 844 * height,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          mode == 'toArmy' ? 'Free' : 'Army',
                          style: GoogleFonts.spaceMono(
                            fontWeight: FontWeight.w700,
                            fontSize: 13 / 844 * height,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          " Samurai",
                          style: GoogleFonts.spaceMono(
                            fontSize: 13 / 844 * height,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                      ])),
                  PresButton(
                    onTap: () async {
                      try {
                        if (controller.text.isEmpty) {
                          return;
                        }
                        showSpinner(context);
                        if (mode == 'toArmy') {
                          await Rest.transferSamuraiToArmy(
                            int.tryParse(controller.text) ?? 0,
                            samuraiTypeIngame,
                          );
                        } else if (mode == 'toFree') {
                          await Rest.transferSamuraiToFree(
                            int.tryParse(controller.text) ?? 0,
                            samuraiTypeIngame,
                          );
                        }
                        if (context.mounted) {
                          hideSpinner(context);
                        }
                      } catch (e) {
                        hideSpinner(context);

                        await showDialog(
                          context: context,
                          builder: (context) => const CustomPopup(text: 'Insufficient funds', isError: true),
                        );
                      }
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                    disabled: controller.text.isEmpty || (int.tryParse(controller.text) ?? 0) <= 0 || (int.tryParse(controller.text) ?? 0) > (mode == 'toArmy' ? balance : lockedBalance),
                    params: {'text': 'confirm', 'width': width, 'height': height},
                    child: loginBtn,
                  ),
                ],
              )));
    }

    Future<void> transferSamurai() async {
      try {
        if (controllerWithdraw.text.isEmpty) {
          return;
        }
        showSpinner(context);
        await Rest.transfer(
          WalletAPI.chainIdBnb,
          double.tryParse(controllerWithdraw.text) ?? 0.0,
          modeWithdraw == 'REGULAR' ? samuraiTypeRegular : samuraiTypeGenesis,
          AppStorage().read('wallet_adress') as String,
        );
        if (context.mounted) {
          hideSpinner(context);
        }
      } catch (e) {
        hideSpinner(context);
        await showDialog(
          context: context,
          builder: (context) => const CustomPopup(text: 'Insufficient funds. Deposit some BNB to your crypto wallet.', isError: true),
        );
      }
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }

    Widget tabWithdraw(BuildContext context, double width, double height, double gas, int balanceWithdraw, String mode, Function(String) onShitchMode, Function onAllBtn) {
      return StatefulBuilder(
          builder: (context, StateSetter setState) => Wrap(alignment: WrapAlignment.center, crossAxisAlignment: WrapCrossAlignment.center, children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(top: width * 0.0, bottom: width * 0.04, left: width * 0.02, right: width * 0.02),
                    child: SizedBox(
                      height: width * 0.37,
                      child: Stack(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  flex: 30,
                                  child: SizedBox(
                                      height: width * 0.2,
                                      child: AnimButton(
                                          player: GetIt.I<MusicManager>().smallKeyRegAmountAllPlayer,
                                          shadowType: 1,
                                          onTap: () {
                                            CraftPageComponents.openSwitchDialog(
                                                context: context,
                                                width: width,
                                                height: height,
                                                onSwitch: (val) async {
                                                  await GetIt.I<MusicManager>().smallKeyRegAmountAllPlayer.play().then((value) async {
                                                    await GetIt.I<MusicManager>().smallKeyRegAmountAllPlayer.seek(Duration(seconds: 0));
                                                  });

                                                  if (val == 1) {
                                                    onShitchMode('REGULAR');
                                                  } else {
                                                    onShitchMode('GENESIS');
                                                  }
                                                },
                                                valSwitch: mode == 'REGULAR' ? 1 : 0);
                                          },
                                          child: Stack(children: [
                                            Padding(
                                                padding: EdgeInsets.only(left: width * 0.0, top: width * 0.05),
                                                child: Image.asset(
                                                  'assets/pages/homepage/craft/btn_sel.png',
                                                  fit: BoxFit.fitHeight,
                                                  height: width * 0.105,
                                                )),
                                            Padding(
                                              padding: EdgeInsets.only(left: width * 0.12, top: width * 0.07),
                                              child: Text(mode,
                                                  style: GoogleFonts.spaceMono(
                                                    fontSize: width * 0.036,
                                                    fontWeight: FontWeight.w700,
                                                    color: const Color(0xFF00FFFF),
                                                  )),
                                            )
                                          ])))),
                              const Spacer(flex: 6),
                              Expanded(
                                flex: 15,
                                child: SvgPicture.asset(
                                  'assets/nft_bnb.svg',
                                  fit: BoxFit.fitWidth,
                                  height: height * 0.2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.only(bottom: width * 0.04),
                    child: SamuraiTextField(
                        screeenHeight: height,
                        screeenWidth: width,
                        hint: 'Quantity',
                        keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: false),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*')),
                        ],
                        controller: controllerWithdraw,
                        onChanged: (_) {
                          setState(() {});
                        },
                        allButton: () {
                          onAllBtn();
                        })),
                Container(
                    width: width,
                    padding: EdgeInsets.only(bottom: width * 0.02),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          modeWithdraw == 'GENESIS' ? "Available: ${samuraiGenesisBalance} GENESIS SAMURAI" : "Available: ${num.parse(balanceWithdraw.toStringAsFixed(0))} SAMURAI",
                          // HERE
                          style: GoogleFonts.spaceMono(
                            fontSize: 13 / 844 * height,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Gas: ${gas.toStringAsFixed(9)} BNB",
                          style: GoogleFonts.spaceMono(
                            fontSize: 13 / 844 * height,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )),
                PresButton(
                  onTap: () {
                    final useTfa = AppStorage().read('use-tfa');
                    if (useTfa != null && useTfa == '1') {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const TfaPage())).then((res) {
                        if (res) {
                          transferSamurai();
                        }
                      });
                    } else {
                      transferSamurai();
                    }
                  },
                  disabled: controllerWithdraw.text.isEmpty || (int.tryParse(controllerWithdraw.text) ?? 0) <= 0 || (int.tryParse(controllerWithdraw.text) ?? 0) > balanceWithdraw,
                  params: {'text': 'confirm', 'width': width, 'height': height},
                  child: loginBtn,
                ),
              ]));
    }

    Widget switchType(double width, int switchMode, Function onSwitch) {
      return Stack(children: [
        SizedBox(
            width: width * (switchMode == 0 ? 0.45 : 0.53),
            child: InkWell(
                onTap: () async {
                  await GetIt.I<MusicManager>().menuSettingsSignWaterPlayer.play().then((value) async {
                    await GetIt.I<MusicManager>().menuSettingsSignWaterPlayer.seek(Duration(seconds: 0));
                  });
                  onSwitch(0);
                },
                child: SvgPicture.asset(
                  'assets/pages/homepage/craft/ingame_$switchMode.svg',
                  fit: BoxFit.fitWidth,
                ))),
        Padding(
            padding: EdgeInsets.only(left: width * 0.34, top: width * (switchMode == 0 ? 0.004 : 0.009)),
            child: SizedBox(
                width: width * (switchMode == 0 ? 0.483 : 0.46),
                child: InkWell(
                    onTap: () async {
                      await GetIt.I<MusicManager>().menuSettingsSignWaterPlayer.play().then((value) async {
                        await GetIt.I<MusicManager>().menuSettingsSignWaterPlayer.seek(Duration(seconds: 0));
                      });
                      onSwitch(1);
                    },
                    child: SvgPicture.asset('assets/pages/homepage/craft/withdraw_$switchMode.svg', fit: BoxFit.fitWidth))))
      ]);
    }

    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) => StatefulBuilder(
            builder: (context, StateSetter setState) => Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                    image: DecorationImage(image: AssetImage('assets/modal_bottom_sheet_bg.png'), fit: BoxFit.fill)),
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(18.0, 28.0, 18.0, 0.0), // content padding
                    child: Wrap(alignment: WrapAlignment.center, crossAxisAlignment: WrapCrossAlignment.center, children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                          // content padding
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              PresButton(
                                onTap: () async {
                                  await GetIt.I<MusicManager>().popupDownSybMenuPlayer.play().then((value) async {
                                    await GetIt.I<MusicManager>().popupDownSybMenuPlayer.seek(Duration(seconds: 0));
                                  });

                                  Navigator.of(context).pop();
                                },
                                params: {'width': width},
                                child: backBtn,
                                player: GetIt.I<MusicManager>().keyBackSignCloseX,
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'transfer',
                                    style: AppTypography.amazObitW400White,
                                  ),
                                ),
                              ),
                              AnimButton(
                                shadowType: 2,
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: ((context) => CustomPopup(
                                            isError: false,
                                            text: switchMode == 0
                                                ? 'Army Samurai can participate in battles and accumulate XP. Free Samurai can be withdrawn to your wallet. Army Samurai must be at 100% health to transfer.'
                                                : 'You can withdraw Free Samurai, after which they will available on your wallet',
                                          )));
                                },
                                child: SvgPicture.asset(
                                  'assets/pages/homepage/craft/info.svg',
                                  height: width * 0.12,
                                  width: width * 0.12,
                                ),
                              )
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(top: width * 0.03, bottom: width * 0.03),
                          child: switchType(width, switchMode, (mode) async {
                            setState(() {
                              switchMode = mode;
                            });
                          })),
                      Padding(
                          padding: EdgeInsets.only(top: width * 0.03, bottom: width * 0.03, left: width * 0.03, right: width * 0.03),
                          child: SizedBox(
                              height: height * 0.5,
                              child: switchMode == 0
                                  ? tabIngame(context, width, height, samuraiTypeIngame, balance, lockedBalance, mode, () {
                                      setState(() {
                                        mode == 'toArmy' ? mode = 'toFree' : mode = 'toArmy';
                                      });
                                    }, () {
                                      setState(() {
                                        controller.text = (mode == 'toArmy' ? balance : lockedBalance).toStringAsFixed(0);
                                      });
                                    })
                                  : tabWithdraw(context, width, height, gas, balanceWithdraw.toInt(), modeWithdraw, (val) {
                                      setState(() {
                                        modeWithdraw = val;
                                      });
                                    }, () {
                                      setState(() {
                                        controllerWithdraw.text = (balanceWithdraw).toStringAsFixed(0);
                                      });
                                    }))),
                    ])))));
  }

  static Future<void> openHealModalPage({
    required BuildContext context,
    required double width,
    required double height,
  }) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (context, StateSetter setState) => SizedBox(
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
                        children: [
                          PresButton(
                            onTap: () async {
                              await GetIt.I<MusicManager>().popupDownSybMenuPlayer.play().then((value) async {
                                await GetIt.I<MusicManager>().popupDownSybMenuPlayer.seek(Duration(seconds: 0));
                              });

                              Navigator.of(context).pop();
                            },
                            params: {'width': width},
                            child: backBtn,
                            player: GetIt.I<MusicManager>().keyBackSignCloseX,
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                'heal',
                                style: TextStyle(
                                  fontFamily: 'AmazObitaemOstrovItalic',
                                  fontSize: 37 / 844 * height,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          AnimButton(
                            shadowType: 2,
                            onTap: () async {
                              showDialog(
                                  context: context,
                                  builder: (context) => const CustomPopup(
                                        isError: false,
                                        text: 'You will not be able to participate in battles when the health of your Army drops to 0%. You can heal the Army or add new Samurai to the Army to replenish the health bar.',
                                      ));
                            },
                            child: SvgPicture.asset(
                              'assets/pages/homepage/craft/info.svg',
                              height: width * 0.12,
                              width: width * 0.12,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(flex: 23),
                      Expanded(
                        flex: 67,
                        child: SvgPicture.asset(
                          'assets/heart.svg',
                          width: width * 0.5,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      const Spacer(flex: 12),
                      Text(
                        "HEALTH: 100%",
                        style: GoogleFonts.spaceMono(
                          fontSize: 13 / 844 * height,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF00FFFF),
                        ),
                      ), //TODO value
                      const Spacer(flex: 21),
                      Text(
                        "CURE ALL THE SAMURAI IN\nTHE ARMY?",
                        style: GoogleFonts.spaceMono(
                          fontSize: 16 / 844 * height,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(flex: 12),
                      PresButton(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) => CustomChoosePopup(
                                  acceptFunction: () {
                                    Navigator.of(context).popUntil((route) => route.isFirst);
                                  },
                                  canselFunction: () {
                                    Navigator.pop(context);
                                  },
                                  text: "Are you sure you want to spend RYO to heal your army?"));
                        },
                        disabled: true,
                        params: {
                          'text': 'treat for 0 RYO',
                          //TODO: Формула следующая: восстановление 0,1 XP стоит 0,4 RYO за каждого Самурая в армии. Восстановить XP можно только до 100%.
                          'width': width,
                          'height': height
                        },
                        child: loginBtn,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> openSwitchDialog({required BuildContext context, required double width, required double height, required Function(int) onSwitch, required int valSwitch}) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => StatefulBuilder(
            builder: (context, StateSetter setState) => Dialog(
                insetPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                elevation: 0,
                backgroundColor: Colors.transparent,
                child: Padding(
                    padding: EdgeInsets.only(top: width * 0.28, left: width * 0.1, right: width * 0.445),
                    child: Stack(children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(top: width * 0.09),
                          child: Image.asset(
                            'assets/pages/homepage/craft/btn_sel_open.png',
                            fit: BoxFit.fitWidth,
                            width: width - width * 0.09,
                          )),
                      Padding(
                          padding: EdgeInsets.only(top: width * 0.075, left: width * 0.088, right: width * 0.02),
                          child: TextButton(
                              onPressed: () {
                                onSwitch(valSwitch == 0 ? 0 : 1);
                                Navigator.of(context).pop();
                              },
                              child: Text(valSwitch == 0 ? 'GENESIS' : 'REGULAR',
                                  style: GoogleFonts.spaceMono(
                                    fontWeight: FontWeight.w700,
                                    fontSize: width * 0.036,
                                    color: const Color(0xFF00FFFF),
                                  )))),
                      Padding(
                          padding: EdgeInsets.only(top: width * 0.195, left: width * 0.02, right: width * 0.02),
                          child: SvgPicture.asset(
                            'assets/pages/homepage/craft/transfer_line.svg',
                            fit: BoxFit.fitWidth,
                            width: width - width * 0.54,
                          )),
                      Padding(
                          padding: EdgeInsets.only(top: width * 0.19, left: width * 0.088, right: width * 0.02),
                          child: TextButton(
                              onPressed: () {
                                onSwitch(valSwitch == 1 ? 0 : 1);
                                Navigator.of(context).pop();
                              },
                              child: Text(valSwitch == 1 ? 'GENESIS' : 'REGULAR',
                                  style: GoogleFonts.spaceMono(
                                    fontWeight: FontWeight.w700,
                                    fontSize: width * 0.036,
                                    color: Colors.white,
                                  )))),
                    ])))));
  }
}
