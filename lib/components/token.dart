import 'package:web3dart/web3dart.dart';

class Token extends GeneratedContract {
  Token(
    DeployedContract self,
    Web3Client client,
    int? chainId,
  ) : super(self, client, chainId);
}
