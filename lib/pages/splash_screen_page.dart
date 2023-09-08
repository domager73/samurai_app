import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:samurai_app/components/storage.dart';

import '../components/bg.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  String state = "";

  void loadUserData() async {
    String? jwt = AppStorage().read('jwt');
    if (jwt == null) {
      state = 'l';
    } else {
      final res = await AppStorage().fetchUser();
      if (!res) {
        if (mounted) {
          state = 'l';
        }
      } else {
        await AppStorage().updateUserWallet();
        if (mounted) {
          state = 'h';
        }
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    loadUserData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery
        .of(context)
        .size
        .height;
    precacheImage(backgroundLogin, context);
    return Scaffold(
      backgroundColor: const Color(0xFF020A38),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            image:
            DecorationImage(image: backgroundLogin, fit: BoxFit.fitHeight)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              height: 50,
            ),
            Image.asset(
              'assets/pages/start/logo.png',
              height: height * 0.27,
              fit: BoxFit.fill,
            ),
            Column(
              children: [
                LinearPercentIndicator(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  backgroundColor: Colors.black38,
                  barRadius: const Radius.circular(10),
                  animation: true,
                  lineHeight: 10,
                  linearGradient: const LinearGradient(colors: [
                    Color(0xff0AF5F8),
                    Color(0xffBE4178),
                  ]),
                  animationDuration: 5000,
                  percent: 1,
                  linearStrokeCap: LinearStrokeCap.round,
                  onAnimationEnd: () {
                    if (state == 'h'){
                      Navigator.pushReplacementNamed(context, '/home');
                      return;
                    }

                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: Image.asset('assets/pages/start/clc_logo.png',
                      scale: 8.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    "By CLC",
                    style: GoogleFonts.jost(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
