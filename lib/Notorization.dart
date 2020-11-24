import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:Notorization/blockchain_constant.dart' as Blockchain;

class Notorization extends StatefulWidget {
  @override
  _NotorizationState createState() => _NotorizationState();
}

class _NotorizationState extends State<Notorization> {
  Client httpClient;
  Web3Client ethClient;
  bool data = false;

  String filename;
  String comment;

  //
  final _formKey = GlobalKey<FormState>();

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

    final contract = DeployedContract(ContractAbi.fromJson(abi, "Notary"),
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
    // print(contract.abi);
    // print(contract.address.addressBytes);
    // print(contract.toString());
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

    print("Submit ========= $result ==========");

    return result;
  }

  convertSHA256(String filename) {
    var bytes = utf8.encode(filename); // data being hashed
    var digest = sha256.convert(bytes);
    // print("Digest as bytes: ${digest.bytes}");
    // print("Digest as hex string: $digest");

    return "0x$digest";
  }

  //
  Future writeRecord(dynamic hashValue, String signature) async {
    dynamic result = await submit("writeRecord", [hashValue, signature]);

    // print('======== ${result} ========');
  }

  //
  Future<dynamic> getRecord(dynamic hashValue) async {
    List<dynamic> result = await query("getRecord", [hashValue]);

    print('======== ${result} ========');

    return result[0];
  }

  Future<dynamic> checkExistence(dynamic hashValue) async {
    List<dynamic> result = await query("checkExistence", [hashValue]);

    // print('Existence ===== ${result[0]} ========');

    return result[0];
  }

  statusDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6.0))),
          contentPadding: EdgeInsets.zero,
          //title: Center(child: Text("Picture")),
          content: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              //color: Colors.white,

              //padding: EdgeInsets.all(5),
              //padding: EdgeInsets.all(10),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  //
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Text(message),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(6.0),
                            bottomRight: Radius.circular(6.0),
                          ),
                          color: Colors.lightBlue[800]),
                      alignment: Alignment.center,
                      height: 50,
                      //color: primaryColor,
                      child: Text(
                        "Okay",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        hintText: "Filename",
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                        labelText: "Filename",
                      ),
                      validator: (val) =>
                          val.isEmpty ? 'Write something' : null,
                      onChanged: (val) {
                        setState(() => filename = val);
                      },
                    ),
                  ),
                  // Container(
                  //   padding: EdgeInsets.symmetric(vertical: 10.0),
                  //   child: TextFormField(
                  //     decoration: InputDecoration(
                  //       border: UnderlineInputBorder(),
                  //       hintText: "Comment",
                  //       hintStyle: TextStyle(
                  //         color: Colors.grey[400],
                  //         fontSize: 14,
                  //       ),
                  //       labelText: "Comment",
                  //     ),
                  //     validator: (val) =>
                  //         val.isEmpty ? 'Write something' : null,
                  //     onChanged: (val) {
                  //       setState(() => comment = val);
                  //     },
                  //   ),
                  // ),
                  Container(
                    padding: EdgeInsets.only(
                      top: 25.0,
                    ),
                    width: double.infinity,
                    child: RaisedButton(
                      //elevation: 5.0,
                      elevation: 0.0,
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          dynamic hashValue = convertSHA256(filename);
                          print(hashValue);
                          print("Checking existence");
                          bool isExisted = await checkExistence(hashValue);
                          print("Proceed Record");
                          await writeRecord(hashValue, filename);

                          if (isExisted) {
                            statusDialog(
                                context, "Your document is already existed");
                          } else {
                            statusDialog(context,
                                "Your document will be included in the transaction");
                          }
                        } else {
                          print("Invalidated");
                        }
                      },
                      padding: EdgeInsets.all(15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: Colors.lightBlue[800],
                      child: Text(
                        "Upload",
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 1.5,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: 25.0,
                    ),
                    width: double.infinity,
                    child: RaisedButton(
                      //elevation: 5.0,
                      elevation: 0.0,
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          dynamic hashValue = convertSHA256(filename);
                          print(hashValue);
                          dynamic result = await getRecord(hashValue);
                          if (result.isEmpty) {
                            statusDialog(context, "No file $filename");
                          } else {
                            statusDialog(context, "The file $result exists");
                          }
                        } else {
                          print("Invalidated");
                        }
                      },
                      padding: EdgeInsets.all(15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: Colors.lightBlue[800],
                      child: Text(
                        "Check",
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 1.5,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
