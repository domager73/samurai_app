import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:samurai_app/components/blinking_time.dart';
import 'package:samurai_app/data/music_manager.dart';

import '../../api/rest.dart';
import '../../api/wallet.dart';
import '../../components/anim_button.dart';
import '../../components/pop_up_spinner.dart';
import '../../components/show_error.dart';
import '../../components/storage.dart';
import '../../models/dp.dart';
import '../../utils/enums.dart';
import '../../widgets/custom_snackbar.dart';
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
  int page = 0;

  late Map<String, dynamic> info;
  Dp? water;
  Dp? fire;

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

  Future<bool> loadInfo() async {
    await getHeroInfo().then((value) {
      info = value;

      water = Dp.fromJson(json: info['water']);
      fire = Dp.fromJson(json: info['fire']);
    }).catchError((e) {
      print(e);
    });

    return true;
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
            onTap: (newPage) async {
              if (page < newPage) {
                await GetIt.I<MusicManager>()
                    .swipeForwPlayer
                    .play()
                    .then((value) async {
                  await GetIt.I<MusicManager>()
                      .swipeForwPlayer
                      .seek(Duration(seconds: 0));
                });
              } else {
                await GetIt.I<MusicManager>()
                    .swipeBackPlayer
                    .play()
                    .then((value) async {
                  await GetIt.I<MusicManager>()
                      .swipeBackPlayer
                      .seek(Duration(seconds: 0));
                });
              }

              setState(() {
                page = newPage;
              });
            },
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
          child: FutureBuilder(
              future: loadInfo(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return TabBarView(controller: _tabController, children: [
                    HerosPageTab(
                        wigetChild: getActiveTab(
                            context, width, height, info['heroes'])),
                    HerosPageTab(
                        wigetChild: getStakingTab(
                            context, width, height, info['heroes'])),
                    getMintTab(context, width, height)
                  ]);
                }

                return Container();
              }))
    ]);
  }

  Widget getActiveTab(
      BuildContext context, double width, double height, List<dynamic> heroes) {
    final wgts = heroes.map((e) {
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
          child: progressBar(context,
              widget.craftSwitch == 0 ? water!.bar : fire!.bar, width)),
      Padding(
        padding: EdgeInsets.only(top: width * 0.06),
        child: PresButton(
          onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
            '/home',
            (route) => false,
            arguments: 'samuraiMint${widget.craftSwitch}',
          ),
          disabled:
              (widget.craftSwitch == 0 ? water!.balance : fire!.balance) < 12,
          params: {'text': 'samuari mint', 'width': width, 'height': height},
          child: loginBtn,
        ),
      ),
    ]);
  }

  Widget heroBlock(
      Map e, BuildContext context, double width, double height, btnsWaiget) {
    return Stack(children: [
      if (e['status'] == 'FIGHTING')
        Container(
            padding: EdgeInsets.only(top: width * 0.005),
            width: width - width * 0.68,
            child: SvgPicture.asset(
                'assets/pages/homepage/heroes/in_battle.svg',
                fit: BoxFit.fitWidth)),
      SvgPicture.asset(
        'assets/pages/homepage/heroes/${e['type']}_border.svg',
        fit: BoxFit.fitWidth,
        width: width * 0.88,
      ),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
            padding: EdgeInsets.only(top: width * 0.075, left: width * 0.015),
            child: Image.network(e['image'],
                fit: BoxFit.fitHeight, width: width * 0.26)),
        Padding(
            padding: EdgeInsets.only(top: width * 0.08, left: width * 0.04),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                width: width * 0.28,
                child: Text(
                  e['name'].toString(),
                  style: GoogleFonts.spaceMono(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  softWrap: true,
                  maxLines: 2,
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

  Future<void> transferSamurai(int heroId) async {
    try {
      showSpinner(context);
      await Rest.transfer(
        WalletAPI.chainIdBnb,
        heroId.toDouble(),
        widget.craftSwitch == 0 ? 'WATER_HERO_BSC' : 'FIRE_HERO_BSC',
        AppStorage().read('wallet_adress') as String,
      );
      if (context.mounted) {
        hideSpinner(context);
      }
    } catch (e) {
      hideSpinner(context);
      await showError(context,
          'Insufficient funds. Deposit some BNB to your crypto wallet.');
    }
  }

  Widget btnsActive(Map<String, dynamic> e, BuildContext context, double width,
      double height, int heroId) {
    return Padding(
        padding: EdgeInsets.only(left: width - width * 0.9),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: EdgeInsets.only(top: width * 0.03, bottom: width * 0.03),
              child: AnimButton(
                  onTap: () async {
                    await transferSamurai(heroId);
                    await loadInfo().then((value) => setState(() {}));
                  },
                  shadowType: 2,
                  child: SvgPicture.asset(
                    e['status'] == 'FIGHTING'
                        ? 'assets/pages/homepage/heroes/btn_to_wallet_dis.svg'
                        : 'assets/pages/homepage/heroes/btn_to_wallet.svg',
                    fit: BoxFit.fitWidth,
                  ))),
          AnimButton(
              onTap: () async {
                await Rest.placeHeroToStake(heroId);
                await loadInfo().then((value) => setState(() {}));
              },
              shadowType: 2,
              child: SvgPicture.asset(
                e['status'] == 'FIGHTING'
                    ? 'assets/pages/homepage/heroes/btn_stake_dis.svg'
                    : 'assets/pages/homepage/heroes/btn_stake.svg',
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
                  onTap: () async {
                    await Rest.removeHeroFromStake(heroId);
                    await loadInfo().then((value) => setState(() {}));
                  },
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
                      ),
                      Row(children: [
                        Text("DP/Day: ",
                            style: GoogleFonts.spaceMono(
                              fontSize: width * 0.034,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF00FFFF),
                            )),
                        Text(
                            "+${widget.craftSwitch == 0 ? water!.perDay : fire!.perDay} DP ",
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
                    player: GetIt.I<MusicManager>().zeroAmountNumberPlayer,
                    onTap: () {
                      ScaffoldMessenger.of(context).clearSnackBars();

                      if (water!.balance >= water!.bar &&
                          widget.craftSwitch == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            buildCustomSnackbar(
                                context, 'Your water dp is FULL', false));

                        return;
                      }

                      if (fire!.balance >= fire!.bar &&
                          widget.craftSwitch == 1) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            buildCustomSnackbar(
                                context, 'Your fiure dp is FULL', false));

                        return;
                      }

                      Rest.sendClameHero(
                              widget.craftSwitch == 0 ? 'water' : 'fire')
                          .then((value) {
                        loadInfo().then((value) => setState(() {}));
                      }).catchError((_) {});
                    },
                    disabled: !((widget.craftSwitch == 0
                            ? water!.unclaimed
                            : fire!.unclaimed) >
                        0),
                    shadowType: 1,
                    child: SvgPicture.asset(
                        ((widget.craftSwitch == 0
                                    ? water!.unclaimed
                                    : fire!.unclaimed) >
                                0)
                            ? widget.craftSwitch == 0
                                ? 'assets/pages/homepage/craft/btn_clame_water.svg'
                                : 'assets/pages/homepage/craft/btn_clame_fire.svg'
                            : 'assets/pages/homepage/craft/btn_clame_dis.svg',
                        fit: BoxFit.fitWidth,
                        width: width * 0.36),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          top: width * 0.086, left: width * 0.23),
                      child: Text(
                          "${(widget.craftSwitch == 0 ? water!.unclaimed : fire!.unclaimed) ?? 0} DP",
                          style: GoogleFonts.spaceMono(
                            fontWeight: FontWeight.w700,
                            fontSize: width * 0.028,
                            color: ((widget.craftSwitch == 0
                                        ? water!.unclaimed
                                        : fire!.unclaimed) >
                                    0)
                                ? const Color(0xFF00FFFF)
                                : Colors.grey,
                          ))),
                ]))
          ])
    ]);
  }

  Widget progressBar(BuildContext context, int maxDp, double width) {
    int balance = widget.craftSwitch == 0 ? water!.balance : fire!.balance;

    if (balance > maxDp) {
      balance = maxDp;
    }

    return Column(children: [
      Stack(children: [
        SvgPicture.asset(
          'assets/pages/homepage/heroes/progress.svg',
          fit: BoxFit.fitWidth,
          width: width * 0.91,
        ),
        Container(
          margin: EdgeInsets.only(top: width * 0.002),
          width: (width * 0.91) * balance / maxDp,
          height: width * 0.041,
          decoration: BoxDecoration(
            color: widget.craftSwitch == 0
                ? const Color(0xFF00FFFF)
                : const Color(0xFFFF0049),
            borderRadius: BorderRadius.circular(100),
          ),
        ),
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
                '${(widget.craftSwitch == 0 ? water!.balance : fire!.balance).toStringAsFixed(0)}/${maxDp.round()}',
                style: GoogleFonts.spaceMono(
                  fontSize: width * 0.038,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ))
          ]))
    ]);
  }
}
