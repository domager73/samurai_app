import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:samurai_app/api/rest.dart';
import 'package:samurai_app/components/token.dart';
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';

import '../api/wallet.dart';

class AppStorage {
  Box box = Hive.box('prefs');

  static const List<Map<String, dynamic>> tokens = [
    /*{
      'name': 'usdt',
      'asset': 'assets/usdt.abi.json',
      'address': WalletAPI.usdtToken,
      'type': 'BNB',
      'typeToken': 'USDC_BSC',
      'nameToken': 'USDT',
      'gasName': 'Gwei',
      'icon': 'assets/usdt_logo.svg',
      'logo_b': 'assets/usdt_logo_b.svg'
    },*/
    {
      'name': 'bnb',
      'asset': '',
      'address': '0x0',
      'type': 'BNB',
      'typeToken': 'BNB',
      'nameToken': 'BNB',
      'gasName': 'BNB',
      'icon': 'assets/bnb_logo.svg',
      'logo_b': 'assets/bnb_logo_b.svg'
    },
    {
      'name': 'clc',
      'asset': 'assets/token.abi.json',
      'address': WalletAPI.clcToken,
      'type': 'BNB',
      'typeToken': 'CLC_BSC',
      'nameToken': 'CLC',
      'gasName': 'BNB',
      'icon': 'assets/clc_logo.svg',
      'logo_b': 'assets/clc_logo_b.svg'
    },
    {
      'name': 'ryo',
      'asset': 'assets/token.abi.json',
      'address': WalletAPI.ryoToken,
      'type': 'BNB',
      'typeToken': 'RYO_BSC',
      'nameToken': 'RYO',
      'gasName': 'BNB',
      'icon': 'assets/ryo_logo.svg',
      'logo_b': 'assets/ryo_logo_b.svg'
    },
    {
      'name': 'water_samurai',
      'asset': 'assets/erc1155.abi.json',
      'address': WalletAPI.tokenAdresBarbarianBlade,
      'type': 'BNB',
      'typeToken': 'WATER_SAMURAI_BSC',
      'nameToken': 'BA',
      'gasName': 'BNB',
      'tokenId': 1,
      'icon': 'assets/nft_bnb.svg',
      'logo_b': 'assets/nft_bnb.svg',
      'nameHero': 'Water',
      'logoHero': 'assets/pages/homepage/samurai/water_samurai.png',
      'iconHero': 'assets/pages/homepage/samurai/water_icon.svg',
    },
    {
      'name': 'fire_samurai',
      'asset': 'assets/erc1155.abi.json',
      'address': WalletAPI.tokenAdresBarbarianAxe,
      'type': 'BNB',
      'typeToken': 'FIRE_SAMURAI_BSC',
      'nameToken': 'BB',
      'gasName': 'BNB',
      'tokenId': 1,
      'icon': 'assets/nft_bnb.svg',
      'logo_b': 'assets/nft_bnb.svg',
      'nameHero': 'Fire',
      'logoHero': 'assets/pages/homepage/samurai/fire_samurai.png',
      'iconHero': 'assets/pages/homepage/samurai/fire_icon.svg',
    },
    {
      'name': 'gws_samurai',
      'asset': 'assets/abi.samurai.json',
      'address': WalletAPI.tokenAdresGenesisWaterSamyrai,
      'type': 'BNB',
      'typeToken': 'WATER_SAMURAI_GENESIS_BSC',
      'nameToken': 'GWS',
      'gasName': 'BNB',
      'tokenId': 1,
      'icon': 'assets/nft_bnb.svg',
      'logo_b': 'assets/nft_bnb.svg',
      'nameHero': 'Water',
      'logoHero': 'assets/pages/homepage/samurai/water_samurai.png',
      'iconHero': 'assets/pages/homepage/samurai/water_genesis_icon.svg',
    },
    {
      'name': 'gfs_samurai',
      'asset': 'assets/abi.samurai.json',
      'address': WalletAPI.tokenAdresGenesisFireSamyrai,
      'type': 'BNB',
      'typeToken': 'FIRE_SAMURAI_GENESIS_BSC',
      'nameToken': 'GFS',
      'gasName': 'BNB',
      'tokenId': 1,
      'icon': 'assets/nft_bnb.svg',
      'logo_b': 'assets/nft_bnb.svg',
      'nameHero': 'Fire',
      'logoHero': 'assets/pages/homepage/samurai/fire_samurai.png',
      'iconHero': 'assets/pages/homepage/samurai/fire_genesis_icon.svg',
    },
  ];

  String? read(String key) {
    //if (key == 'jwt' && kDebugMode) {
    //return 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNjg2MDAyNDU1LCJleHAiOjE3MTc1Mzg0NTV9.Yv73IWXfQukSl1S5KGaXY4QeMGDDeklvwtnqqqtlWN8';
    //}
    return box.get(key) as String?;
  }

  Future<void> write(String key, String? value) async {
    if (value != null) {
      await box.put(key, value);
    }
  }

  Future<void> remove(String key) async {
    await box.delete(key);
  }

  Future<bool> fetchUser() async {
    final Map? value = await Rest.getUser();
    print(value);
    if (value != null) {
      final Map<String, dynamic> userData = Map.from(value);
      if (kDebugMode) {
        print(userData);
      }
      if (userData['tfa'] != null) {
        AppStorage().write('use-tfa', userData['tfa']);
      }
      await box.put('user', userData);
      return true;
    } else {
      return false;
    }
  }

  Future<void> updateUserWallet() async {
    final String? walletAddress = AppStorage().read('wallet_adress');
    final String? walletMnemonic = AppStorage().read('wallet_mnemonic');

    final Map? value = await Rest.getUser();
    if (value == null) {
      return;
    }
    final Map<String, dynamic> userData = Map.from(value);

    if (walletAddress != null && walletMnemonic != null) {
      await Future.forEach(
        tokens,
        ((el) async {
          List res = [];
          if (el['asset'].toString().isNotEmpty) {
            final abi = ContractAbi.fromJson(
              await rootBundle.loadString(el['asset']!),
              el['name']!,
            );

            DeployedContract contractUsdc = DeployedContract(
              abi,
              EthereumAddress.fromHex(
                el['address']!,
              ),
            );
            if (kDebugMode) {
              print(el['address']);
            }
            late Token token;
            //if (el['type'] == 'BNB') {
              token = Token(contractUsdc, WalletAPI.ethClientBnb, WalletAPI.chainIdBnb);
            //} else {
              //token = Token(contractUsdc, WalletAPI.ethClient, WalletAPI.chainIdPoligon);
            //}
            if (el['tokenId'] == null) {
              res = await token.read(
                contractUsdc.function('balanceOf'),
                [
                  EthereumAddress.fromHex(walletAddress),
                ],
                null,
              );
            } else {
              res = await token.read(
                contractUsdc.function('balanceOf'),
                [
                  EthereumAddress.fromHex(walletAddress),
                  BigInt.from(el['tokenId'])
                ],
                null,
              );
            }
          } else {
            //bnb
            if (kDebugMode) {
              print('bnb');
            }
            final bal = await WalletAPI.ethClientBnb
                .getBalance(EthereumAddress.fromHex(walletAddress));
            res.add(bal.getInWei);
          }
          if (kDebugMode) {
            print(res);
          }
          if (res.isNotEmpty) {
            if (el['name'].toString().contains('samurai')) {
              userData.addAll({
                '${el['name']!}_balance_onchain':
                    (res[0] / BigInt.from(1)).toDouble(),
              });
            } else {
              userData.addAll({
                '${el['name']!}_balance_onchain':
                    (res[0] / BigInt.from(1000000000000000000)).toDouble()
              });
            }
          } else {
            userData.addAll({
              '${el['name']!}_balance_onchain': 0.0,
            });
          }
        }),
      );

      userData.addAll({'gas': 0.0/*await WalletAPI.gasPrice()*/});

      userData.addAll({'gasBnb': await WalletAPI.gasPriceBnb()});
    }
    if (kDebugMode) {
      print(userData);
    }
    await box.put('user', userData);
  }

  Map<String, dynamic> getUser() {
    return box.get('user', defaultValue: {
      'usdc_balance': 0,
    });
  }

  Map<String, dynamic> getUserWallet() {
    return box.get('user', defaultValue: {});
  }

  List<Map<String, dynamic>> getTokens() {
    return tokens;
  }
}
