import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';
import 'package:samurai_app/components/show_confirm.dart';
import 'package:samurai_app/components/storage.dart';
import 'package:samurai_app/pages/home/craft_page_components.dart';
import 'package:samurai_app/utils/enums.dart';

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

class _HeroMintPageState extends State<HeroMintPage>
    with SingleTickerProviderStateMixin {
  List _masks = [
    {'name': 'Hatamoto', 'RYO': 4000, 'CLC': 0, 'XP': 120},
    {'name': 'Daimyo', 'RYO': 20000, 'CLC': 0, 'XP': 600},
    {'name': 'Shogun', 'RYO': 140000, 'CLC': 100, 'XP': 4200},
  ];

  late Map<String, dynamic> user;

  double? fireSamuraiXp = 0;
  double? waterSamuraiXp = 0;

  void updateXp() {
    getSamuraiInfo().then((value) => setState(() {
          fireSamuraiXp = value['fire_samurai_xp'] * 1.0;
          waterSamuraiXp = value['water_samurai_xp'] * 1.0;
        }));
  }

  @override
  void initState() {
    super.initState();

    user = Map.from(
        AppStorage().box.get('user', defaultValue: <String, dynamic>{}));

    updateXp();
  }

  Future<Map<String, dynamic>> getSamuraiInfo() async {
    return await Rest.getInfoSamurai();
  }

  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
          SizedBox(
            height: width * 0.12,
            width: width * 0.12,
          ),
        ],
      ),
      Align(
          alignment: Alignment.center,
          child: SizedBox(
              width: width - width * 0.6,
              child: Stack(children: [
                Padding(
                    padding: EdgeInsets.only(top: width * 0.012),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('XP: ',
                              style: GoogleFonts.spaceMono(
                                fontWeight: FontWeight.w700,
                                fontSize: width * 0.03,
                                color: widget.craftSwitch == 0
                                    ? const Color(0xFF00FFFF)
                                    : const Color(0xFFFF0049),
                              )),
                          Text(
                              ((widget.craftSwitch == 0
                                          ? waterSamuraiXp
                                          : fireSamuraiXp) ??
                                      0.0)
                                  .toStringAsFixed(0),
                              style: GoogleFonts.spaceMono(
                                fontWeight: FontWeight.w700,
                                fontSize: width * 0.03,
                                color: Colors.white,
                              )),
                        ])),
                SvgPicture.asset(
                  'assets/pages/homepage/mint/dp_border.svg',
                  fit: BoxFit.fitWidth,
                  width: width - width * 0.6,
                )
              ]))),
      Container(
          width: width,
          height: height - height * 0.39,
          padding: EdgeInsets.only(top: width * 0.04),
          child: HerosPageTab(wigetChild: getMintMasks(context, width, height)))
    ]);
  }

  Widget getMintMasks(BuildContext context, double width, double height) {
    final wgts = _masks.map((e) {
      return Padding(
          padding: EdgeInsets.only(
              bottom: width * 0.04, left: width * 0.05, right: width * 0.04),
          child: maskWidget(e, context, width, height));
    }).toList();
    return Column(children: [
      ...wgts,
      SizedBox(
        height: height * 0.02,
      )
    ]);
  }

  Widget maskWidget(e, BuildContext context, double width, double height) {
    return Stack(children: [
      Padding(
          padding: EdgeInsets.only(top: width * 0.02),
          child: SvgPicture.asset(
            'assets/pages/homepage/mint/${e['name'].toString().toLowerCase()}_border.svg',
            fit: BoxFit.fitWidth,
            width: width - width * 0.12,
          )),
      SizedBox(
          width: width - width * 0.25,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                    'assets/pages/homepage/mint/${e['name'].toString().toLowerCase()}_mask_${widget.craftSwitch == 0 ? 'water' : 'fire'}.png',
                    fit: BoxFit.contain,
                    width: width * 0.3),
                Container(
                    width: width * 0.3,
                    padding: EdgeInsets.only(top: width * 0.035),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e['name'].toString(),
                            maxLines: 1,
                            style: GoogleFonts.spaceMono(
                              fontSize: width * 0.045,
                              fontWeight: FontWeight.w700,
                              color: e['name'] == 'Hatamoto'
                                  ? const Color(0xFF00E417)
                                  : e['name'] == 'Daimyo'
                                      ? const Color(0xFF2589FF)
                                      : const Color(0xFFFF0049),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: width * 0.01),
                              child: Row(children: [
                                Text('RYO: ',
                                    style: GoogleFonts.spaceMono(
                                      fontWeight: FontWeight.w400,
                                      fontSize: width * 0.026,
                                      color: Colors.white,
                                    )),
                                Text(e['RYO'].toString(),
                                    style: GoogleFonts.spaceMono(
                                      fontWeight: FontWeight.w400,
                                      fontSize: width * 0.026,
                                      color: Colors.white,
                                    ))
                              ])),
                          Padding(
                              padding: EdgeInsets.only(top: width * 0.01),
                              child: Row(children: [
                                Text('CLC: ',
                                    style: GoogleFonts.spaceMono(
                                      fontWeight: FontWeight.w400,
                                      fontSize: width * 0.026,
                                      color: Colors.white,
                                    )),
                                Text(e['CLC'].toString(),
                                    style: GoogleFonts.spaceMono(
                                      fontWeight: FontWeight.w400,
                                      fontSize: width * 0.026,
                                      color: Colors.white,
                                    ))
                              ])),
                          Padding(
                              padding: EdgeInsets.only(top: width * 0.01),
                              child: Row(children: [
                                Text('XP:  ',
                                    style: GoogleFonts.spaceMono(
                                      fontWeight: FontWeight.w400,
                                      fontSize: width * 0.026,
                                      color: Colors.white,
                                    )),
                                Text(e['XP'].toString(),
                                    style: GoogleFonts.spaceMono(
                                      fontWeight: FontWeight.w400,
                                      fontSize: width * 0.026,
                                      color: Colors.white,
                                    ))
                              ])),
                        ])),
                Padding(
                    padding: EdgeInsets.only(top: width * 0.06),
                    child: PresButton(
                        player: GetIt.I<MusicManager>().smallKeyWeaponPlayer,
                        onTap: () {
                          showConfirm(
                              context, 'Do you really want to make a hero?',
                              () async {
                            String heroType =
                                e['name'].toString().toUpperCase();

                            showSpinner(context);

                            await Rest.mintUserHero(
                              widget.craftSwitch == 0
                                  ? SamuraiType.WATER
                                  : SamuraiType.FIRE,
                              heroType,
                            );

                            updateXp();

                            if (context.mounted) {
                              hideSpinner(context);
                            }

                            Navigator.pop(context);
                          });
                        },
                        disabled: ((widget.craftSwitch == 0
                                        ? waterSamuraiXp
                                        : fireSamuraiXp) ??
                                    0.0) <
                                e['XP'] &&
                            user['ryo'] < 4000,
                        params: {'width': width},
                        child: mintBtn))
              ]))
    ]);
  }
}
