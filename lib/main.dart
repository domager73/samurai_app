import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:samurai_app/components/storage.dart';
import 'package:samurai_app/data/music_manager.dart';
import 'package:samurai_app/pages/view_web_page.dart';
import 'package:samurai_app/pages/create_wallet.dart';
import 'package:samurai_app/pages/home_page.dart';
import 'package:samurai_app/pages/login_page.dart';
import 'package:samurai_app/pages/pin_code_page.dart';
import 'package:samurai_app/pages/seed_page.dart';
import 'package:samurai_app/pages/settings_page.dart';
import 'package:samurai_app/pages/splash_screen_page.dart';
import 'package:samurai_app/utils/enums.dart';
import 'package:trust_wallet_core_lib/trust_wallet_core_lib.dart';

import 'pages/enter_seed_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  await Hive.initFlutter();
  await Hive.openBox('prefs');
  await Hive.box('prefs').put('appVer', packageInfo.version);
  GetIt.I.registerSingleton(MusicManager());

  TrustWalletCoreLib.init();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  static Future<void> stopPlayer(BuildContext context) async {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    await state?.stopPlayer();
  }

  static Future<void> playPlayer(BuildContext context) async {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    await state?.initMusic();
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late AudioPlayer player;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
    player.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        await player.play();

        print("app in resumed");
        break;
      case AppLifecycleState.inactive:
        await player.stop();
        break;
      case AppLifecycleState.paused:
        await player.stop();

        print("app in paused");
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
      case AppLifecycleState.hidden:
        // TODO: Handle this case.
        break;
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    super.initState();
    if (AppStorage().read(musicSwitchKey) == null) {
      AppStorage().write(musicSwitchKey, "true");
      log("swtich key inited");
    }

    if (AppStorage().read(musicSwitchKey) == 'true') {
      initMusic();
    }
  }

  Future<void> initMusic() async {
    initBackgroundMusic();

    List<AudioPlayer> players = GetIt.I<MusicManager>().players;

    for (var player in players) {
      await player
          .setVolume(0)
          .then((value) async => await player.setSpeed(10000000000000000000000.0))
          .then((value) async => await player.play())
          .then((value) async => await player.stop())
          .then((value) async => await player.setSpeed(1))
          .then((value) async => await player.setVolume(1));
      // .then((value) async=>await player.seek(Duration.zero));
      log('done');
    }
  }

  Future<void> initBackgroundMusic() async{
    player = AudioPlayer();
    await GetIt.I<MusicManager>().registerMusicAssets();

    await player.setAsset(MusicAssets.mainLoop1);
    await player.play();
    await player.playerStateStream.listen((event) async {
      print(event.processingState);

      switch (event.processingState) {
        case ProcessingState.completed:
          await player.setAsset(MusicAssets.mainLoop2);
          await player.play();
      }
    });
  }

  Future<void> stopPlayer() async {
    await player.dispose();
    await GetIt.I<MusicManager>().stopMusicAssets();
  }


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
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
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
        '/viewWebChronic': (context) =>
            const ViewWebPage(url: 'https://samurai-versus.io/chronicles'),
      },
    );
  }
}
