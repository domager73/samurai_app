import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:samurai_app/components/blinking_time.dart';

import '../../api/rest.dart';
import '../../components/anim_button.dart';
import 'hero_page_components.dart';

class HerosPage extends StatefulWidget {
  const HerosPage({super.key, required this.craftSwitch});

  final int craftSwitch;

  @override
  State<HerosPage> createState() => _HerosPageState();
}

class _HerosPageState extends State<HerosPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  late Map<String, dynamic> info;
  double? waterSamuraiDp = 0;
  double? fireSamuraiDp = 0;
  int? fireSamuraiUnclaimedDp = 0;
  int? waterSamuraiUnclaimedDp = 0;
  double maxDp = 100.0;

  String? samuraiDpExpiresDate;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    loadInfo();

    calcSamuraiDpExpiresDate();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (!mounted) {
        timer.cancel();
      }
      calcSamuraiDpExpiresDate();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _timer.cancel();
  }

  void calcSamuraiDpExpiresDate() {
    final now = DateTime.now();
    DateTime end = DateTime(now.year, now.month, now.day, 12, 59, 59);
    final diff = now.subtract(now.timeZoneOffset).difference(end);
    //print("$diff, ${diff.inHours}, ${diff.inMinutes}");
    setState(() {
      samuraiDpExpiresDate = DateFormat.Hm().format(DateTime(
          now.year,
          now.month,
          now.day,
          -diff.inHours,
          -diff.inMinutes + diff.inHours * 60));
    });
  }

  Future<void> loadInfo() async {
    await getHeroInfo()
        .then((value) => setState(() {
              info = value;
              waterSamuraiDp = info['water_dp_bar'] * 1.0;
              fireSamuraiDp = info['fire_dp_bar'] * 1.0;
              fireSamuraiUnclaimedDp = info['fire_dp_balance'] * 1;
              waterSamuraiUnclaimedDp = info['water_dp_balance'] * 1;
              maxDp = 120;
            }))
        .catchError((e) {
      print(e);
    });
  }

  Future<Map<String, dynamic>> getHeroInfo() async {
    return await Rest.getInfoHero();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Column(children: [
      Padding(
          padding: EdgeInsets.only(
              top: width * 0.04,
              bottom: width * 0.07,
              left: width * 0.12,
              right: width * 0.12),
          child: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'ACTIVE'),
              Tab(text: 'STAKING'),
              Tab(text: 'MINT'),
            ],
            labelStyle: GoogleFonts.spaceMono(
                fontSize: 14 / 880 * height, fontWeight: FontWeight.w700),
            labelColor: Colors.white,
            unselectedLabelColor: const Color(0xFF00FFFF),
            indicatorColor: Colors.white,
            dividerColor: const Color(0xFF00FFFF),
            splashBorderRadius: BorderRadius.circular(8),
          )),
      SizedBox(
          width: width - width * 0.04,
          height: height - height * 0.433,
          child: TabBarView(controller: _tabController, children: [
            FutureBuilder(
              future: getHeroInfo(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  print(snapshot.data);
                  return HerosPageTab(
                      wigetChild: getActiveTab(
                          context, width, height, snapshot.data['heroes']));
                }

                return Container();
              },
            ),
            FutureBuilder(
              future: getHeroInfo(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  return HerosPageTab(
                      wigetChild: getStakingTab(
                          context, width, height, snapshot.data['heroes']));
                }

                return Container();
              },
            ),
            FutureBuilder(
              future: getHeroInfo(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  return getMintTab(context, width, height);
                }

                return Container();
              },
            ),
          ]))
    ]);
  }

  Widget getActiveTab(
      BuildContext context, double width, double height, List<dynamic> heroes) {
    final wgts = heroes.map((e) {
      print(e['clan']);
      print('--------------------------------------');
      return e['status'] != 'STAKING' &&
              ((widget.craftSwitch == 0 && e['clan'] == 'water') ||
                  (widget.craftSwitch == 1 && e['clan'] == 'fire'))
          ? Container(
              padding: EdgeInsets.only(
                  bottom: width * 0.04,
                  left: width * 0.05,
                  right: width * 0.04),
              width: width,
              child: heroBlock(e, context, width, height, btnsActive))
          : const SizedBox();
    }).toList();

    return Column(children: [
      ...wgts,
      SizedBox(
        height: height * 0.02,
      )
    ]);
  }

  Widget getStakingTab(
      BuildContext context, double width, double height, List<dynamic> heroes) {
    final wgts = heroes.map((e) {
      return e['status'] == "STAKING" &&
              ((widget.craftSwitch == 0 && e['clan'] == 'water') ||
                  (widget.craftSwitch == 1 && e['clan'] == 'fire'))
          ? Container(
              padding: EdgeInsets.only(
                  bottom: width * 0.04,
                  left: width * 0.05,
                  right: width * 0.04),
              width: width,
              child: heroBlock(e, context, width, height, btnsStack))
          : const SizedBox();
    }).toList();

    return Column(children: [
      ...wgts,
      SizedBox(
        height: height * 0.02,
      )
    ]);
  }

  Widget getMintTab(BuildContext context, double width, double height) {
    return Column(children: [
      clameBlock(context, width),
      Padding(
          padding: EdgeInsets.only(
              top: width * 0.04, left: width * 0.05, right: width * 0.04),
          child: progressBar(context, maxDp, width)),
      Padding(
        padding: EdgeInsets.only(top: width * 0.06),
        child: PresButton(
          onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
            '/home',
            (route) => false,
            arguments: 'samuraiMint${widget.craftSwitch}',
          ),
          disabled:
              ((widget.craftSwitch == 0 ? waterSamuraiDp : fireSamuraiDp) ??
                      0.0) <
                  12,
          params: {'text': 'samuari mint', 'width': width, 'height': height},
          child: loginBtn,
        ),
      ),
    ]);
  }

  Widget heroBlock(
      Map e, BuildContext context, double width, double height, btnsWaiget) {
    //print(e);
    return Stack(children: [
      // if (e['in_battle'] == true) //TODO доделать in_battle
      //   Container(
      //       padding: EdgeInsets.only(top: width * 0.005),
      //       width: width - width * 0.68,
      //       child: SvgPicture.asset(
      //           'assets/pages/homepage/heroes/in_battle.svg',
      //           fit: BoxFit.fitWidth)),
      SvgPicture.asset(
        'assets/pages/homepage/heroes/ronin_border.svg',
        fit: BoxFit.fitWidth,
        width: width * 0.88,
      ),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
            padding: EdgeInsets.only(top: width * 0.075, left: width * 0.015),
            child: Image.asset(
                'assets/pages/homepage/heroes/muzhikotavr_hero.png',
                width: width * 0.26)),
        Padding(
            padding: EdgeInsets.only(top: width * 0.08, left: width * 0.04),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                e['type'].toString(),
                style: GoogleFonts.spaceMono(
                  fontSize: width * 0.04,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: width * 0.02),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        e['type'].toString(),
                        style: GoogleFonts.spaceMono(
                          fontSize: width * 0.04,
                          fontWeight: FontWeight.w700,
                          color: e['type'] == 'Feudal'
                              ? const Color(0xFF2589FF)
                              : e['type'] == 'Shogun'
                                  ? const Color(0xFFFF0049)
                                  : const Color(0xFF00E417),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: width * 0.02),
                        child: SvgPicture.asset(
                          'assets/pages/homepage/samurai/${e['clan']}_icon.svg',
                          width: width * 0.04,
                        ),
                      ),
                    ],
                  )),
              Padding(
                  padding: EdgeInsets.only(top: width * 0.03),
                  child: SvgPicture.asset(
                    e['chronicle']
                        ? 'assets/pages/homepage/heroes/in_chronicles.svg'
                        : 'assets/pages/homepage/heroes/unknown.svg',
                  )),
            ])),
        btnsWaiget(e, context, width, height, e['id'])
      ])
    ]);
  }

  Widget btnsActive(Map e, BuildContext context, double width, double height) {
    return Padding(
        padding: EdgeInsets.only(left: width - width * 0.9),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: EdgeInsets.only(top: width * 0.03, bottom: width * 0.03),
              child: AnimButton(
                  onTap: () => {},
                  shadowType: 2,
                  child: SvgPicture.asset(
                    'assets/pages/homepage/heroes/btn_to_wallet.svg',
                    fit: BoxFit.fitWidth,
                  ))),
          AnimButton(
              onTap: () => {},
              shadowType: 2,
              child: SvgPicture.asset(
                'assets/pages/homepage/heroes/btn_stake.svg',
                fit: BoxFit.fitWidth,
              ))
        ]));
  }

  Widget btnsStack(
      Map e, BuildContext context, double width, double height, int heroId) {
    return Padding(
        padding: EdgeInsets.only(left: width - width * 0.9),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: EdgeInsets.only(top: width * 0.12),
              child: AnimButton(
                  onTap: () => {},
                  shadowType: 2,
                  child: SvgPicture.asset(
                    'assets/pages/homepage/heroes/btn_unstake.svg',
                    fit: BoxFit.fitWidth,
                  )))
        ]));
  }

  Widget clameBlock(BuildContext context, double width) {
    return Stack(children: [
      Padding(
          padding: EdgeInsets.only(
              top: width * 0.02, left: width * 0.054, right: width * 0.044),
          child: SvgPicture.asset(
            'assets/pages/homepage/craft/clame_border.svg',
            fit: BoxFit.fitWidth,
            width: width - width * 0.09,
          )),
      Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
                padding:
                    EdgeInsets.only(top: width * 0.047, left: width * 0.11),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: width * 0.055, left: width * 0.13),
                        child: BlinkingTime(
                          getTime: () => samuraiDpExpiresDate ?? '00:00',
                          style: GoogleFonts.spaceMono(
                            fontSize: width * 0.04,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFFFFFFF),
                          ),
                        ),

                        // Text(
                        //   samuraiDpExpiresDate ?? '00:00',
                        //   style: GoogleFonts.spaceMono(
                        //     fontSize: width * 0.04,
                        //     fontWeight: FontWeight.w700,
                        //     color: const Color(0xFFFFFFFF),
                        //   ),
                        // ),
                      ),
                      Row(children: [
                        Text("DP/Day: ",
                            style: GoogleFonts.spaceMono(
                              fontSize: width * 0.034,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF00FFFF),
                            )),
                        Text("+${getDaylyDp()} DP ",
                            style: GoogleFonts.spaceMono(
                              fontSize: width * 0.034,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFFFFFFF),
                            ))
                      ])
                    ])),
            Padding(
                padding: EdgeInsets.only(
                    top: width * 0.087, right: width - width * 0.9),
                child: Stack(children: [
                  AnimButton(
                    onTap: () {
                      Rest.sendClameHero(widget.craftSwitch == 0
                              ? "WATER_HERO_MATIC"
                              : "FIRE_HERO_MATIC")
                          .then((value) {
                        loadInfo();
                      }).catchError((_) {});
                    },
                    shadowType: 1,
                    child: SvgPicture.asset(
                        (((widget.craftSwitch == 0
                                        ? waterSamuraiUnclaimedDp
                                        : fireSamuraiUnclaimedDp) ??
                                    0) >
                                0)
                            ? 'assets/pages/homepage/craft/btn_clame_water.svg'
                            : 'assets/pages/homepage/craft/btn_clame_dis.svg',
                        fit: BoxFit.fitWidth,
                        width: width * 0.36),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          top: width * 0.086, left: width * 0.23),
                      child: Text(
                          "${(widget.craftSwitch == 0 ? waterSamuraiUnclaimedDp : fireSamuraiUnclaimedDp) ?? 0} DP",
                          style: GoogleFonts.spaceMono(
                            fontWeight: FontWeight.w700,
                            fontSize: width * 0.028,
                            color: (((widget.craftSwitch == 0
                                            ? waterSamuraiUnclaimedDp
                                            : fireSamuraiUnclaimedDp) ??
                                        0) >
                                    0)
                                ? const Color(0xFF00FFFF)
                                : Colors.grey,
                          ))),
                ]))
          ])
    ]);
  }

  Widget progressBar(BuildContext context, double maxDp, double width) {
    double xp =
        (widget.craftSwitch == 0 ? waterSamuraiDp : fireSamuraiDp) ?? 0.0;
    if (xp > maxDp) {
      xp = maxDp;
    }
    return Column(children: [
      Stack(children: [
        SvgPicture.asset(
          'assets/pages/homepage/heroes/progress.svg',
          fit: BoxFit.fitWidth,
          width: width - width * 0.09,
        ),
        Container(
          margin: EdgeInsets.only(top: width * 0.002),
          width: (width - width * 0.09) * (xp + 1) / (maxDp * 1.12),
          height: width * 0.041,
          decoration: BoxDecoration(
            color: widget.craftSwitch == 0
                ? const Color(0xFF00FFFF)
                : const Color(0xFFFF0049),
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        // Padding(
        //     padding: EdgeInsets.only(
        //         top: width * 0.006,
        //         left: (width - width * 0.09) * (xp + 1) / (maxDp * 1.12) +
        //             width * 0.01),
        //     child: Text("DP",
        //         style: GoogleFonts.spaceMono(
        //           fontWeight: FontWeight.w700,
        //           fontSize: width * 0.024,
        //           color: Colors.white,
        //         )))
      ]),
      Padding(
          padding: EdgeInsets.only(top: width * 0.02),
          child: Row(children: [
            Text("DP earned: ",
                style: GoogleFonts.spaceMono(
                  fontSize: width * 0.038,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF00FFFF),
                )),
            Text(
                '${((widget.craftSwitch == 0 ? waterSamuraiDp : fireSamuraiDp) ?? 0.0).toStringAsFixed(0)}/100',
                style: GoogleFonts.spaceMono(
                  fontSize: width * 0.038,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ))
          ]))
    ]);
  }

  String getDaylyDp() {
    /*if (widget.craftSwitch == 0) {
      if (lockedWaterSamuraiBalance != null) {
        return (lockedWaterSamuraiBalance! ~/ 5).toString();
      }
    } else {
      if (lockedFireSamuraiBalance != null) {
        return (lockedFireSamuraiBalance! ~/ 5).toString();
      }
    }*/
    return "0";
  }
}
