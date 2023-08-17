import 'package:flutter/material.dart';

const waterBg = AssetImage('assets/pages/homepage/craft/water_bg.jpg');
const fireBg = AssetImage('assets/pages/homepage/craft/fire_bg.jpg');
const homeMainBg = AssetImage('assets/pages/homepage/home_main_bg.jpg');
const homeForgeBg = AssetImage('assets/pages/homepage/home_forge.jpg');
const homeStorageBg = AssetImage('assets/pages/homepage/home_storage.jpg');
const waterSamuraiImg = AssetImage('assets/pages/homepage/samurai/water_samurai.png');
const fireSamuraiImg = AssetImage('assets/pages/homepage/samurai/fire_samurai.png');
const modalBottomsheetBg = AssetImage('assets/modal_bottom_sheet_bg.png');
const backgroundLogin = AssetImage('assets/pages/start/background.jpg');
const backgroundLoginOpacity = AssetImage('assets/pages/start/background_opacity.png');
const backgroundDialog = AssetImage('assets/pages/dialog/bg_dialog.png');
const heroMintWaterBg = AssetImage('assets/pages/homepage/mint/bg_hero_mint_water.jpg');
const heroMintFireBg = AssetImage('assets/pages/homepage/mint/bg_hero_mint_fire.jpg');

void precacheImages(BuildContext context) {
  precacheImage(homeMainBg, context);
  precacheImage(homeForgeBg, context);
  precacheImage(homeStorageBg, context);
  precacheImage(waterBg, context);
  precacheImage(fireBg, context);
  precacheImage(waterSamuraiImg, context);
  precacheImage(fireSamuraiImg, context);
  precacheImage(modalBottomsheetBg, context);
  precacheImage(backgroundLogin, context);
  precacheImage(backgroundLoginOpacity, context);
  precacheImage(backgroundDialog, context);
  precacheImage(heroMintWaterBg, context);
  precacheImage(heroMintFireBg, context);
}
