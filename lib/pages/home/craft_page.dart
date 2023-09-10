import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:samurai_app/data/music_manager.dart';
import 'package:samurai_app/pages/home/craft_page_components.dart';
import 'package:samurai_app/utils/gradients.dart';
import 'package:samurai_app/widgets/snackbar/custom_snackbar.dart';
import 'package:samurai_app/widgets/painters/samurai_heal_border.dart';
import 'package:samurai_app/widgets/painters/samurai_trans_border.dart';

import '../../api/rest.dart';
import '../../components/anim_button.dart';
import '../../components/bg.dart';
import '../../components/blinking_time.dart';
import '../../components/samurai_storage.dart';
import '../../components/storage.dart';

class CraftPage extends StatefulWidget {
  const CraftPage({super.key, required this.craftSwitch});

  final int craftSwitch;

  @override
  State<CraftPage> createState() => _CraftPageState();
}

class _CraftPageState extends State<CraftPage> {
  var maxXP =
      120.0; // TO-DO: this should be updated to current max XP every time
  late final ScrollController scrollController;

  late Map<String, dynamic> info;
  int fireSamuraiGenesisBalance = 0;
  int waterSamuraiGenesisBalance = 0;

  int fireSamuraiBalance = 0;
  int lockedFireSamuraiBalance = 0;
  double fireSamuraiXp = 0.0;
  int waterSamuraiBalance = 0;
  int lockedWaterSamuraiBalance = 0;
  double waterSamuraiXp = 0.0;
  int fireSamuraiUnclaimedXp = 0;
  int waterSamuraiUnclaimedXp = 0;
  DateTime? waterSamuraiXpExpiresDate;
  DateTime? fireSamuraiXpExpiresDate;

  String? samuraiXpExpiresDate;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();
    loadInfo();
    setStorageData();

    calcSamuraiXpExpiresDate();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (!mounted) {
        timer.cancel();
      }
      calcSamuraiXpExpiresDate();
    });
  }

  void loadInfo() {
    samuraiStorage.loadInfo().then((_) => setStorageData());
  }

  void setStorageData() {
    setState(() {
      lockedFireSamuraiBalance = samuraiStorage.lockedFireSamuraiBalance;
      fireSamuraiBalance = samuraiStorage.fireSamuraiBalance -
          samuraiStorage.lockedFireSamuraiBalance -
          samuraiStorage.fireSamuraiInFight;
      fireSamuraiXp = samuraiStorage.fireSamuraiXp;
      lockedWaterSamuraiBalance = samuraiStorage.lockedWaterSamuraiBalance;
      waterSamuraiBalance = samuraiStorage.waterSamuraiBalance -
          samuraiStorage.lockedWaterSamuraiBalance -
          samuraiStorage.waterSamuraiInFight;
      waterSamuraiXp = samuraiStorage.waterSamuraiXp;
      waterSamuraiXpExpiresDate = samuraiStorage.waterSamuraiXpExpiresDate;
      fireSamuraiXpExpiresDate = samuraiStorage.fireSamuraiXpExpiresDate;
      fireSamuraiUnclaimedXp = samuraiStorage.fireSamuraiUnclaimedXp;
      waterSamuraiUnclaimedXp = samuraiStorage.waterSamuraiUnclaimedXp;
      fireSamuraiGenesisBalance = min(
          (samuraiStorage.fireSamuraiBalance -
              samuraiStorage.lockedFireSamuraiBalance -
              samuraiStorage.fireSamuraiInFight),
          samuraiStorage.fireSamuraiGenesisBalance);
      waterSamuraiGenesisBalance = min(
          (samuraiStorage.waterSamuraiBalance -
              samuraiStorage.lockedWaterSamuraiBalance -
              samuraiStorage.waterSamuraiInFight),
          samuraiStorage.waterSamuraiGenesisBalance);
    });
  }

  void calcSamuraiXpExpiresDate() {
    final now = DateTime.now();
    DateTime end = DateTime(now.year, now.month, now.day, 11, 59, 59);
    final diff = now.subtract(now.timeZoneOffset).difference(end);

    setState(() {
      samuraiXpExpiresDate = DateFormat.Hm().format(DateTime(
          now.year,
          now.month,
          now.day,
          -diff.inHours,
          -diff.inMinutes + diff.inHours * 60));
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus();
      },
      child: RawScrollbar(
          radius: const Radius.circular(36),
          thumbColor: const Color(0xFF00FFFF),
          thumbVisibility: true,
          controller: scrollController,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.02),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
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
                        return Container(
                          width: MediaQuery.sizeOf(context).width,
                          padding: const EdgeInsets.only(right: 23),
                          child: Stack(children: [
                            Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                    child: getStats(width, height, user))),
                            Align(
                                alignment: Alignment.topLeft,
                                child: getCharacter(width)),
                          ]),
                        );
                      }),
                  Padding(
                      padding: EdgeInsets.only(
                        top: width * 0.05,
                        left: width * 0.05,
                        right: width * 0.05,
                      ),
                      child: getLoader(height, width)),
                  Padding(
                    padding: EdgeInsets.only(
                        top: width * 0.01,
                        left: width * 0.05,
                        right: width * 0.05),
                    child: getCraftButton(width, height),
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget clameBlock(BuildContext context, double width) {
    return Stack(children: [
      Padding(
          padding: EdgeInsets.only(
              top: width * 0.02, left: width * 0.054),
          child: SvgPicture.asset(
            'assets/pages/homepage/craft/clame_border.svg',
            fit: BoxFit.fitWidth,
            width: width * 0.91,
          )),
      Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
                padding:
                    EdgeInsets.only(top: width * 0.048, left: width * 0.11),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: width * 0.055, left: width * 0.121),
                        child: BlinkingTime(
                          style: GoogleFonts.spaceMono(
                            fontSize: width * 0.04,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFFFFFFF),
                          ),
                          getTime: getXpTime,
                        ),
                      ),
                      Row(children: [
                        Text("XP/Day: ",
                            style: GoogleFonts.spaceMono(
                              fontSize: width * 0.034,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF00FFFF),
                            )),
                        Text("+${getDaylyXp()} XP ",
                            style: GoogleFonts.spaceMono(
                              fontSize: width * 0.034,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFFFFFFF),
                            ))
                      ])
                    ])),
            Padding(
                padding: EdgeInsets.only(
                    top: width * 0.087,right: 18),
                child: Stack(children: [
                  AnimButton(
                      player: GetIt.I<MusicManager>().zeroAmountNumberPlayer,
                      onTap: () {
                        if ((widget.craftSwitch == 0) &&
                            (waterSamuraiXp >= maxXP)) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                              buildCustomSnackbar(context,
                                  'Your water expirience is FULL', false));
                          return;
                        } else if ((widget.craftSwitch == 1) &&
                            (fireSamuraiXp >= maxXP)) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                              buildCustomSnackbar(context,
                                  'Your fire expirience is FULL', true));
                          return;
                        }
                        if ((widget.craftSwitch == 0
                                ? waterSamuraiUnclaimedXp
                                : fireSamuraiUnclaimedXp) <=
                            0) {
                          return;
                        }
                        Rest.sendClameSamurai(widget.craftSwitch == 0
                                ? "WATER_SAMURAI_MATIC"
                                : "FIRE_SAMURAI_MATIC")
                            .then((value) {
                          if (value != null) {
                            if (value['fire_samurai_xp'] != null) {
                              fireSamuraiXp = value['fire_samurai_xp'] * 1.0;
                            }
                            if (value['fire_samurai_unclaimed_xp'] != null) {
                              fireSamuraiUnclaimedXp =
                                  value['fire_samurai_unclaimed_xp'] * 1;
                            }
                            if (value['water_samurai_xp'] != null) {
                              waterSamuraiXp = value['water_samurai_xp'] * 1.0;
                            }
                            if (value['water_samurai_unclaimed_xp'] != null) {
                              waterSamuraiUnclaimedXp =
                                  value['water_samurai_unclaimed_xp'] * 1;
                            }
                            setState(() {});
                          }
                          loadInfo();
                        }).catchError((e) {
                          if (kDebugMode) {
                            print(e);
                          }
                        });
                      },
                      disabled: isDisabledClame(),
                      shadowType: 0,
                      child: SvgPicture.asset(
                          !isDisabledClame()
                              ? 'assets/pages/homepage/craft/btn_clame_${widget.craftSwitch == 0 ? 'water' : 'fire'}.svg'
                              : 'assets/pages/homepage/craft/btn_clame_dis.svg',
                          fit: BoxFit.fitWidth,
                          width: width * 0.36)),
                  Padding(
                      padding: EdgeInsets.only(
                          top: width * 0.086, left: width * 0.215),
                      child: Text(
                          "${isDisabledClame() ? 0 : (widget.craftSwitch == 0 ? waterSamuraiUnclaimedXp : fireSamuraiUnclaimedXp)} XP",
                          style: GoogleFonts.spaceMono(
                            fontWeight: FontWeight.w700,
                            fontSize: width * 0.028,
                            color: isDisabledClame()
                                ? Colors.grey
                                : widget.craftSwitch == 0
                                    ? const Color(0xFF00FFFF)
                                    : const Color(0xFFFF0049),
                          ))),
                ]))
          ])
    ]);
  }

  Widget getStats(double width, double height, user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 50,),
        CustomPaint(
          painter: SamuraiHealBorderPainter(),
          child: Container(
            width: width * 0.746,
            padding: EdgeInsets.only(
                top: 13, right: 16, bottom: 19, left: width * 0.746 * 0.3436),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'HEAL',
                        style: GoogleFonts.spaceMono(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF00FFFF),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            "HEALTH: ",
                            style: GoogleFonts.spaceMono(
                              fontSize: width * 0.035,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF00FFFF),
                            ),
                          ),
                          Text(
                            "100%", //TODO VALUE
                            style: GoogleFonts.spaceMono(
                              fontSize: width * 0.035,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 65,
                    child: PresButton(
                        onTap: () async {
                          await GetIt.I<MusicManager>()
                              .popupSubmenuPlayer
                              .play()
                              .then((value) => GetIt.I<MusicManager>()
                                  .popupSubmenuPlayer
                                  .seek(const Duration(seconds: 0)));

                          CraftPageComponents.openHealModalPage(
                              context: context,
                              width: width,
                              height: height,
                              switchMode: widget.craftSwitch);
                        },
                        params: const {},
                        child: widget.craftSwitch == 0
                            ? waterHeartBtn
                            : fireHeartBtn),
                  ),
                ]),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        CustomPaint(
          painter: SamuraiTransferBorderPainter(),
          child: Container(
            padding: EdgeInsets.only(right: 16, left: width * 0.746 * 0.3436),
            width: width * 0.746,
            
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'TRANSFER TROOPS',
                      style: GoogleFonts.spaceMono(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF00FFFF),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "ARMY: ",
                          style: GoogleFonts.spaceMono(
                            fontWeight: FontWeight.w700,
                            fontSize: width * 0.035,
                            color: const Color(0xFF00FFFF),
                          ),
                        ),
                        Text(
                          (widget.craftSwitch == 0
                                  ? lockedWaterSamuraiBalance
                                  : lockedFireSamuraiBalance)
                              .toString(),
                          style: GoogleFonts.spaceMono(
                            fontSize: width * 0.035,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          "FREE: ",
                          style: GoogleFonts.spaceMono(
                            fontWeight: FontWeight.w700,
                            fontSize: width * 0.035,
                            color: const Color(0xFF00FFFF),
                          ),
                        ),
                        Text(
                          (widget.craftSwitch == 0
                                  ? waterSamuraiBalance
                                  : fireSamuraiBalance)
                              .toString(),
                          style: GoogleFonts.spaceMono(
                            fontWeight: FontWeight.w700,
                            fontSize: width * 0.035,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  width: 65,
                  padding: const EdgeInsets.only(top: 25, bottom: 25),
                  child: PresButton(
                    onTap: () {
                      GetIt.I<MusicManager>().popupSubmenuPlayer.play().then(
                          (value) => GetIt.I<MusicManager>()
                              .popupSubmenuPlayer
                              .seek(const Duration(seconds: 0)));
                      CraftPageComponents.openTransferModalPage(
                              elementStatus: widget.craftSwitch,
                              context: context,
                              width: width,
                              height: height,
                              samuraiTypeIngame: widget.craftSwitch == 0
                                  ? "WATER_SAMURAI_MATIC"
                                  : "FIRE_SAMURAI_MATIC",
                              balance: widget.craftSwitch == 0
                                  ? waterSamuraiBalance
                                  : fireSamuraiBalance,
                              lockedBalance: widget.craftSwitch == 0
                                  ? lockedWaterSamuraiBalance
                                  : lockedFireSamuraiBalance,
                              gas: user?['gasBnb'] ?? 0.0,
                              balanceWithdraw: (widget.craftSwitch == 0
                                      ? waterSamuraiBalance
                                      : fireSamuraiBalance)
                                  .toDouble(),
                              samuraiTypeRegular: widget.craftSwitch == 0
                                  ? "WATER_SAMURAI_BSC"
                                  : "FIRE_SAMURAI_BSC",
                              samuraiTypeGenesis: widget.craftSwitch == 0
                                  ? "WATER_SAMURAI_GENESIS_BSC"
                                  : "FIRE_SAMURAI_GENESIS_BSC",
                              samuraiGenesisBalance: widget.craftSwitch == 0
                                  ? waterSamuraiGenesisBalance
                                  : fireSamuraiGenesisBalance)
                          .then((_) => loadInfo());
                    },
                    params: const {},
                    child: widget.craftSwitch == 0
                        ? waterChangeBtn
                        : fireChangeBtn,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
            padding: EdgeInsets.only(left: width * 0.01, top: 30),
            child: clameBlock(context, width)),
      ],
    );
  }

  Widget getCharacter(double width) {
    return SizedBox(
      height: 265 / 340 * width,
      width: (138 / 312) * (265 / 340 * width),
      child: Image(
        image: widget.craftSwitch == 0 ? waterSamuraiImg : fireSamuraiImg,
        fit: BoxFit.fitHeight,
      ),
    );
  }

  Widget getBackgroundBorder(double width) {
    return Container(
      margin: EdgeInsets.only(top: 22 / 340 * width),
      width: width - width * 0.14,
      height: 243 / 340 * width,
      padding: EdgeInsets.only(
        left: 50 / 390 * width,
      ),
      child: SvgPicture.asset(
        'assets/pages/homepage/craft/border.svg',
        fit: BoxFit.fitWidth,
      ),
    );
  }

  Widget getLoader(double height, double width) {
    int xpBarPercent = getXp();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: width,
          height: 15 / 335 * (width - width * 0.14),
          child: Stack(
            children: [
              SvgPicture.asset(
                'assets/pages/homepage/craft/loader_${widget.craftSwitch == 0 ? 'water' : 'fire'}.svg',
                fit: BoxFit.fitWidth,
              ),
              SizedBox(
                width: width - width * 0.14,
                height: 16 / 335 * (width - width * 0.14),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: xpBarPercent.round(),
                      child: Container(
                        width: xpBarPercent * (width - width * 0.14) / maxXP,
                        decoration: BoxDecoration(
                          color: widget.craftSwitch == 0
                              ? const Color(0xFF00FFFF)
                              : const Color(0xFFFF0049),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                    if (maxXP - xpBarPercent > 0)
                      Spacer(flex: (maxXP - xpBarPercent).round())
                    else
                      const SizedBox.shrink()
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: width * 0.015),
          child: Row(
            children: [
              Text(
                "XP earned: ",
                style: GoogleFonts.spaceMono(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF00FFFF),
                  fontSize: 16 / 844 * height,
                ),
              ),
              Text(
                '$xpBarPercent/${maxXP.toStringAsFixed(0)}',
                style: GoogleFonts.spaceMono(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 16 / 844 * height,
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget getCraftButton(double width, double height) {
    return PresButton(
        onTap: () {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/home',
            (route) => false,
            arguments: 'heroMint${widget.craftSwitch}',
          );
        },
        disabled:
            (widget.craftSwitch == 0 ? waterSamuraiXp : fireSamuraiXp) < maxXP,
        params: {'text': 'hero mint', 'width': width, 'height': height},
        child: loginBtn);
  }

  int getXp() {
    if (widget.craftSwitch == 0) {
      if (waterSamuraiXp != 0) {
        if (waterSamuraiXp <= maxXP) {
          return ((waterSamuraiXp / maxXP) * maxXP).round();
        } else {
          return maxXP.toInt();
        }
      } else {
        return 0;
      }
    } else {
      if (fireSamuraiXp != 0) {
        if (fireSamuraiXp <= maxXP) {
          return ((fireSamuraiXp / maxXP) * maxXP).round();
        } else {
          return maxXP.toInt();
        }
      } else {
        return 0;
      }
    }
  }

  String getXpTime() {
    if (samuraiXpExpiresDate != null) {
      return samuraiXpExpiresDate!;
    }
    return '00:00';
  }

  String getDaylyXp() {
    if (widget.craftSwitch == 0) {
      if (lockedWaterSamuraiBalance > 0) {
        return (lockedWaterSamuraiBalance ~/ 5).toString();
      }
    } else {
      if (lockedFireSamuraiBalance > 0) {
        return (lockedFireSamuraiBalance ~/ 5).toString();
      }
    }
    return "0";
  }

  bool isDisabledClame() {
    if (waterSamuraiXpExpiresDate != null && fireSamuraiXpExpiresDate != null) {
      return ((widget.craftSwitch == 0
                      ? waterSamuraiUnclaimedXp
                      : fireSamuraiUnclaimedXp) <=
                  0 ||
              (widget.craftSwitch == 0
                  ? waterSamuraiXpExpiresDate!.compareTo(DateTime.now()) > 0
                  : fireSamuraiXpExpiresDate!.compareTo(DateTime.now()) > 0)
          // ||
          // (widget.craftSwitch == 0 ? waterSamuraiXp : fireSamuraiXp) >= maxXP
          );
    }
    return true;
  }
}
