import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samurai_app/components/pop_up_spinner.dart';
import 'package:samurai_app/components/show_confirm.dart';

import '../../api/rest.dart';
import '../../components/anim_button.dart';
import '../../components/blinking_separator.dart';
import '../../components/storage.dart';

class HomeMainPage extends StatefulWidget {
  const HomeMainPage({
    super.key,
    required this.watchSamurai,
    required this.switchSamuraiType,
  });

  final Function() watchSamurai;
  final Function(int) switchSamuraiType;

  @override
  State<HomeMainPage> createState() => _HomeMainPageState();
}

class _HomeMainPageState extends State<HomeMainPage> {
  late FixedExtentScrollController daysController;
  late FixedExtentScrollController hoursController;

  late ScrollController _scrollController;
  late Timer _timer;
  double _currentSliderValue = 1.0;
  int craftSwitch = 0;

  int days = 0;
  int daysPrev = 0;
  int daysNext = 0;
  int hours = 0;
  int hoursPrev = 0;
  int hoursNext = 0;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    craftSwitch = int.parse(AppStorage().read('craftSwitch') ?? '0');

    calcStartDate();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (!mounted) {
        timer.cancel();
      }
      calcStartDate();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void calcStartDate() {
    final now = DateTime.now();
    DateTime end = DateTime(2023, 9, 10, 12, 00);
    final diff = now.subtract(now.timeZoneOffset).difference(end);
    //print("$diff, ${diff.inHours}, ${diff.inMinutes}");

    days = -diff.inDays;
    daysPrev = days - 1;
    daysNext = days + 1;
    if (daysPrev < 0) {
      daysPrev = 0;
    }
    hours = -(diff.inHours - diff.inDays * 24);
    hoursPrev = hours - 1;
    if (hoursPrev < 0) {
      hoursPrev = 0;
    }
    hoursNext = hours + 1;
    if (hoursNext > 23) {
      hoursNext = 0;
    }

    daysController = FixedExtentScrollController(initialItem: -diff.inDays);
    hoursController = FixedExtentScrollController(
        initialItem: -(diff.inHours - diff.inDays * 24)
    );
    if (context.mounted) {
      setState(() {});
    }
  }

  Widget sliderCount(double width) {
    return Padding(
      padding: EdgeInsets.only(top: width * 0.03, left: width * 0.065, right: width * 0.06),
      child: FlutterSlider(
        values: [_currentSliderValue],
        max: 10,
        min: 1,
        handler: FlutterSliderHandler(
          child: const SizedBox(height: 1.0),
          decoration: const BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(image: AssetImage('assets/pages/homepage/btn_range.png'))
          )
        ),
        handlerAnimation: const FlutterSliderHandlerAnimation(scale: 1.0),
        trackBar: FlutterSliderTrackBar(
          activeTrackBarHeight: width * 0.011,
          inactiveTrackBarHeight: width * 0.011,
          activeTrackBar: const BoxDecoration(color: Color(0xFF00FFFF)),
          inactiveTrackBar: const BoxDecoration(color: Color(0x6600FFFF)),
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
          positionOffset: FlutterSliderTooltipPositionOffset(top: width * 0.068, left: width * 0.02)
        ),
        onDragging: (handlerIndex, lowerValue, upperValue) {
          _currentSliderValue = lowerValue;
          //_upperValue = upperValue;
          setState(() {});
        },
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RawScrollbar(
        radius: const Radius.circular(36),
        thumbColor: const Color(0xFF00FFFF),
        thumbVisibility: true,
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 50 / 844 * height),
                Text(
                  "TRAINING",
                  style: TextStyle(
                    fontSize: 44 / 844 * height,
                    fontFamily: 'AmazObitaemOstrovItalic',
                    color: Colors.white,
                    height: 0.9,
                  ),
                  textAlign: TextAlign.center,
                ),
                Padding(
                    padding: EdgeInsets.only(left: 0.07 * width, right: 0.08 * width, top: 0.02 * height),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Padding(padding: EdgeInsets.only(top: width * 0.033), child: SvgPicture.asset(
                        'assets/pages/homepage/craft/info.svg',
                        height: width * 0.11,
                        width: width * 0.11,
                      )),
                      Container(
                        padding: EdgeInsets.only(top: 0.01 * height),
                        alignment: Alignment.topCenter,
                        width: width - width * 0.30,
                        child: Text(
                          "UNTIL THE END OF THE ALPHA MINT LEFT:".toUpperCase(),
                          style: GoogleFonts.spaceMono(
                            fontSize: 14 / 844 * height,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF00FFFF),
                          ),
                          softWrap: true,
                          textAlign: TextAlign.center,
                        )
                      )
                    ])
                ),
                SizedBox(height: 5 / 844 * height),
                SizedBox(
                  height: 166 / 354 * (width - width * 0.14),
                  width: width - width * 0.14,
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: 22 / 354 * (width - width * 0.14),
                        ),
                        height: 97 / 354 * (width - width * 0.14),
                        child: Row(
                          children: [
                            const Spacer(
                              flex: 30,
                            ),
                            Expanded(
                              flex: 62,
                              /*child: WheelChooser.integer(
                                controller: daysController,
                                onValueChanged: (i) => debugPrint(i.toString()),
                                maxValue: 100,
                                minValue: 0,
                                isInfinite: true,
                                selectTextStyle: GoogleFonts.spaceMono(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  fontSize: 30 / 354 * (width - width * 0.14),
                                ),
                                unSelectTextStyle: GoogleFonts.spaceMono(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white.withOpacity(0.15),
                                  fontSize: 30 / 354 * (width - width * 0.14),
                                ),
                                itemSize: 60 / 354 * (width - width * 0.14),
                                listHeight: 120 / 354 * (width - width * 0.14),
                              ),*/
                              child: clockWheel(width, days, daysPrev, daysNext)
                            ),
                            const Spacer(
                              flex: 8,
                            ),
                            const BlinkingSeparator(),
                            const Spacer(
                              flex: 33,
                            ),
                            Expanded(
                              flex: 57,
                              /*child: WheelChooser(
                                datas: List<String>.generate(25, (i) => i.toString().padLeft(2, '0')),
                                controller: hoursController,
                                onValueChanged: (i) => debugPrint(i.toString()),
                                startPosition: null,
                                // maxValue: 24,
                                // minValue: 0,
                                isInfinite: true,
                                selectTextStyle: GoogleFonts.spaceMono(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  fontSize: 30 / 354 * (width - width * 0.14),
                                ),
                                unSelectTextStyle: GoogleFonts.spaceMono(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white.withOpacity(0.15),
                                  fontSize: 30 / 354 * (width - width * 0.14),
                                ),
                                itemSize: 60 / 354 * (width - width * 0.14),
                                listHeight: 120 / 354 * (width - width * 0.14),
                              ),*/
                                child: clockWheel(width, hours, hoursPrev, hoursNext)
                            ),
                            const Spacer(
                              flex: 10,
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: SvgPicture.asset(
                          'assets/pages/homepage/clock_border.svg',
                          height: 166 / 354 * (width - width * 0.14),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ],
                  ),
                ),
                /*SizedBox(height: 25 / 844 * height),
                AnimButton(
                  shadowType: 1,
                  onTap: () => {}, //TODO AR
                  child: Stack(
                    children: [
                      SvgPicture.asset(
                        'assets/transparent_button.svg',
                        width: width - width * 0.14,
                        height: (width - width * 0.14) * 0.32,
                      ),
                      SizedBox(
                        width: width - width * 0.14,
                        height: (width - width * 0.14) * 0.32,
                        child: Center(
                          child: Text(
                            "ar masks",
                            style: TextStyle(
                              fontFamily: 'AmazObitaemOstrovItalic',
                              fontSize: height * 0.025,
                              color: const Color(0xFF00FFFF),
                              height: 0.98,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),*/
                Padding(
                  padding: EdgeInsets.only(top: 0.04 * height),
                  child: Text(
                    "BUY samurai for your army:".toUpperCase(),
                    style: GoogleFonts.spaceMono(
                      fontSize: 14 / 844 * height,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF00FFFF),
                    ),
                    textAlign: TextAlign.center,
                  )
                ),
                Container(
                  width: width,
                  height: width * 0.6,
                  margin: EdgeInsets.only(top: 0.02 * height),
                  child: Stack(children: [
                    SvgPicture.asset(
                      'assets/pages/homepage/bg_mint.svg',
                      alignment: Alignment.topCenter,
                      fit: BoxFit.fitWidth,
                    ),
                    SizedBox(
                      width: width,
                      height: width * 0.145,
                      child: Row(children: [
                        SizedBox(
                          width: width * (craftSwitch == 0 ? 0.56 : 0.442),
                          height: width * 0.145,
                          child: InkWell(
                            overlayColor: MaterialStateProperty.all(
                              Colors.transparent,
                            ),
                            onTap: () {
                              widget.switchSamuraiType(0);
                              setState(() {
                                craftSwitch = 0;
                              });
                            },
                            child: craftSwitch == 0 ? SvgPicture.asset(
                              'assets/pages/homepage/tab_mint_water.svg',
                              fit: BoxFit.fitWidth,
                            ) : Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: width * 0.163),
                              child: Text(
                                "WATER",
                                style: TextStyle(
                                  fontSize: 20 / 844 * height,
                                  fontFamily: 'AmazObitaemOstrovItalic',
                                  color: const Color(0xFF00FFFF)
                                ),
                                textAlign: TextAlign.center,
                              )
                            )
                          )
                        ),
                        SizedBox(
                          width: width * (craftSwitch == 0 ? 0.40 : 0.555),
                          height: width * 0.145,
                          child: InkWell(
                            overlayColor: MaterialStateProperty.all(
                              Colors.transparent,
                            ),
                            onTap: () {
                              widget.switchSamuraiType(1);
                              setState(() {
                                craftSwitch = 1;
                              });
                            },
                            child: craftSwitch == 0
                              ? Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.only(left: width * 0.13),
                                  child: Text(
                                    "FIRE",
                                    style: TextStyle(
                                      fontSize: 20 / 844 * height,
                                      fontFamily: 'AmazObitaemOstrovItalic',
                                      color: const Color(0xFF00FFFF)
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                                )
                              : SvgPicture.asset(
                              'assets/pages/homepage/tab_mint_fire.svg',
                              fit: BoxFit.fitWidth,
                            )
                          )
                        )
                      ]),
                    ),
                    Container(
                      width: width,
                      height: width * 0.2,
                      margin: EdgeInsets.only(top: 0.075 * height),
                      child: sliderCount(width)
                    ),
                    Container(
                      width: width,
                      height: width * 0.55,
                      margin: EdgeInsets.only(top: 0.1 * height),
                      child: Padding(
                        padding: EdgeInsets.only(left: 0.06 * width, right: 0.06 * width),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Row(children: [
                            Text(
                              "PRICE: ",
                              style: GoogleFonts.spaceMono(
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF00FFFF),
                                fontSize: 16 / 844 * height,
                              ),
                            ),
                            Text(
                              '${_currentSliderValue * 0.02} BNB',
                              style: GoogleFonts.spaceMono(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: 16 / 844 * height,
                              ),
                            )
                          ]),
                          SizedBox(
                            width: width * 0.44,
                            height: width * 0.15,
                            child: AnimButton(
                              onTap: () {
                                showConfirm(context, 'Are you sure you want to buy samurai?', () {
                                  Navigator.pop(context);
                                  showSpinner(context);
                                  Rest.sendMintSamurai(_currentSliderValue.toInt(), craftSwitch == 0 ? "WATER_SAMURAI_BSC" : "FIRE_SAMURAI_BSC").then((value) {
                                    hideSpinner(context);
                                    AppStorage().updateUserWallet().then((_) {
                                      setState(() {});
                                    });
                                  }).catchError((e) {
                                    if (kDebugMode) {
                                      print(e);
                                    }
                                    hideSpinner(context);
                                  });
                                }, price: '${_currentSliderValue * 0.02} BNB');
                              },
                              shadowType: 1,
                              child: SvgPicture.asset(
                                'assets/pages/homepage/btn_buy_samurai_${craftSwitch == 0 ? 'w' : 'f'}.svg',
                                fit: BoxFit.fitWidth,
                              ),
                            )
                          )
                        ])
                      )
                    )
                  ])
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget clockWheel(double width, int days, int daysPrev, int daysNext) {
    return SizedBox(
      height: 120 / 354 * (width - width * 0.14),
      child: Stack(children: [
        Positioned(
          top: -30 / 354 * (width - width * 0.14),
          child: SizedBox(
            height: 60 / 354 * (width - width * 0.14),
            child: Text(
              daysPrev.toString().padLeft(2, '0'),
              style: GoogleFonts.spaceMono(
                fontWeight: FontWeight.w700,
                color: Colors.white.withOpacity(0.15),
                fontSize: 50 / 354 * (width - width * 0.14),
              ),
              overflow: TextOverflow.clip,
            )
          )
        ),
        Container(
          padding: EdgeInsets.only(top: 10 / 354 * (width - width * 0.14),),
          height: 80 / 354 * (width - width * 0.14),
          child: Text(
            days.toString().padLeft(2, '0'),
            style: GoogleFonts.spaceMono(
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontSize: 50 / 354 * (width - width * 0.14),
            )
          )
        ),
        Container(
          padding: EdgeInsets.only(top: 50 / 354 * (width - width * 0.14),),
          height: 120 / 354 * (width - width * 0.14),
          child: Text(
            daysNext.toString().padLeft(2, '0'),
            style: GoogleFonts.spaceMono(
              fontWeight: FontWeight.w700,
              color: Colors.white.withOpacity(0.15),
              fontSize: 50 / 354 * (width - width * 0.14),
            ),
            overflow: TextOverflow.clip,
          )
        ),
      ])
    );
  }
}
