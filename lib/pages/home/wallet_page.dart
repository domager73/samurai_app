import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:samurai_app/components/pop_up_spinner.dart';
import 'package:samurai_app/components/storage.dart';
import 'package:samurai_app/data/music_manager.dart';
import 'package:samurai_app/pages/home/wallet_page_components.dart';
import 'package:trust_wallet_core_lib/trust_wallet_core_lib.dart';

import '../../api/rest.dart';
import '../../api/wallet.dart';
import '../../components/anim_button.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final ScrollController _samuraiController;
  late final ScrollController _heroesController;
  late String walletAddress;
  late HDWallet wallet;
  final AppStorage appStorage = AppStorage();

  int lastPage = 0;

  List<Map<String, dynamic>> heroes = [];

  late Map<String, dynamic> user;

  Map<String, dynamic> transferTapDialogArgs = {};
  Map<String, dynamic> swapTapDialogArgs = {};

  late final TextEditingController transferTapDialogTextEditingController;
  late final TextEditingController transferToAddressTapDialogTextEditingController;

  late final TextEditingController swapTapDialogTextEditingController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);

    int flag = 0;
    int oldPage = 0;

    _tabController.animation!.addListener(() async {
      double value = _tabController.animation!.value % 1;
      int page = _tabController.animation!.value ~/ 1;

      if (oldPage <= page) {
        if (0.09 < value && 0.2 > value) {
          if (flag == 0) {
            flag = 1;
            log("value $value, page $page, oldPage $oldPage");

            await GetIt.I<MusicManager>().swipeForwPlayer.play().then((value) async {
              await GetIt.I<MusicManager>().swipeForwPlayer.stop();
            }).then((value) async => await GetIt.I<MusicManager>().swipeForwPlayer.seek(Duration(seconds: 0)));
          }
        } else {
          flag = 0;
        }
      } else {
        if (0.91 > value && 0.79 < value) {
          if (flag == 0) {
            flag = 1;
            log("value $value, page $page, oldPage $oldPage");

            await GetIt.I<MusicManager>().swipeBackPlayer.play().then((value) async => await GetIt.I<MusicManager>().swipeBackPlayer.stop()).then((value) async {
              await GetIt.I<MusicManager>().swipeBackPlayer.seek(Duration(seconds: 0));
            });
          }
        } else {
          flag = 0;
        }
      }

      if (value == 0) {
        oldPage = page;
      }
    });

    super.initState();

    _samuraiController = ScrollController();
    _heroesController = ScrollController();

    transferTapDialogTextEditingController = TextEditingController();
    transferToAddressTapDialogTextEditingController = TextEditingController();
    swapTapDialogTextEditingController = TextEditingController();

    walletAddress = appStorage.read('wallet_adress')!;
    wallet = HDWallet.createWithMnemonic(appStorage.read('wallet_mnemonic')!);
  }

  @override
  void dispose() {
    super.dispose();

    _tabController.dispose();
    _samuraiController.dispose();
    _heroesController.dispose();

    transferTapDialogTextEditingController.dispose();
    transferToAddressTapDialogTextEditingController.dispose();

    swapTapDialogTextEditingController.dispose();
  }

  Future<int> loadHeroes() async {
    heroes = [];

    int count = await WalletAPI.getCountHeroByAddress(AppStorage().read('wallet_adress')!);
    for (var i = 0; i < count; i++) {
      Map<String, dynamic>? hero;

      try {
        int heroId = (await WalletAPI.getHeroIdList(i)).toInt();

        hero = await Rest.getHeroDetailsById(heroId);
        hero?['heroId'] = (heroId);
      } catch (e) {
        continue;
      }
      heroes!.add(hero!);
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return ValueListenableBuilder(
        valueListenable: AppStorage().box.listenable(),
        builder: (context, box, widget) {
          final temp = box.get(
            'user',
            defaultValue: <String, dynamic>{},
          );
          if (temp != <String, dynamic>{}) {
            user = Map.from(temp);
          }
          return Container(
            color: Colors.transparent,
            child: Stack(
              children: [
                Column(
                  children: [
                    TabBar(
                      onTap: (newPage) async {},
                      controller: _tabController,
                      tabs: const [
                        Tab(text: 'TOKENS'),
                        Tab(text: 'SAMURAI'),
                        Tab(text: 'HEROES'),
                      ],
                      labelStyle: GoogleFonts.spaceMono(
                        fontSize: 14 / 880 * height,
                        fontWeight: FontWeight.w700,
                        height: 1.45,
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: const Color(0xFF00FFFF),
                      indicatorColor: Colors.white,
                      dividerColor: const Color(0xFF00FFFF),
                      splashBorderRadius: BorderRadius.circular(8),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          getTokens(height, width),
                          getSamurais(height, width),
                          Stack(
                            children: [
                              getHeroes(height, width),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  Widget getSamurais(double height, double width) {
    return RawScrollbar(
      radius: const Radius.circular(36),
      thumbColor: const Color(0xFF00FFFF),
      thumbVisibility: true,
      controller: _samuraiController,
      child: SingleChildScrollView(
        controller: _samuraiController,
        child: Column(
          children: [
            ...AppStorage().getTokens().map((e) {
              if (e['tokenId'] == null) {
                return const SizedBox(width: 1.0);
              }
              final double balance = double.parse((user['${e['name']}_balance_onchain'] ?? '0.0').toString());
              if (balance == 0 && (e['nameToken'] == 'GWS' || e['nameToken'] == 'GFS')) {
                //Скрывать Юнита, если количетво равно Ноль
                return const SizedBox(width: 1.0);
              }
              return getSamurai(
                height,
                width,
                e['logoHero'],
                e['nameHero'],
                e['iconHero'],
                balance.toInt(),
                () {
                  WalletPageComponents.openToGameModalPage(
                      context: context,
                      width: width,
                      height: height,
                      wallet: wallet,
                      tokenAdress: e['address'],
                      tokenId: e['tokenId'],
                      tokenName: e['nameToken'],
                      iconPath: e['logo_b'],
                      balance: balance.toInt(),
                      gas: (e['type'] != null && e['type'] == 'BNB' ? user['gasBnb'] : user['gas']) ?? 0.0,
                      gasName: e['gasName'],
                      isbnb: e['type'] == 'BNB');
                },
                () {
                  WalletPageComponents.openTransferModalPageSamurai(
                      context: context,
                      width: width,
                      height: height,
                      wallet: wallet,
                      tokenAdress: e['address'],
                      tokenId: e['tokenId'],
                      tokenName: e['nameToken'],
                      typeToken: e['typeToken'],
                      iconPath: e['logo_b'],
                      balance: double.parse((user['${e['name']}_balance_onchain'] ?? '0').toString()),
                      gas: (e['type'] != null && e['type'] == 'BNB' ? user['gasBnb'] : user['gas']) ?? 0.0,
                      gasName: 'BNB');
                },
              );
            }).toList(),
            SizedBox(
              height: height * 0.05,
            ),
          ],
        ),
      ),
    );
  }

  Widget getHeroes(double height, double width) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return RawScrollbar(
            radius: const Radius.circular(36),
            thumbColor: const Color(0xFF00FFFF),
            thumbVisibility: true,
            controller: _heroesController,
            child: SingleChildScrollView(
              controller: _heroesController,
              child: Column(
                children: heroes
                    .map((hero) => getHero(height, width, hero['image'], hero['name'], hero['clan'], hero['chronicle'], hero['type'], () async {
                          showSpinner(context);
                          await WalletAPI.transferHero(wallet, WalletAPI.rootWalletAddressBnb, hero['heroId']).then((value) {
                            heroes.where((element) => element['heroId'] == hero['heroId']);
                            setState(() {});
                          });
                          hideSpinner(context);
                        }, () {
                          WalletPageComponents.openTransferModalPageHero(context: context, width: width, height: height, wallet: wallet, iconPath: 'assets/hero_nft_bsc.svg', heroId: hero['heroId']);
                        }))
                    .toList(),
              ),
            ),
          );
        }
        return Container();
      },
      future: loadHeroes(),
    );
  }

  Widget getHero(
    double height,
    double width,
    String heroPath,
    String heroName,
    String heroClass,
    bool inChronicles,
    String heroRare,
    Function toGame,
    Function transfer,
  ) {
    return Container(
      height: width * 0.9 * 0.6,
      width: width * 0.9,
      margin: EdgeInsets.symmetric(
        horizontal: width * 0.05,
        vertical: 8,
      ),
      child: Stack(
        children: [
          Center(
            child: SvgPicture.asset(
              heroRare == 'shogun'
                  ? 'assets/pages/homepage/heroes/feudal_border.svg'
                  : heroRare == 'daimyo'
                      ? 'assets/pages/homepage/heroes/diamyo_border.svg'
                      : 'assets/pages/homepage/heroes/hatamoto_border.svg',
              width: width * 0.9,
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 120,
                child: Center(
                  child: Column(
                    children: [
                      const Spacer(),
                      Image.network(
                        heroPath,
                        width: width * 0.29,
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(flex: 10),
              Expanded(
                flex: 145,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      heroName,
                      style: GoogleFonts.spaceMono(
                        fontSize: height * 0.025,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          heroRare,
                          style: GoogleFonts.spaceMono(
                            fontSize: height * 0.02,
                            fontWeight: FontWeight.w700,
                            color: heroRare == 'feudal'
                                ? const Color(0xFF2589FF)
                                : heroRare == 'diamyo'
                                    ? const Color(0xFFFF0049)
                                    : const Color(0xFF00E417),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: SvgPicture.asset(
                            heroClass == 'fire' ? 'assets/pages/homepage/samurai/fire_icon.svg' : 'assets/pages/homepage/samurai/water_icon.svg',
                            height: height * 0.025,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: SvgPicture.asset(
                        inChronicles ? 'assets/pages/homepage/heroes/in_chronicles.svg' : 'assets/pages/homepage/heroes/unknown.svg',
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 20),
              Expanded(
                flex: 45,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimButton(
                      shadowType: 2,
                      onTap: () => toGame(),
                      child: SvgPicture.asset(
                        'assets/pages/homepage/samurai/to_game.svg',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.017,
                    ),
                    AnimButton(
                      //overlayColor: MaterialStateProperty.all(
                      //Colors.transparent,
                      //),
                      shadowType: 2,
                      onTap: () => transfer(),
                      child: SvgPicture.asset(
                        'assets/pages/homepage/samurai/transfer.svg',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 12),
            ],
          ),
        ],
      ),
    );
  }

  Widget getSamurai(
    double height,
    double width,
    String samuraiPath,
    String samuraiName,
    String samuraiLogoPath,
    int amount,
    Function toGame,
    Function transfer,
  ) {
    return Container(
      height: width * 0.9 * 0.6,
      width: width * 0.9,
      margin: EdgeInsets.symmetric(
        horizontal: width * 0.05,
      ),
      child: Stack(
        children: [
          Center(
            child: SvgPicture.asset(
              'assets/pages/homepage/samurai/border.svg',
              width: width * 0.9,
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 120,
                child: Center(
                  child: Image.asset(
                    samuraiPath,
                    width: width * 0.22,
                  ),
                ),
              ),
              const Spacer(flex: 10),
              Expanded(
                flex: 165,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      samuraiName,
                      style: GoogleFonts.spaceMono(
                        fontSize: height * 0.025,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Samurai',
                          style: GoogleFonts.spaceMono(
                            fontSize: height * 0.025,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: SvgPicture.asset(
                            samuraiLogoPath,
                            height: height * 0.025,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'AMOUNT:',
                        style: GoogleFonts.spaceMono(
                          fontSize: height * 0.012,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF00FFFF),
                        ),
                      ),
                    ),
                    Text(
                      amount.toString(),
                      style: GoogleFonts.spaceMono(
                        fontSize: height * 0.018,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF00FFFF),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 45,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimButton(
                      //overlayColor: MaterialStateProperty.all(
                      //Colors.transparent,
                      //),
                      shadowType: 2,
                      onTap: () => toGame(),
                      child: SvgPicture.asset(
                        'assets/pages/homepage/samurai/to_game.svg',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.017,
                    ),
                    AnimButton(
                      //overlayColor: MaterialStateProperty.all(
                      //Colors.transparent,
                      //),
                      shadowType: 2,
                      onTap: () => transfer(),
                      child: SvgPicture.asset(
                        'assets/pages/homepage/samurai/transfer.svg',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 12),
            ],
          ),
        ],
      ),
    );
  }

  Widget getTokens(double height, double width) {
    return Column(children: [
      ...[
        Row(
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: height * 0.06,
                    top: height * 0.02,
                    bottom: height * 0.02,
                  ),
                  child: Text(
                    'Game',
                    style: GoogleFonts.spaceMono(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 1.45,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: height * 0.05,
                    top: height * 0.02,
                    bottom: height * 0.02,
                  ),
                  child: Text(
                    'Wallet',
                    style: GoogleFonts.spaceMono(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 1.45,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
      ...AppStorage().getTokens().map((e) {
        if (e['tokenId'] != null) {
          return const SizedBox(width: 1.0);
        }
        return Column(children: [
          getSeporator(width),
          getExchanger(
            height,
            width,
            double.parse((user['${e['name']}_balance'] ?? '0.0').toString()),
            double.parse((user['${e['name']}_balance_onchain'] ?? '0.0').toString()),
            e['icon'],
            () async {
              WalletPageComponents.openSwapModalPage(
                      context: context,
                      width: width,
                      height: height,
                      wallet: wallet,
                      tokenAdress: e['address'],
                      token: e['nameToken'],
                      typeToken: e['typeToken'],
                      walletAddress: walletAddress,
                      iconPath: e['logo_b'],
                      balance: double.parse((user['${e['name']}_balance_onchain'] ?? '0.0').toString()),
                      balanceGame: double.parse((user['${e['name']}_balance'] ?? '0.0').toString()),
                      gasName: e['gasName'],
                      gas: (e['type'] != null && e['type'] == 'BNB' ? user['gasBnb'] : user['gas']) ?? 0.0)
                  .then((_) => AppStorage().updateUserWallet());
            },
            () {
              WalletPageComponents.openTransferModalPageSamurai(
                  context: context,
                  width: width,
                  height: height,
                  wallet: wallet,
                  tokenAdress: e['address'],
                  tokenName: e['nameToken'],
                  typeToken: e['typeToken'],
                  iconPath: e['logo_b'],
                  balance: double.parse((user['${e['name']}_balance_onchain'] ?? '0.0').toString()),
                  gasName: e['gasName'],
                  gas: (e['type'] != null && e['type'] == 'BNB' ? user['gasBnb'] : user['gas']) ?? 0.0);
            },
          ),
        ]);
      }).toList(),
      ...[
        SizedBox(
          height: height * 0.05,
        )
      ]
    ]);
  }

  Widget getSeporator(double width) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: width * 0.05),
      color: Colors.white.withOpacity(0.5),
      height: 1,
    );
  }

  Widget getExchanger(
    double height,
    double width,
    double balanceIngame,
    double balanceOnchain,
    String iconPath,
    Function onSwapTap,
    Function onExportTap,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: width * 0.05,
        vertical: height * 0.012,
      ),
      height: height * 0.05,
      child: Row(
        children: [
          SvgPicture.asset(
            iconPath,
            fit: BoxFit.fitHeight,
            width: height * 0.05,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  num.parse(balanceIngame.toStringAsFixed(5)).toString(),
                  style: GoogleFonts.spaceMono(
                    fontWeight: FontWeight.w700,
                    height: 1.45,
                    color: Colors.white,
                    fontSize: height * 0.02,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: height * 0.007),
            child: AnimButton(
              player: GetIt.I<MusicManager>().smallKeyRegAmountAllPlayer,
              onTap: () => onSwapTap(),
              child: SvgPicture.asset(
                'assets/pages/homepage/refresh.svg',
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  num.parse(balanceOnchain.toStringAsFixed(5)).toString(),
                  style: GoogleFonts.spaceMono(
                    fontWeight: FontWeight.w700,
                    height: 1.45,
                    color: Colors.white,
                    fontSize: height * 0.02,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: height * 0.007),
            child: AnimButton(
              player: GetIt.I<MusicManager>().smallKeyRegAmountAllPlayer,
              onTap: () => onExportTap(),
              child: SvgPicture.asset(
                'assets/pages/homepage/next.svg',
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
