// import 'package:convert/convert.dart';
// import 'package:flutter/material.dart';
// import 'package:trust_wallet_core_lib/trust_wallet_core_ffi.dart';
// import 'package:trust_wallet_core_lib/trust_wallet_core_lib.dart';
// import 'package:web3dart/web3dart.dart';
// import 'package:http/http.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'Token.dart';

// class TrustWallet {
//   HDWallet? wallet;
//   String? addressBNB;
//   String? mnemonicStr;

//   static const node = 'https://polygon-rpc.com/';
//   static const chainId = 56;
//   static String sysWallet = '';
//   static String zbmToken = '';
//   static String usdtToken = '';
//   static String exchangeContract = '';

//   createWallet() async {
//     wallet = HDWallet(strength: 128, passphrase: '');
//     addressBNB = wallet!.getAddressForCoin(TWCoinType.TWCoinTypeSmartChain);
//     mnemonicStr = wallet!.mnemonic();
//   }

//   importWallet(String mnemonic) async {
//     mnemonicStr = mnemonic;
//     debugPrint(mnemonic);
//     debugPrint(mnemonicStr);
//     wallet = HDWallet.createWithMnemonic(mnemonic);
//     debugPrint('FUCK $wallet');
//     addressBNB = wallet!.getAddressForCoin(TWCoinType.TWCoinTypeSmartChain);
//     debugPrint('addressBNB $addressBNB');
//   }

//   Future<String> balanceOf(String valutAddress) async {
//     if (valutAddress.length > 2 && valutAddress.substring(0, 2) == '0x') {
//       final ethClient = Web3Client(node, Client());

//       final abi = ContractAbi.fromJson(
//         await rootBundle.loadString('assets/token.abi.json'),
//         'zboom',
//       );
//       final deployedContract = DeployedContract(
//         abi,
//         EthereumAddress.fromHex(valutAddress),
//       );
//       final token = Token(deployedContract, ethClient, chainId);
//       final res = await token.read(
//         deployedContract.function('balanceOf'),
//         [EthereumAddress.fromHex(addressBNB!)],
//         null,
//       );
//       debugPrint('balanceOf $valutAddress');
//       debugPrint(res.toString());
//       return res[0] != null
//           ? (res[0] / BigInt.from(1000000000000000000)).toStringAsFixed(4)
//           : '0';
//     }
//     return '0';
//   }

//   Future<String?> transfer(String valutAddress, double amount) async {
//     //?test?
//     PrivateKey privateKey = wallet!.getKeyForCoin(
//       TWCoinType.TWCoinTypeSmartChain,
//     );
//     final ethClient = Web3Client(node, Client());
//     final credentials = EthPrivateKey.fromHex(hex.encode(privateKey.data()));

//     final abi = ContractAbi.fromJson(
//       await rootBundle.loadString('assets/token.abi.json'),
//       'zboom',
//     );
//     final deployedContract = DeployedContract(
//       abi,
//       EthereumAddress.fromHex(valutAddress),
//     );
//     final token = Token(deployedContract, ethClient, chainId);
//     final transaction = Transaction(
//       to: EthereumAddress.fromHex(valutAddress),
//     );
//     final res = await token.write(
//       credentials,
//       transaction,
//       deployedContract.function('transfer'),
//       [
//         EthereumAddress.fromHex(exchangeContract),
//         BigInt.from(amount * 1000000000000000000)
//       ],
//     );
//     debugPrint(res);
//     return res;
//   }

//   Future<String?> transferToken(
//     double amount,
//     String to,
//     String valutAddress,
//   ) async {
//     PrivateKey privateKey = wallet!.getKeyForCoin(
//       TWCoinType.TWCoinTypeSmartChain,
//     );
//     final ethClient = Web3Client(node, Client());
//     final credentials = EthPrivateKey.fromHex(hex.encode(privateKey.data()));

//     final abi = ContractAbi.fromJson(
//       await rootBundle.loadString('assets/token.abi.json'),
//       'zboom',
//     );
//     final deployedContract = DeployedContract(
//       abi,
//       EthereumAddress.fromHex(valutAddress),
//     );
//     final token = Token(deployedContract, ethClient, chainId);
//     final transaction = Transaction(
//       to: EthereumAddress.fromHex(valutAddress),
//     );
//     final res = await token.write(
//       credentials,
//       transaction,
//       deployedContract.function('transfer'),
//       [EthereumAddress.fromHex(to), BigInt.from(amount * 1000000000000000000)],
//     );
//     debugPrint(res);
//     return res;
//   }
// }
