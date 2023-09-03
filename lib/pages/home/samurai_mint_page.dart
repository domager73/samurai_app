import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samurai_app/components/pop_up_spinner.dart';
import 'package:samurai_app/utils/fonts.dart';
import 'package:samurai_app/widgets/popups/custom_choose_popup.dart';

import '../../api/rest.dart';
import '../../components/anim_button.dart';
import '../../data/music_manager.dart';

class SamuraiMintPage extends StatefulWidget {
  const SamuraiMintPage({super.key, required this.craftSwitch});

  final int craftSwitch;

  @override
  State<SamuraiMintPage> createState() => _SamuraiMintPageState();
}

class _SamuraiMintPageState extends State<SamuraiMintPage> with SingleTickerProviderStateMixin {
  double _currentSliderValue = 0;

  late final ImageProvider samuraiWater;
  late final ImageProvider samuraiFire;

  int fireSamuraiDp = 0;
  int waterSamuraiDp = 0;

  final int priceRyo = 800;
  final int priceDp = 12;

  @override
  void initState() {
    super.initState();
    samuraiWater = const AssetImage('assets/pages/homepage/mint/samurai_water.png');
    samuraiFire = const AssetImage('assets/pages/homepage/mint/samurai_fire.png');

    getHeroInfo().then((value) => setState(() {
          fireSamuraiDp = value['fire']['balance'];
          waterSamuraiDp = value['water']['balance'];
        }));

    GetIt.I<MusicManager>().screenChangePlayer.play().then((value) async {
      await GetIt.I<MusicManager>().screenChangePlayer.seek(Duration(seconds: 0));
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<Map<String, dynamic>> getHeroInfo() async {
    return await Rest.getInfoHero();
  }

  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    precacheImage(samuraiWater, context);
    precacheImage(samuraiFire, context);

    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            PresButton(
              onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                '/home',
                (route) => false,
                arguments: 'heros',
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
                  child: FittedBox(
                      child: Text(
                    'samurai mint',
                    style: AppTypography.amazObitW400White.copyWith(fontSize: 40),
                    maxLines: 1,
                  )),
                ),
              ),
            ),
          ],
        ),
        Align(
            alignment: Alignment.center,
            child: SizedBox(
                width: width - width * 0.55,
                child: Stack(children: [
                  Padding(
                      padding: EdgeInsets.only(top: width * 0.014),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text('DP: ',
                            style: GoogleFonts.spaceMono(
                              fontWeight: FontWeight.w700,
                              fontSize: width * 0.03,
                              color: widget.craftSwitch == 0 ? const Color(0xFF00FFFF) : const Color(0xFFFF0049),
                            )),
                        Text(((widget.craftSwitch == 0 ? waterSamuraiDp : fireSamuraiDp) ?? 0.0).toStringAsFixed(0),
                            style: GoogleFonts.spaceMono(
                              fontWeight: FontWeight.w700,
                              fontSize: width * 0.03,
                              color: Colors.white,
                            )),
                      ])),
                  SvgPicture.asset(
                    'assets/pages/homepage/mint/dp_border.svg',
                    fit: BoxFit.fitWidth,
                    width: width - width * 0.55,
                  )
                ]))),
        Center(child: Container(width: width * 0.45, alignment: Alignment.center, padding: EdgeInsets.only(top: width * 0.04), child: Image(image: widget.craftSwitch == 0 ? samuraiWater : samuraiFire, fit: BoxFit.fitWidth))),
        Container(
            padding: EdgeInsets.only(top: width * 0.014),
            width: width - width * 0.04,
            child: Stack(children: [
              Padding(
                  padding: EdgeInsets.only(top: width * 0.014, left: width * 0.05),
                  child: SvgPicture.asset(
                    'assets/pages/homepage/mint/mint_border.svg',
                    fit: BoxFit.fitWidth,
                    width: width - width * 0.16,
                  )),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(
                    padding: EdgeInsets.only(top: width * 0.08, left: width * 0.1, right: width * 0.1),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(widget.craftSwitch == 0 ? 'Water' : 'Fire',
                            style: GoogleFonts.spaceMono(
                              fontWeight: FontWeight.w700,
                              fontSize: width * 0.05,
                              color: widget.craftSwitch == 0 ? const Color(0xFF00FFFF) : const Color(0xFFFF0049),
                            )),
                        Text('Samurai',
                            style: GoogleFonts.spaceMono(
                              fontWeight: FontWeight.w700,
                              fontSize: width * 0.05,
                              color: widget.craftSwitch == 0 ? const Color(0xFF00FFFF) : const Color(0xFFFF0049),
                            )),
                      ]),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Text('RYO: ',
                              style: GoogleFonts.spaceMono(
                                fontWeight: FontWeight.w400,
                                fontSize: width * 0.033,
                                color: Colors.white,
                              )),
                          Text((priceRyo * _currentSliderValue).toStringAsFixed(0),
                              style: GoogleFonts.spaceMono(
                                fontWeight: FontWeight.w400,
                                fontSize: width * 0.033,
                                color: Colors.white,
                              ))
                        ]),
                        Row(children: [
                          Text('CLC: ',
                              style: GoogleFonts.spaceMono(
                                fontWeight: FontWeight.w400,
                                fontSize: width * 0.033,
                                color: Colors.white,
                              )),
                          Text('0',
                              style: GoogleFonts.spaceMono(
                                fontWeight: FontWeight.w400,
                                fontSize: width * 0.033,
                                color: Colors.white,
                              ))
                        ]),
                        Row(children: [
                          Text('DP:  ',
                              style: GoogleFonts.spaceMono(
                                fontWeight: FontWeight.w400,
                                fontSize: width * 0.033,
                                color: Colors.white,
                              )),
                          Text((priceDp * _currentSliderValue).toStringAsFixed(0),
                              style: GoogleFonts.spaceMono(
                                fontWeight: FontWeight.w400,
                                fontSize: width * 0.033,
                                color: Colors.white,
                              ))
                        ]),
                      ]),
                      Padding(
                          padding: EdgeInsets.only(left: width * 0.01, top: width * 0.01),
                          child: PresButton(
                              disabled: _currentSliderValue <= 0,
                              onTap: () {
                                if (_currentSliderValue <= 0) {
                                  return;
                                }
                                showDialog(
                                    context: context,
                                    builder: (context) => CustomChoosePopup(
                                        acceptFunction: () async {
                                          showSpinner(context);

                                          await Rest.sendMintSamurai(_currentSliderValue.toInt(), widget.craftSwitch == 0 ? "WATER_SAMURAI_BSC" : "FIRE_SAMURAI_BSC", useDpMint: true);

                                          hideSpinner(context);
                                          Navigator.pop(context);

                                          setState(() {});
                                        },
                                        canselFunction: () {
                                          Navigator.pop(context);
                                        },
                                        text: "Do you really want to mint Samurai?"));
                              },
                              params: {'width': width},
                              child: mintBtn2))
                    ])),
                Padding(
                    padding: EdgeInsets.only(top: width * 0.02, left: width * 0.065, right: width * 0.06),
                    child: FlutterSlider(
                      values: [_currentSliderValue],
                      max: calcMax(),
                      min: 0,
                      handler: FlutterSliderHandler(child: const SizedBox(height: 1.0), decoration: const BoxDecoration(color: Colors.transparent, image: DecorationImage(image: AssetImage('assets/pages/homepage/mint/btn_range.png')))),
                      handlerAnimation: const FlutterSliderHandlerAnimation(scale: 1.0),
                      trackBar: FlutterSliderTrackBar(
                        activeTrackBarHeight: width * 0.011,
                        inactiveTrackBarHeight: width * 0.011,
                        activeTrackBar: BoxDecoration(color: widget.craftSwitch == 0 ? const Color(0xFF00FFFF) : const Color(0xFFFF0049)),
                        inactiveTrackBar: BoxDecoration(color: widget.craftSwitch == 0 ? const Color(0x6600FFFF) : const Color(0x66FF0049)),
                      ),
                      tooltip: FlutterSliderTooltip(
                          format: (_) => _currentSliderValue.toStringAsFixed(0),
                          textStyle: GoogleFonts.spaceMono(
                            fontWeight: FontWeight.w700,
                            fontSize: width * 0.036,
                            color: const Color(0xFF00FFFF),
                          ),
                          boxStyle: const FlutterSliderTooltipBox(decoration: BoxDecoration(color: Colors.transparent)),
                          disableAnimation: true,
                          alwaysShowTooltip: true,
                          positionOffset: FlutterSliderTooltipPositionOffset(top: width * 0.068, left: width * 0.02)),
                      onDragging: (handlerIndex, lowerValue, upperValue) {
                        _currentSliderValue = lowerValue;

                        setState(() {});
                      },
                    ))
              ])
            ]))
      ]),
    );
  }

  double calcMax() {
    final bal = widget.craftSwitch == 0 ? waterSamuraiDp : fireSamuraiDp;
    if (bal >= priceDp) {
      return (bal ~/ priceDp).toDouble();
    }
    return 1.0;
  }
}
