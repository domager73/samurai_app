import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:get_it/get_it.dart';
import 'package:samurai_app/api/rest.dart';
import 'package:samurai_app/components/blinking_separator.dart';
import 'package:samurai_app/components/pop_up_spinner.dart';
import 'package:samurai_app/components/storage.dart';
import 'package:samurai_app/data/music_manager.dart';
import 'package:samurai_app/utils/colors.dart';
import 'package:samurai_app/utils/fonts.dart';
import 'package:samurai_app/widgets/buttons/custom_painter_button.dart';
import 'package:samurai_app/widgets/painters/button_by_samurai_red.dart';
import 'package:samurai_app/widgets/popups/custom_popup.dart';
import 'package:samurai_app/widgets/popups/popup_buy_samurai.dart';

import '../../widgets/painters/background_by_samurai.dart';
import '../../widgets/painters/button_by_samurai_blue.dart';

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
    DateTime end = DateTime(2024, 1, 20, 23, 59);
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
        initialItem: -(diff.inHours - diff.inDays * 24));
    if (context.mounted) {
      setState(() {});
    }
  }

  Widget sliderCount(double width) {
    return Padding(
        padding: EdgeInsets.only(
            top: width * 0.03, left: width * 0.065, right: width * 0.06),
        child: FlutterSlider(
          values: [_currentSliderValue],
          max: 10,
          min: 1,
          handler: FlutterSliderHandler(
              child: const SizedBox(height: 1.0),
              decoration: const BoxDecoration(
                  color: Colors.transparent,
                  image: DecorationImage(
                      image:
                          AssetImage('assets/pages/homepage/btn_range.png')))),
          handlerAnimation: const FlutterSliderHandlerAnimation(scale: 1.0),
          trackBar: FlutterSliderTrackBar(
            activeTrackBarHeight: width * 0.011,
            inactiveTrackBarHeight: width * 0.011,
            activeTrackBar: const BoxDecoration(color: Color(0xFF00FFFF)),
            inactiveTrackBar: const BoxDecoration(color: Color(0x6600FFFF)),
          ),
          tooltip: FlutterSliderTooltip(
              format: (_) => _currentSliderValue.toStringAsFixed(0),
              textStyle: AppTypography.spaceMonoW700Blue16,
              boxStyle: const FlutterSliderTooltipBox(
                  decoration: BoxDecoration(color: Colors.transparent)),
              disableAnimation: true,
              alwaysShowTooltip: true,
              positionOffset: FlutterSliderTooltipPositionOffset(
                  top: width * 0.068, left: width * 0.02)),
          onDragging: (handlerIndex, lowerValue, upperValue) {
            _currentSliderValue = lowerValue;
            setState(() {});
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RawScrollbar(
        radius: const Radius.circular(36),
        thumbColor: AppColors.textBlue,
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
                  style: AppTypography.amazObitWhite
                      .copyWith(fontSize: 44, letterSpacing: 3),
                  textAlign: TextAlign.center,
                ),
                Padding(
                    padding: EdgeInsets.only(
                        left: 0.07 * width,
                        right: 0.08 * width,
                        top: 0.02 * height),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: EdgeInsets.only(top: width * 0.033),
                              child: SvgPicture.asset(
                                'assets/pages/homepage/craft/info.svg',
                                height: width * 0.11,
                                width: width * 0.11,
                              )),
                          Container(
                              padding: EdgeInsets.only(top: 0.01 * height),
                              alignment: Alignment.topCenter,
                              width: width - width * 0.30,
                              child: Text(
                                "UNTIL THE END OF THE ALPHA MINT LEFT:"
                                    .toUpperCase(),
                                style: AppTypography.spaceMonoW700Blue16
                                    .copyWith(fontSize: 14),
                                softWrap: true,
                                textAlign: TextAlign.center,
                              ))
                        ])),
                SizedBox(height: 5 / 844 * height),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        clockWheel(width, days, daysPrev, daysNext),
                        Text('DAYS',
                            style: AppTypography.spaceMonoW700Blue16
                                .copyWith(fontSize: 20))
                      ],
                    ),
                    const Column(
                      children: [
                        BlinkingSeparator(),
                        SizedBox(
                          height: 35,
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        clockWheel(width, hours, hoursPrev, hoursNext),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text('HOURS',
                              style: AppTypography.spaceMonoW700Blue16
                                  .copyWith(fontSize: 20)),
                        )
                      ],
                    ),
                  ],
                ),
                Padding(
                    padding: EdgeInsets.only(top: 0.04 * height),
                    child: Text(
                      "BUY samurai for your army:".toUpperCase(),
                      style: AppTypography.spaceMonoW700Blue16
                          .copyWith(fontSize: 14),
                      textAlign: TextAlign.center,
                    )),
                Container(
                    width: width,
                    height: width * 0.6,
                    margin: EdgeInsets.only(top: 0.02 * height),
                    child: CustomPaint(
                      painter: BackgroundBySamuraiPainter(),
                      child: Column(children: [
                        Row(children: [
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
                                  child: craftSwitch == 0
                                      ? SvgPicture.asset(
                                          'assets/pages/homepage/tab_mint_water.svg',
                                          fit: BoxFit.fitWidth,
                                        )
                                      : Container(
                                          alignment: Alignment.centerLeft,
                                          padding: EdgeInsets.only(
                                              left: width * 0.163),
                                          child: Text(
                                            "WATER",
                                            style: AppTypography.amazObit20Blue
                                                .copyWith(
                                                    fontSize: width * 0.048),
                                            textAlign: TextAlign.center,
                                          )))),
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
                                          padding: EdgeInsets.only(
                                              left: width * 0.13),
                                          child: Text(
                                            "FIRE",
                                            style: AppTypography.amazObit20Blue
                                                .copyWith(
                                                    fontSize: width * 0.048),
                                            textAlign: TextAlign.center,
                                          ))
                                      : SvgPicture.asset(
                                          'assets/pages/homepage/tab_mint_fire.svg',
                                          fit: BoxFit.fitWidth,
                                        )))
                        ]),
                        SizedBox(
                            width: width,
                            height: width * 0.2,
                            child: sliderCount(width)),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 0.06 * width, right: 0.06 * width),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  FittedBox(
                                    child: Row(children: [
                                      Text("PRICE: ",
                                          style: AppTypography
                                              .spaceMonoW700White17
                                              .copyWith(
                                            fontSize: 14,
                                            color: AppColors.textBlue,
                                          )),
                                      Text('${_currentSliderValue * 0.02} BNB',
                                          style: AppTypography
                                              .spaceMonoW700White17
                                              .copyWith(
                                            fontSize: 14,
                                          ))
                                    ]),
                                  ),
                                  SizedBox(
                                      width: width * 0.44,
                                      height: width * 0.15,
                                      child: CustomPainterButton(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (ctx) => PopupBuySamurai(
                                                    type: craftSwitch == 0
                                                        ? "WATER_SAMURAI_BSC"
                                                        : "FIRE_SAMURAI_BSC",
                                                    amountSamurai:
                                                        _currentSliderValue
                                                            .toStringAsFixed(0),
                                                    price:
                                                        (_currentSliderValue *
                                                                0.02)
                                                            .toString(),
                                                    acceptFunction: () async {
                                                      Navigator.of(ctx).pop();
                                                      showSpinner(context);
                                                      Rest.sendMintSamurai(
                                                              _currentSliderValue
                                                                  .toInt(),
                                                              craftSwitch == 0
                                                                  ? "WATER_SAMURAI_BSC"
                                                                  : "FIRE_SAMURAI_BSC",
                                                              useDpMint: false)
                                                          .then((value) {
                                                        hideSpinner(context);
                                                        AppStorage()
                                                            .updateUserWallet()
                                                            .then((_) {
                                                          setState(() {});
                                                        });
                                                      }).catchError((e) {
                                                        showDialog(
                                                            context: context,
                                                            builder: (ctx) =>
                                                                const CustomPopup(
                                                                  isError: true,
                                                                  text:
                                                                      'There is not enough BNB in your account. Please note that BNB must be in the account balance, not in the wallet.',
                                                                )).then(
                                                            (value) =>
                                                                hideSpinner(
                                                                    context));
                                                      });
                                                    },
                                                    canselFunction: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ));
                                        },
                                        painter: craftSwitch == 1
                                            ? ButtonBySamuraiRedPainter()
                                            : ButtonBySamuraiBluePainter(),
                                        height: width * 0.12,
                                        width: width * 0.42,
                                        text: 'buy samurai',
                                        player: GetIt.I<MusicManager>()
                                            .menuSettingsSignWaterPlayer,
                                        style: AppTypography.amazObit17Dark
                                            .copyWith(fontSize: width * 0.051),
                                      ))
                                ]))
                      ]),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget clockWheel(double width, int days, int daysPrev, int daysNext) {
    return Container(
      height: 140,
      width: 160,
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage('assets/pages/homepage/background_clock.png'),
      )),
      child: Row(
        children: [
          const SizedBox(
            width: 50,
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: Container(
                  child: Stack(children: [
                    Positioned(
                        top: -36,
                        child: SizedBox(
                            height: 60,
                            child: Text(
                              daysPrev.toString().padLeft(2, '0'),
                              style: AppTypography.spaceMonoW700WhiteOpacity,
                              overflow: TextOverflow.clip,
                            ))),
                    Container(
                        padding: const EdgeInsets.only(
                          top: 12,
                        ),
                        height: 75,
                        child: Text(days.toString().padLeft(2, '0'),
                            style: AppTypography.spaceMonoW700WhiteOpacity
                                .copyWith(color: Colors.white))),
                    Positioned(
                      bottom: -10,
                      child: SizedBox(
                          height: 50,
                          child: Text(
                            daysNext.toString().padLeft(2, '0'),
                            style: AppTypography.spaceMonoW700WhiteOpacity,
                            overflow: TextOverflow.clip,
                          )),
                    ),
                  ]),
                ),
              ),
              const SizedBox(
                height: 22,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
