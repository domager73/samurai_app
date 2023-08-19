import 'package:flutter/services.dart';
import 'package:hex/hex.dart';
import 'package:http/http.dart';
import 'package:samurai_app/components/token.dart';
import 'package:trust_wallet_core_lib/trust_wallet_core_ffi.dart';
import 'package:trust_wallet_core_lib/trust_wallet_core_lib.dart';
import 'package:web3dart/web3dart.dart';

import '../components/storage.dart';

class WalletAPI {
  //static const tokenAdresNft = '0x9e03b7c91b94235d71e031876a90c831cf409df4';
  static const tokenAdresGenesisWaterSamyrai =
      '0xa3a92aba1cc7de81ef5eb356fef3ef2701e0e9e4';
  static const tokenAdresGenesisFireSamyrai =
      '0x285c7e1eac419deab8791e600140acf4708c5607';
  static const tokenAdresBarbarianBlade =
      '0x084E459706F9Ce57c6D45255Dc96a871D5C8787C';
  static const tokenAdresBarbarianAxe =
      '0xf95AEbf0e3b41cfa4e87A02e98a35509103a83e4';

  //static const rootWalletAddress = '0x2D423710BaD0e41883C3Ad379b4365ac4a97DE92';
  static const rootWalletAddressBnb =
      '0xfc877Cb55579cF8B9AbD35dB2B2E2D1Fa44AF3EC';
  static const usdcToken = '0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174';
  static const usdtToken = '0x55d398326f99059fF775485246999027B3197955';

  //static const maticToken = '0x0000000000000000000000000000000000001010';
  static const clcToken = '0x04ab77d6dc0707a3fae897e84f7cfa74d9ba85ab';
  static const ryoToken = '0xe410aF59c59bFF9FB49fd176D30a90E000b79938';

  static const NFTHeroContract = '0x172c581Ee5997ffa46Bb7ce19959db98a093314A';

  /*static final ethClient = Web3Client(
    'https://polygon-rpc.com/',
    Client(),
  );
  static const chainIdPoligon = 137;*/
  static final ethClientBnb = Web3Client(
    'https://bsc-dataseed.binance.org/',
    Client(),
  );
  static const chainIdBnb = 56;

  /*static Future<void> transferERC1155(HDWallet wallet, String tokenAddress, int tokenId, int amount, String? toAddress) async {
    PrivateKey privateKey = wallet.getKeyForCoin(
      TWCoinType.TWCoinTypeSmartChain,
    );
    final credentials = EthPrivateKey.fromHex(
      HEX.encode(privateKey.data()),
    );

    final abi = ContractAbi.fromJson(
      await rootBundle.loadString('assets/erc1155.abi.json'),
      'usdc',
    );
    final deployedContract = DeployedContract(
      abi,
      EthereumAddress.fromHex(tokenAddress),
    );
    final tokenContract = Token(deployedContract, ethClient, 137);
    final transaction = Transaction(
      to: EthereumAddress.fromHex(tokenAddress),
    );
    final String transactionHash = await tokenContract.write(
      credentials,
      transaction,
      deployedContract.function('safeTransferFrom'),
      [
        EthereumAddress.fromHex(wallet.getAddressForCoin(TWCoinType.TWCoinTypePolygon)),
        EthereumAddress.fromHex(toAddress ?? rootWalletAddress),
        BigInt.from(tokenId),
        BigInt.from(amount),
        Uint8List.fromList(Uint8List.fromList('0x'.codeUnits)),
      ],
    );
  }*/

  /*static Future<void> transferMATIC(HDWallet wallet, double amount, String? toAddress) async {
    PrivateKey privateKey = wallet.getKeyForCoin(TWCoinType.TWCoinTypeSmartChain);

    final credentials = EthPrivateKey.fromHex(
      HEX.encode(privateKey.data()),
    );

    final transaction = Transaction(
      to: EthereumAddress.fromHex(rootWalletAddress),
      value: EtherAmount.fromBigInt(EtherUnit.wei, BigInt.from(amount * 1000000000000000000)),
    );
    final String transactionHash = await ethClient.sendTransaction(credentials, transaction, chainId: chainIdPoligon);
  }*/

  static Future<void> transferBNB(
      HDWallet wallet, double amount, String? toAddress) async {
    PrivateKey privateKey =
        wallet.getKeyForCoin(TWCoinType.TWCoinTypeSmartChain);

    final credentials = EthPrivateKey.fromHex(
      HEX.encode(privateKey.data()),
    );

    final transaction = Transaction(
      to: EthereumAddress.fromHex(toAddress ?? rootWalletAddressBnb),
      value: EtherAmount.fromBigInt(
          EtherUnit.wei, BigInt.from(amount * 1000000000000000000)),
    );
    final String transactionHash = await ethClientBnb
        .sendTransaction(credentials, transaction, chainId: chainIdBnb);
  }

  /*static Future<void> transferERC20(HDWallet wallet, String tokenAddress, double amount, String? toAddress) async {
    PrivateKey privateKey = wallet.getKeyForCoin(
      TWCoinType.TWCoinTypeSmartChain,
    );
    final credentials = EthPrivateKey.fromHex(
      HEX.encode(privateKey.data()),
    );

    final abi = ContractAbi.fromJson(
      await rootBundle.loadString('assets/token.abi.json'),
      'usdc',
    );
    final deployedContract = DeployedContract(
      abi,
      EthereumAddress.fromHex(tokenAddress),
    );
    final tokenContract = Token(deployedContract, ethClient, 137);
    final transaction = Transaction(
      to: EthereumAddress.fromHex(toAddress ?? rootWalletAddress),
    );
    final String transactionHash = await tokenContract.write(
      credentials,
      transaction,
      deployedContract.function('transfer'),
      [
        EthereumAddress.fromHex(toAddress ?? rootWalletAddress),
        BigInt.from(amount * 1000000000000000000),
      ],
    );
  }*/

  static Future<void> transferERC20Bnb(
      HDWallet wallet,
      String tokenAddress,
      // CLC RIO USDT Transfer
      double amount,
      String? toAddress,
      String asset) async {
    PrivateKey privateKey = wallet.getKeyForCoin(
      TWCoinType.TWCoinTypeSmartChain,
    );
    final credentials = EthPrivateKey.fromHex(
      HEX.encode(privateKey.data()),
    );

    final abi = ContractAbi.fromJson(
      await rootBundle.loadString(asset),
      'usdt',
    );

    final deployedContract = DeployedContract(
      abi,
      EthereumAddress.fromHex(tokenAddress),
    );
    final tokenContract = Token(deployedContract, ethClientBnb, chainIdBnb);
    final transaction = Transaction(
      to: EthereumAddress.fromHex(tokenAddress),
    );
    final String transactionHash = await tokenContract.write(
      credentials,
      transaction,
      deployedContract.function('transfer'),
      [
        EthereumAddress.fromHex(toAddress ?? rootWalletAddressBnb),
        BigInt.from(amount * 1000000000000000000),
      ],
    );
  }

  static Future<void> transfer1155Bnb(HDWallet wallet, String tokenAddress,
      int tokenId, int amount, String? toAddress) async {
    PrivateKey privateKey = wallet.getKeyForCoin(
      TWCoinType.TWCoinTypeSmartChain,
    );
    final credentials = EthPrivateKey.fromHex(
      HEX.encode(privateKey.data()),
    );

    final abi = ContractAbi.fromJson(
      await rootBundle.loadString('assets/abi.samurai.json'),
      'usdt',
    );
    final deployedContract = DeployedContract(
      abi,
      EthereumAddress.fromHex(tokenAddress),
    );
    final tokenContract = Token(deployedContract, ethClientBnb, chainIdBnb);
    final transaction = Transaction(
      to: EthereumAddress.fromHex(tokenAddress),
    );
    final String transactionHash = await tokenContract.write(
      credentials,
      transaction,
      deployedContract.function('safeTransferFrom'),
      [
        EthereumAddress.fromHex(
            wallet.getAddressForCoin(TWCoinType.TWCoinTypeSmartChain)),
        EthereumAddress.fromHex(toAddress ?? rootWalletAddressBnb),
        BigInt.from(tokenId),
        BigInt.from(amount),
        Uint8List.fromList(Uint8List.fromList('0x'.codeUnits)),
      ],
    );
  }

  /*static Future<double> gasPrice() async {
    final gasPrice = await ethClient.getGasPrice();
    //print(gasPrice.getInWei);
    return (gasPrice.getInWei / BigInt.from(1000000000)).toDouble();
  }*/

  static Future<double> gasPriceBnb() async {
    final gasLimit = await ethClientBnb.estimateGas();
    final gasPrice = await ethClientBnb.getGasPrice();
    return (gasPrice.getInWei * gasLimit / BigInt.from(1000000000000000000))
            .toDouble() *
        0.97865;
  }

  static Future<int> getCountHeroByAddress(String address) async {
    final abi = ContractAbi.fromJson(
      await rootBundle.loadString('assets/abi/hero_abi.json'),
      'count',
    );

    DeployedContract contract = DeployedContract(
      abi,
      EthereumAddress.fromHex(NFTHeroContract),
    );

    Token token = Token(contract, WalletAPI.ethClientBnb, WalletAPI.chainIdBnb);

    final res = await token.read(
      contract.function('balanceOf'),
      [
        EthereumAddress.fromHex(address),
      ],
      null,
    );

    return res[0].toInt();
  }

  static Future<dynamic> getHeroIdList(int index) async {
    final String? walletAddress = AppStorage().read('wallet_adress');

    final abi = ContractAbi.fromJson(
      await rootBundle.loadString('assets/abi/hero_abi.json'),
      'count',
    );

    DeployedContract contract = DeployedContract(
      abi,
      EthereumAddress.fromHex(NFTHeroContract),
    );

    Token token = Token(contract, WalletAPI.ethClientBnb, WalletAPI.chainIdBnb);

    final res = await token.read(
      contract.function('tokenOfOwnerByIndex'),
      [EthereumAddress.fromHex(walletAddress!), BigInt.from(index)],
      null,
    );

    return res[0];
  }

  static Future<dynamic> transferHero(
      HDWallet wallet, String toAddress, int heroId) async {
    final PrivateKey privateKey =
        wallet.getKeyForCoin(TWCoinType.TWCoinTypeSmartChain);

    final credentials = EthPrivateKey.fromHex(
      HEX.encode(privateKey.data()),
    );

    final transaction = Transaction(
      to: EthereumAddress.fromHex(NFTHeroContract),
    );

    final String? fromAddress = AppStorage().read('wallet_adress');

    final abi = ContractAbi.fromJson(
        await rootBundle.loadString('assets/abi/hero_abi.json'), 'heroTo');

    final contract = DeployedContract(abi, EthereumAddress.fromHex(NFTHeroContract));

    final token = Token(contract, WalletAPI.ethClientBnb, WalletAPI.chainIdBnb);

    final res = await token.write(
      credentials,
      transaction,
      contract.function("safeTransferFrom"),
      [
        EthereumAddress.fromHex(fromAddress!),
        EthereumAddress.fromHex(toAddress),
        BigInt.from(heroId),
      ],
    );

    print(res);

    return res;
  }
}
