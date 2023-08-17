import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class XpLoaderWidget extends StatelessWidget {
  final double height;
  final double width;
  final bool isWater;

  const XpLoaderWidget({
    super.key,
    required this.height,
    required this.width,
    required this.isWater,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(
              top: 32 / 844 * height, bottom: 16 / 844 * height),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "XP earned: ",
                style: GoogleFonts.spaceMono(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF00FFFF),
                  fontSize: 16 / 844 * height,
                ),
              ),
              Text(
                '120', // xp amount
                style: GoogleFonts.spaceMono(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 16 / 844 * height,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          width: width,
          child: SizedBox(
            width: width - width * 0.14,
            child: Stack(
              children: [
                SvgPicture.asset(
                  'assets/pages/homepage/craft/loader_${isWater ? 'water' : 'fire'}.svg',
                  fit: BoxFit.fitWidth,
                ),
                SizedBox(
                  width: width - width * 0.14,
                  height: 16 / 335 * (width - width * 0.14),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 80, // xp percentage
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF00FFFF),
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
                      const Spacer(flex: 20),
                    ],
                  ),
                ),
                Positioned(
                  right: 0,
                  child: Text(
                    '120',
                    style: GoogleFonts.spaceMono(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 14 / 844 * height,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
