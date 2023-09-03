import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:samurai_app/components/storage.dart';
import 'package:samurai_app/pages/pin_code_page.dart';

import '../components/bg.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  bool toggle = false;

  @override
  void initState() {
    super.initState();
    String? jwt = AppStorage().read('jwt');

    Future.delayed(const Duration(milliseconds: 1), () {toggle = !toggle;});

    if (jwt == null) {
      Timer(
        const Duration(seconds: 4),
        () {
          Navigator.pushReplacementNamed(context, '/login');
        },
      );
    } else {
      Timer(
        const Duration(seconds: 4),
        () {
          Future.delayed(Duration.zero).then(
            (value) async {
              final res = await AppStorage().fetchUser();
              if (!res) {
                if (mounted) {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              } else {
                await AppStorage().updateUserWallet();
                if (mounted) {
                  Navigator.pushReplacementNamed(context, '/home');
                }
              }
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    precacheImage(backgroundLogin, context);
    return Scaffold(
      backgroundColor: const Color(0xFF020A38),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: backgroundLogin,
            fit: BoxFit.fitHeight
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 50,),
            Image.asset(
              'assets/pages/start/logo.png',
              height: height * 0.27,
              fit: BoxFit.fill,
            ),
            Column(
              children: [
                Container(
                  width: width * 0.9,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black38),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedContainer(
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.white10,
                              spreadRadius: 5,
                              blurRadius: 5,
                            ),
                          ],
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(colors: [
                              Color(0xff0AF5F8),
                              Color(0xffBE4178),
                            ])),
                        height: 10,
                        duration: const Duration(seconds: 3),
                        width: toggle ? width * 0.9 : 0,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50,),
                Padding(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: Image.asset(
                    'assets/pages/start/clc_logo.png',
                    scale: 8.0
                  ),
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
