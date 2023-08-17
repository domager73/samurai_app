// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:flutter/services.dart';
// import 'package:hex/hex.dart';
// import 'package:http/http.dart' as http;
// import 'package:http/http.dart';
// import 'package:samurai_app/components/storage.dart';
// import 'package:samurai_app/components/token.dart';
// import 'package:samurai_app/components/trust_wallet.dart';
// import 'package:trust_wallet_core_lib/trust_wallet_core_ffi.dart';
// import 'package:trust_wallet_core_lib/trust_wallet_core_lib.dart';
// import 'package:web3dart/web3dart.dart';

// class CryptoWalletModel with ChangeNotifier {
//   static const String _baseUrl = 'https://api.samurai-versus.io';
//   static const String _node = 'https://polygon-rpc.com/';
//   static const _chainId = 56;

//   static const String _recvSysWalletAddress =
//       '0x453c00D63B3496D7DC48B98936CBF7873eFb4625';

//   late AppStorage appStorage;
//   late String? _jwt;
//   late String? _phrase;
//   late String? _myAddress;
//   late List _coins;
//   late HDWallet? _wallet;
//   late TrustWallet trustWallet;

//   late Map _currentTokenData;

//   bool isInitWallet = false;
//   String? get myAddress => _myAddress;
//   String? get phrase => _phrase;
//   Map get currentTokenData => _currentTokenData;
//   double get emeraldOnChain => 0;
//   List get coins => _coins;

//   Future<void> init() async {
//     debugPrint('INIT CRYPTO WALLET MODEL');
//     TrustWalletCoreLib.init();
//     appStorage = AppStorage();
//     _jwt = appStorage.read('jwt');
//     _phrase = appStorage.read('wallet_phrase');
//     trustWallet = TrustWallet();
//     debugPrint(_phrase);
//     if (_phrase != null && _phrase!.isNotEmpty) {
//       try {
//         _wallet = HDWallet.createWithMnemonic(_phrase!);
//         trustWallet.importWallet(_phrase!);
//         _myAddress = _wallet!.getAddressForCoin(
//           TWCoinType.TWCoinTypeSmartChain,
//         );
//         isInitWallet = true;
//       } catch (e) {
//         debugPrint(e.toString());
//         _wallet = null;
//         _phrase = null;
//         _myAddress = null;
//       }
//     } else {
//       _wallet = null;
//       _phrase = null;
//       _myAddress = null;
//     }
//     _currentTokenData = {};
//     debugPrint('INIT DONE');
//     notifyListeners();
//   }

//   Future<void> loadTokensBalance() async {
//     await Future.delayed(const Duration(milliseconds: 3));
//     // _coins = [];
//     // notifyListeners();
//     // if (_jwt != null && _jwt!.isNotEmpty) {
//     //   final http.Response response2 = await http.get(
//     //     Uri.parse('$_baseUrl/balance/balance'),
//     //     headers: {'Authorization': 'Bearer ${_jwt!}'},
//     //   );
//     //   final data2 = jsonDecode(response2.body);
//     //   coins.add(
//     //     {
//     //       'name': 'Emerald',
//     //       'codename': 'EMRLD',
//     //       'amount': data2['balance'].toDouble(),
//     //       'amount_onchain': 0.0,
//     //       'address': null,
//     //       'logo': null,
//     //     },
//     //   );
//     //   final http.Response response = await http.get(
//     //     Uri.parse('$_baseUrl/balance/monets-list'),
//     //     headers: {'Authorization': 'Bearer ${_jwt!}'},
//     //   );
//     //   final data = jsonDecode(response.body);
//     //   final ethClient = Web3Client(_node, Client());
//     //   final abi = ContractAbi.fromJson(
//     //     await rootBundle.loadString('assets/token.abi.json'),
//     //     'zboom',
//     //   );

//     //   for (int i = 0; i < data['objects'].length; i++) {
//     //     debugPrint(
//     //       '${data['objects'][i]['codename']} ${data['objects'][i]['address']}',
//     //     );
//     //     try {
//     //       data['objects'][i]['amount'] = double.parse(
//     //         data['objects'][i]['amount'],
//     //       );
//     //     } catch (_) {
//     //       data['objects'][i]['amount'] = 0.0;
//     //     }
//     //     if (data['objects'][i]['address'] != null &&
//     //         data['objects'][i]['address'].isNotEmpty &&
//     //         data['objects'][i]['address'] != '0x0' &&
//     //         _wallet != null) {
//     //       if (data['objects'][i]['codename'] == 'BNB') {
//     //         final EtherAmount bnbBalance = await ethClient.getBalance(
//     //           EthereumAddress.fromHex(_myAddress!),
//     //         );
//     //         data['objects'][i]['amount_onchain'] =
//     //             (bnbBalance.getInWei / BigInt.from(1000000000000000000))
//     //                 .toDouble();
//     //       } else {
//     //         final deployedContract = DeployedContract(
//     //           abi,
//     //           EthereumAddress.fromHex(data['objects'][i]['address']),
//     //         );
//     //         final token = Token(deployedContract, ethClient, _chainId);
//     //         final List res = await token.read(
//     //           deployedContract.function('balanceOf'),
//     //           [EthereumAddress.fromHex(_myAddress!)],
//     //           null,
//     //         );
//     //         if (res.isEmpty || res[0] == null) {
//     //           data['objects'][i]['amount_onchain'] = 0.0;
//     //         } else {
//     //           data['objects'][i]['amount_onchain'] =
//     //               (res[0] / BigInt.from(1000000000000000000)).toDouble();
//     //         }
//     //       }
//     //     } else {
//     //       data['objects'][i]['amount_onchain'] = 0.0;
//     //     }
//     //   }
//     //   coins.addAll(data['objects']);
//     notifyListeners();
//   }

//   Future<void> transformTokenInGameToTokenOnChain(double amount) async {
//     final http.Response res = await http.post(
//       Uri.parse('$_baseUrl/wallet/transfer'),
//       headers: {'Authorization': 'Bearer ${_jwt!}'},
//       body: json.encode(
//         {
//           'moneta_id': _currentTokenData['id'],
//           'amount': amount,
//           'wallet': _myAddress,
//           'site_id': 2,
//         },
//       ),
//     );
//     await loadTokensBalance();
//   }

//   Future<void> transformTokenOnChainToTokenInGame(double amount) async {
//     final String token = currentTokenData['address'];
//     final int monetaId = int.parse(currentTokenData['id']);

//     PrivateKey privateKey = _wallet!.getKeyForCoin(
//       TWCoinType.TWCoinTypeSmartChain,
//     );
//     final ethClient = Web3Client(
//       _node,
//       Client(),
//     );
//     final credentials = EthPrivateKey.fromHex(
//       HEX.encode(privateKey.data()),
//     );

//     final abi = ContractAbi.fromJson(
//       await rootBundle.loadString('assets/token.abi.json'),
//       'zboom',
//     );
//     final deployedContract = DeployedContract(
//       abi,
//       EthereumAddress.fromHex(token),
//     );
//     final tokenContract = Token(deployedContract, ethClient, _chainId);
//     final transaction = Transaction(
//       to: EthereumAddress.fromHex(token),
//     );
//     final String transactionHash = await tokenContract.write(
//       credentials,
//       transaction,
//       deployedContract.function('transfer'),
//       [
//         EthereumAddress.fromHex(_recvSysWalletAddress),
//         BigInt.from(amount * 1000000000000000000),
//       ],
//     );
//     debugPrint('TRANSACTION HASH $transactionHash');
//     final http.Response res = await http.post(
//       Uri.parse('$_baseUrl/wallet/return'),
//       headers: {'Authorization': 'Bearer ${_jwt!}'},
//       body: json.encode(
//         {
//           'moneta_id': monetaId,
//           'amount': amount,
//           'wallet': _myAddress,
//           'trx': transactionHash,
//           'site_id': 2,
//         },
//       ),
//     );
//     debugPrint(res.body);
//   }

//   Future<void> sendTokenFromWalletToOtherWallet(
//     String addressTo,
//     double amount,
//   ) async {
//     final String token = currentTokenData['address'];
//     PrivateKey privateKey =
//         _wallet!.getKeyForCoin(TWCoinType.TWCoinTypeSmartChain);
//     final ethClient = Web3Client(_node, Client());
//     final credentials = EthPrivateKey.fromHex(
//       HEX.encode(privateKey.data()),
//     );

//     final abi = ContractAbi.fromJson(
//       await rootBundle.loadString('assets/token.abi.json'),
//       'zboom',
//     );
//     final deployedContract = DeployedContract(
//       abi,
//       EthereumAddress.fromHex(token),
//     );
//     final tokenContract = Token(deployedContract, ethClient, _chainId);
//     final transaction = Transaction(
//       to: EthereumAddress.fromHex(token),
//     );
//     final res = await tokenContract.write(
//       credentials,
//       transaction,
//       deployedContract.function('transfer'),
//       [
//         EthereumAddress.fromHex(addressTo),
//         BigInt.from(amount * 1000000000000000000),
//       ],
//     );
//     debugPrint('TRANSACTION HASH $res');
//   }

//   Future<void> createWallet() async {
//     _wallet = HDWallet(strength: 128, passphrase: '');
//     _myAddress = _wallet!.getAddressForCoin(TWCoinType.TWCoinTypeSmartChain);
//     _phrase = _wallet!.mnemonic();
//     trustWallet.importWallet(_phrase!);
//     await appStorage.write('wallet_phrase', _phrase);
//     notifyListeners();
//   }

//   Future<void> loadWallet(String phrase) async {
//     _phrase = phrase;
//     _wallet = HDWallet.createWithMnemonic(_phrase!);
//     _myAddress = _wallet!.getAddressForCoin(TWCoinType.TWCoinTypeSmartChain);
//     trustWallet.importWallet(_phrase!);
//     await appStorage.write('wallet_phrase', _phrase);
//     await loadTokensBalance();
//     notifyListeners();
//   }

//   Future<void> unloadWallet() async {
//     _wallet = null;
//     _phrase = null;
//     _myAddress = null;
//     await appStorage.remove('wallet_phrase');
//     notifyListeners();
//   }

//   void setCurrentTokenData(Map value) {
//     _currentTokenData = value;
//     notifyListeners();
//   }
// }
