import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samurai_app/components/storage.dart';
import 'package:samurai_app/data/music_manager.dart';

import '../components/anim_button.dart';

class SeedPage extends StatefulWidget {
  const SeedPage({super.key});

  @override
  State<SeedPage> createState() => _SeedPageState();
}

class _SeedPageState extends State<SeedPage> {
  String seed = "";

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then(
      (value) => setState(
        () => seed = AppStorage().read('wallet_mnemonic')!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: height,
            width: width,
            child: SvgPicture.asset(
              'assets/background_gradient.svg',
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 25 / 390 * width,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).viewPadding.top * 1.25,
                ),
                Row(
                  children: [
                    PresButton(
                      onTap: () => Navigator.of(context).pop(),
                      params: {'width': width},
                      child: backBtn,
                      player: GetIt.I<MusicManager>().keyBackSignCloseX,
                    ),
                    Expanded(
                      child: Text(
                        'seed phrase',
                        style: TextStyle(
                          fontFamily: 'AmazObitaemOstrovItalic',
                          fontSize: 37 / 844 * height,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(
                      height: width * 0.12,
                      width: width * 0.12,
                    ),
                  ],
                ),
                const Spacer(flex: 30),
                Text(
                  "Whrite down your Seed Phrase in\nthe correct order on paper",
                  style: GoogleFonts.spaceMono(
                    fontSize: 14 / 844 * height,
                    height: 1.3,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(flex: 30),
                SizedBox(
                  height: 500 / 844 * height,
                  width: 340 / 390 * width,
                  child: Stack(
                    children: [
                      Center(
                        child: SizedBox(
                          height: 500 / 844 * height,
                          width: 280 / 390 * width,
                          child: SvgPicture.asset(
                            'assets/seed_border.svg',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          height: 500 / 844 * height,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Spacer(flex: 5),
                              item(height, ' 1'),
                              const Spacer(),
                              item(height, ' 2'),
                              const Spacer(),
                              item(height, ' 3'),
                              const Spacer(),
                              item(height, ' 4'),
                              const Spacer(),
                              item(height, ' 5'),
                              const Spacer(),
                              item(height, ' 6'),
                              const Spacer(),
                              item(height, ' 7'),
                              const Spacer(),
                              item(height, ' 8'),
                              const Spacer(),
                              item(height, ' 9'),
                              const Spacer(),
                              item(height, '10'),
                              const Spacer(),
                              item(height, '11'),
                              const Spacer(),
                              item(height, '12'),
                              const Spacer(flex: 5),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 200),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget item(double height, String id) {
    String word = '';

    if (seed != '') {
      word = seed.split(' ')[int.parse(id) - 1];
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "$id  ",
            style: GoogleFonts.spaceMono(
              fontSize: 16 / 844 * height,
              fontWeight: FontWeight.w700,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          Text(
            word,
            style: GoogleFonts.spaceMono(
              fontSize: 16 / 844 * height,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}
