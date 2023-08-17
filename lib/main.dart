import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:samurai_app/pages/view_web_page.dart';
import 'package:samurai_app/pages/create_wallet.dart';
import 'package:samurai_app/pages/home_page.dart';
import 'package:samurai_app/pages/login_page.dart';
import 'package:samurai_app/pages/pin_code_page.dart';
import 'package:samurai_app/pages/seed_page.dart';
import 'package:samurai_app/pages/settings_page.dart';
import 'package:samurai_app/pages/splash_screen_page.dart';
import 'package:trust_wallet_core_lib/trust_wallet_core_lib.dart';

import 'pages/enter_seed_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  await Hive.initFlutter();
  await Hive.openBox('prefs');
  await Hive.box('prefs').put('appVer', packageInfo.version);
  TrustWalletCoreLib.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primarySwatch: Colors.cyan,
        splashFactory: InkRipple.splashFactory,
      ),
      initialRoute: '/splash',
      routes: {
        '/home': (context) => const HomePage(),
        '/splash': (context) => const SplashScreenPage(),
        '/login': (context) => const LoginPage(),
        '/createWallet': (context) => const CreateWallet(),
        '/pin': (context) => const PinCodePage(),
        '/settings': (context) => const SettingsPage(),
        '/seed': (context) => const SeedPage(),
        '/enterSeed': (context) => const EnterSeedPage(),
        '/viewWebChronic': (context) => const ViewWebPage(url: 'https://samurai-versus.io/chronicles'),
      },
    );
  }
}
