import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';
import 'package:samurai_app/components/storage.dart';
import 'package:samurai_app/pages/home/craft_page_components.dart';
import 'package:samurai_app/utils/enums.dart';
import 'package:samurai_app/utils/fonts.dart';
import 'package:samurai_app/widgets/painters/painter_hero_mint_border.dart';
import 'package:samurai_app/widgets/painters/painter_xp_border.dart';
import 'package:samurai_app/widgets/popups/custom_choose_popup.dart';

import '../../api/rest.dart';
import '../../components/anim_button.dart';
import '../../components/pop_up_spinner.dart';
import '../../data/music_manager.dart';
import 'hero_page_components.dart';

class HeroMintPage extends StatefulWidget {
  const HeroMintPage({super.key, required this.craftSwitch});

  final int craftSwitch;

  @override
  State<HeroMintPage> createState() => _HeroMintPageState();
}

class _HeroMintPageState extends State<HeroMintPage> with SingleTickerProviderStateMixin {
  List _masks = [
    {'name': 'Hatamoto', 'RYO': 4000, 'CLC': 0, 'XP': 120},
    {'name': 'Daimyo', 'RYO': 20000, 'CLC': 0, 'XP': 600},
    {'name': 'Shogun', 'RYO': 140000, 'CLC': 100, 'XP': 4200},
  ];

  late Map<String, dynamic> user;

  double? fireSamuraiXp = 0;
  double? waterSamuraiXp = 0;

  void updateXp() async {
    final resp = await getSamuraiInfo();

    log(resp.toString());

    setState(() {
      fireSamuraiXp = resp['fire_samurai_xp'] * 1.0;
      waterSamuraiXp = resp['water_samurai_xp'] * 1.0;
    });

    log("$fireSamuraiXp $waterSamuraiXp");
  }

  @override
  void initState() {
    user = Map.from(AppStorage().box.get('user', defaultValue: <String, dynamic>{}));
    log("------------");
    log(user.toString());
    log("------------");

    updateXp();

    GetIt.I<MusicManager>().screenChangePlayer.play().then((value) async {
      await GetIt.I<MusicManager>().screenChangePlayer.seek(Duration(seconds: 0));
    });

    super.initState();
  }

  Future<Map<String, dynamic>> getSamuraiInfo() async {
    return await Rest.getInfoSamurai();
  }

  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PresButton(
            onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
              '/home',
              (route) => false,
              arguments: 'samurai',
            ),
            params: {'width': width},
            child: backBtn,
            player: GetIt.I<MusicManager>().keyBackSignCloseX,
          ),
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.05,
              ),
              child: Center(
                child: Text(
                  'hero mint',
                  style: AppTypography.amazObitW400White,
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
      Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
        CustomPaint(
            painter: XpBorderPainter(),
            child: Container(
                height: 47,
                width: 200,
                padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                alignment: Alignment.center,
                child: FittedBox(
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: "XP: ",
                        style: AppTypography.spaceMonoW700Red16,
                      ),
                      TextSpan(
                          text: ((widget.craftSwitch == 0 ? waterSamuraiXp : fireSamuraiXp) ?? 0.0).toStringAsFixed(0),
                          style: AppTypography.spaceMonoW700Red16.copyWith(color: Colors.white))
                    ]),
                  ),
                ))),
      ]),
      Container(
          width: width,
          height: height - height * 0.39,
          padding: EdgeInsets.only(top: width * 0.04),
          child: HeroesPageTab(wigetChild: getMintMasks(context, width, height)))
    ]);
  }

  Widget getMintMasks(BuildContext context, double width, double height) {
    final wgts = _masks.map((e) {
      return maskWidget(e, context, width, height);
    }).toList();
    return Column(
        children: wgts +
            [
              SizedBox(
                height: 50,
              )
            ]);
  }

  Widget maskWidget(e, BuildContext context, double width, double height) {
    const double widthCoef = 0.872;

    final Color _color = e['name'] == 'Hatamoto'
        ? const Color(0xFF00E417)
        : e['name'] == 'Daimyo'
            ? const Color(0xFF2589FF)
            : const Color(0xFFFF0049);

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: CustomPaint(
        painter: HeroMintBorderPainter(color: _color),
        child: Container(
            width: width * widthCoef,
            height: 110,
            child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Container(
                constraints: BoxConstraints(maxHeight: 150, maxWidth: 150),
                padding: e['name'].toString().toLowerCase() == 'hatamoto' ? EdgeInsets.only(bottom: 20) : EdgeInsets.zero,
                child: Image.asset('assets/hero_mask/${widget.craftSwitch == 0 ? 'water' : 'fire'}/${e['name'].toString().toLowerCase()}.PNG',
                    fit: BoxFit.contain, width: width * widthCoef * 0.34),
              ),
              //
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        FittedBox(
                          child: Text(
                            e['name'].toString(),
                            maxLines: 1,
                            style: AppTypography.spaceMonoBold20.copyWith(
                              color: _color,
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(children: [
                              Text('RYO: ', style: AppTypography.spaceMonoReg13White),
                              Text(e['RYO'].toString(), style: AppTypography.spaceMonoReg13White)
                            ])),
                        Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Row(children: [
                              Text('CLC: ', style: AppTypography.spaceMonoReg13White),
                              Text(e['CLC'].toString(), style: AppTypography.spaceMonoReg13White)
                            ])),
                        Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Row(children: [
                              Text('XP:  ', style: AppTypography.spaceMonoReg13White),
                              Text(e['XP'].toString(), style: AppTypography.spaceMonoReg13White)
                            ])),
                      ])),
                      //
                      Container(
                        width: width * widthCoef * 0.2,
                        height: width * widthCoef * 0.2,
                        constraints: BoxConstraints(maxHeight: 72, maxWidth: 72),
                        child: PresButton(
                            player: GetIt.I<MusicManager>().smallKeyWeaponPlayer,
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => CustomChoosePopup(
                                      acceptFunction: () async {
                                        String heroType = e['name'].toString().toUpperCase();

                                        showSpinner(context);

                                        await Rest.mintUserHero(
                                          widget.craftSwitch == 0 ? SamuraiType.WATER : SamuraiType.FIRE,
                                          heroType,
                                        );

                                        updateXp();

                                        if (context.mounted) {
                                          hideSpinner(context);
                                        }

                                        Navigator.pop(context);
                                      },
                                      canselFunction: () {
                                        Navigator.pop(context);
                                      },
                                      text: "Do you really want to make a hero?"));
                            },
                            disabled: ((widget.craftSwitch == 0 ? waterSamuraiXp : fireSamuraiXp) ?? 0.0) < e['XP'] || user['ryo_balance'] < 4000,
                            params: {'width': width},
                            child: mintBtn),
                      )
                    ],
                  ),
                ),
              )
            ])),
      ),
    );
  }
}
