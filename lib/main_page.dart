import 'package:flutter/material.dart';
import 'package:Notorization/blockchain_constant.dart' as Blockchain;
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Client httpClient;
  Web3Client ethClient;
  bool data = false;

  //
  final myAddress = Blockchain.metamask_address;
  String txHash;

  @override
  void initState() {
    super.initState();
    httpClient = Client();
    // print(httpClient);
    ethClient = Web3Client(Blockchain.infura_address, httpClient);
    // setTesting("Miss ya so much");
    // print('Before set Testing');
    // returnTesting(Blockchain.metamask_address);
    // print('set Testing');
    // setTesting("I am Punreach");
    // print('After set Testing');
    // returnTesting(Blockchain.metamask_address);
  }

  Future<DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString("assets/abi/abi.json");
    String contractAddress = Blockchain.contract_address;

    final contract = DeployedContract(ContractAbi.fromJson(abi, "Notorization"),
        EthereumAddress.fromHex(contractAddress));

    return contract;
  }

  // ********* IMPORTANT ********* //
  // ==== This is to get the information only ==== //
  // ==== Get method ==== //
  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    //
    final contract = await loadContract();
    final ethFunction = contract.function(functionName);

    // This line below doesn't work.
    final result = await ethClient.call(
      contract: contract,
      function: ethFunction,
      params: args,
    );

    // print(result.toString());
    return result;
  }

  // ********* IMPORTANT ********* //
  // ==== This is to set the information only ==== //
  // ==== set method ==== //
  Future<String> submit(String functionName, List<dynamic> args) async {
    EthPrivateKey credentials =
        EthPrivateKey.fromHex(Blockchain.metamask_private_key);

    DeployedContract contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: ethFunction,
        parameters: args,
      ),
      fetchChainIdFromNetworkId: true,
    );
    return result;
  }

  // targetAddress is my address
  Future<void> returnTesting(String targetAddress) async {
    EthereumAddress address = EthereumAddress.fromHex(targetAddress);
    List<dynamic> result = await query("returnTesting", []);

    print('======== ${result[0]} ========');
  }

  Future<String> setTesting(String testingWord) async {
    // var myText = _currentTextValue;

    var response = await submit("setTesting", [testingWord]);

    // print(response);
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(),
        ),
      ),
    );
  }
}
