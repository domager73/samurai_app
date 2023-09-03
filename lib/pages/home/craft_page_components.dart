import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samurai_app/components/storage.dart';
import 'package:samurai_app/data/music_manager.dart';
import 'package:samurai_app/pages/tfa_page.dart';
import 'package:samurai_app/utils/colors.dart';
import 'package:samurai_app/utils/fonts.dart';
import 'package:samurai_app/widgets/painters/painter_drop_list_border.dart';
import 'package:samurai_app/widgets/painters/painter_transfer_samurai.dart';
import 'package:samurai_app/widgets/popups/custom_choose_popup.dart';

import '../../api/rest.dart';
import '../../api/wallet.dart';
import '../../components/anim_button.dart';
import '../../components/pop_up_spinner.dart';
import '../../components/samurai_text_field.dart';
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
    bool isActive = true;

    Widget tabIngame(BuildContext context, double width, double height, String samuraiTypeIngame, int balance, lockedBalance, String mode,
        Function onShitchMode, Function onAllBtn) {
      return StatefulBuilder(
          builder: (context, StateSetter setState) => GestureDetector(
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Column(
                children: <Widget>[
                  CustomPaint(
                    painter: TransferSamuraiPainter(),
                    child: Container(
                        padding: const EdgeInsets.only(top: 33, bottom: 33, right: 24, left: 24,),
                        width: double.infinity,
                        height: 146,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.end, children: [
                                    SizedBox(
                                      width: 40,
                                      child: Text(
                                        textAlign: TextAlign.start,
                                        "from".toUpperCase(),
                                        style: GoogleFonts.spaceMono(
                                            fontWeight: FontWeight.w800, fontSize: 13, color: Colors.white, textStyle: TextStyle(height: 1)),
                                      ),
                                    ),
                                    Text(
                                      mode == 'toArmy' ? 'FREE' : 'ARMY',
                                      textHeightBehavior: TextHeightBehavior(),
                                      style: GoogleFonts.spaceMono(
                                          fontWeight: FontWeight.w700, color: Colors.white, fontSize: 20, textStyle: TextStyle(height: 0.927)),
                                      textAlign: TextAlign.start,
                                    ),
                                  ]),
                                  Container(color: Colors.white.withOpacity(0.6), height: 1, margin: const EdgeInsets.only(top: 22, bottom: 16)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        width: 40,
                                        child: Text(
                                          "to".toUpperCase(),
                                          style: GoogleFonts.spaceMono(
                                              fontWeight: FontWeight.w800, fontSize: 13, color: Colors.white, textStyle: TextStyle(height: 1)),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      Text(
                                        textAlign: TextAlign.start,
                                        mode == 'toArmy' ? 'ARMY' : 'FREE',
                                        style: GoogleFonts.spaceMono(
                                            fontWeight: FontWeight.w700, color: Colors.white, textStyle: TextStyle(height: 0.927), fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 25),
                            AnimButton(
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
                          ],
                        )),
                  ),
                  const SizedBox(height: 30),
                  SamuraiTextField(
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
                      }),
                  Row(children: [
                    Text(
                      "Available: ${mode == 'toArmy' ? balance : lockedBalance} ",
                      style: AppTypography.spaceMonoReg13White,
                    ),
                    Text(
                      mode == 'toArmy' ? 'Free' : 'Army',
                      style: AppTypography.spaceMonoBold13,
                    ),
                    Text(
                      " Samurai",
                      style: AppTypography.spaceMonoReg13White,
                    ),
                  ]),
  const SizedBox(height: 10),
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
                    disabled: controller.text.isEmpty ||
                        (int.tryParse(controller.text) ?? 0) <= 0 ||
                        (int.tryParse(controller.text) ?? 0) > (mode == 'toArmy' ? balance : lockedBalance),
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

    DropdownMenuItem buildDropDownItem(String value, String modeWithdraw, BuildContext context, bool v, Function tap) {
      Size size = MediaQuery.sizeOf(context);
      bool primaryCard = modeWithdraw.toUpperCase() == value.toUpperCase();
      log("$value $v");
      return DropdownMenuItem(
          value: value.toUpperCase(),
          child: Container(
              height: 53,
              padding: EdgeInsets.only(left: size.width * 0.064, right: size.width * 0.064, top: 5, bottom: 5),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 1,
                  ),
                  Text(
                    value.toUpperCase(),
                    style: AppTypography.spaceMonoW700Blue16.copyWith(color: primaryCard ? AppColors.textBlue : Colors.white),
                  ),
                  primaryCard
                      ? Transform.rotate(angle: v ? 3.14 : 0, child: Icon(Icons.expand_less_rounded, size: 40, color: AppColors.textBlue))
                      : SizedBox(width: 40)
                ],
              )));
    }

    Widget tabWithdraw(BuildContext context, double width, double height, double gas, int balanceWithdraw, String mode, Function(String) onShitchMode,
        Function onAllBtn, bool isActive, Function changeActive) {
      return StatefulBuilder(builder: (context, StateSetter setState) {
        var dropList = [
          buildDropDownItem("regular", modeWithdraw, context, isActive, changeActive),
          buildDropDownItem("genesis", modeWithdraw, context, isActive, changeActive),
        ];

        return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomPaint(
                painter: DropDownListBorderPainter(),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    menuItemStyleData: MenuItemStyleData(
                      padding: EdgeInsets.zero,
                    ),
                    isExpanded: true,
                    alignment: Alignment.center,
                    dropdownStyleData: const DropdownStyleData(
                        maxHeight: null,
                        padding: EdgeInsets.zero,
                        isOverButton: true,
                        elevation: 0,
                        decoration: BoxDecoration(
                            color: Colors.transparent, image: DecorationImage(fit: BoxFit.fill, image: AssetImage("assets/drop_bg.png")))),
                    buttonStyleData: ButtonStyleData(
                      padding: const EdgeInsets.only(
                        right: 0,
                      ),
                      height: 53,
                      width: width * 0.58,
                    ),
                    iconStyleData: const IconStyleData(icon: Icon(Icons.expand_more_rounded, color: Colors.transparent, size: 0)),
                    value: mode,
                    items: modeWithdraw == 'REGULAR' ? dropList : dropList.reversed.toList(),
                    onChanged: (value) {
                      onShitchMode(value!);
                    },
                  ),
                ),
              ),
              SvgPicture.asset(
                'assets/nft_bnb.svg',
                fit: BoxFit.fitWidth,
                width: width * 0.225,
              ),
            ],
          ),
          const SizedBox(
            height: 31,
          ),
          SamuraiTextField(
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
              }),
          const SizedBox(
            height: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                modeWithdraw == 'GENESIS'
                    ? "Available: ${samuraiGenesisBalance} GENESIS SAMURAI"
                    : "Available: ${num.parse(balanceWithdraw.toStringAsFixed(0))} SAMURAI",
                style: AppTypography.spaceMonoReg13White,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Gas: ${gas.toStringAsFixed(9)} BNB",
                style: AppTypography.spaceMonoReg13White,
              ),
            ],
          ),
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
            disabled: controllerWithdraw.text.isEmpty ||
                (int.tryParse(controllerWithdraw.text) ?? 0) <= 0 ||
                (int.tryParse(controllerWithdraw.text) ?? 0) > balanceWithdraw,
            params: {'text': 'confirm', 'width': width, 'height': height},
            child: loginBtn,
          ),
        ]);
      });
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
        builder: (BuildContext context) => GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: StatefulBuilder(
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
                                    // height: height * 0.5,
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
                                        : tabWithdraw(
                                            context,
                                            width,
                                            height,
                                            gas,
                                            balanceWithdraw.toInt(),
                                            modeWithdraw,
                                            (val) {
                                              setState(() {
                                                modeWithdraw = val;
                                              });
                                            },
                                            () {
                                              setState(() {
                                                controllerWithdraw.text = (balanceWithdraw).toStringAsFixed(0);
                                              });
                                            },
                                            isActive,
                                            () {
                                              setState(() {
                                                isActive = !isActive;
                                              });
                                            }))),
                          ])))),
            ));
  }

  static Future<void> openHealModalPage(
      {required BuildContext context, required double width, required double height, required int switchMode}) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (context, StateSetter setState) => Container(
          padding: const EdgeInsets.all(28),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    'assets/modal_bottom_sheet_bg.png',
                  ))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                        style: AppTypography.amazObitW400White,
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
                                text:
                                    'You will not be able to participate in battles when the health of your Army drops to 0%. You can heal the Army or add new Samurai to the Army to replenish the health bar.',
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

              const SizedBox(height: 10),

              Container(
                constraints: const BoxConstraints(maxWidth: 150),
                child: SvgPicture.asset(
                  'assets/heart_${switchMode == 0 ? "water" : "fire"}.svg',
                  width: width * 0.185,
                  fit: BoxFit.fitHeight,
                ),
              ),
              const SizedBox(height: 12),

              Text("HEALTH: 100%", style: AppTypography.spaceMonoBold13.copyWith(color: AppColors.textBlue)), //TODO value
              const SizedBox(height: 21),

              Text(
                "CURE ALL THE SAMURAI IN\nTHE ARMY?",
                style: AppTypography.spaceMonoW700Blue16.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
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
    );
  }

  static Future<void> openSwitchDialog(
      {required BuildContext context, required double width, required double height, required Function(int) onSwitch, required int valSwitch}) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => StatefulBuilder(
            builder: (context, StateSetter setState) => Dialog(
                insetPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                elevation: 0,
                backgroundColor: Colors.red,
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
                      TextButton(
                          onPressed: () {
                            onSwitch(valSwitch == 0 ? 0 : 1);
                            Navigator.of(context).pop();
                          },
                          child: Text(valSwitch == 0 ? 'GENESIS' : 'REGULAR', style: AppTypography.spaceMonoW700Blue16)),
                      Padding(
                          padding: EdgeInsets.only(top: width * 0.195, left: width * 0.02, right: width * 0.02),
                          child: SvgPicture.asset(
                            'assets/pages/homepage/craft/transfer_line.svg',
                            fit: BoxFit.fitWidth,
                            width: width - width * 0.54,
                          )),
                      TextButton(
                          onPressed: () {
                            onSwitch(valSwitch == 1 ? 0 : 1);
                            Navigator.of(context).pop();
                          },
                          child:
                              Text(valSwitch == 1 ? 'GENESIS' : 'REGULAR', style: AppTypography.spaceMonoW700Blue16.copyWith(color: Colors.white))),
                    ])))));
  }
}
