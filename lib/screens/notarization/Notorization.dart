import 'dart:convert';
import 'dart:io';

import 'package:Notorization/services/database.dart';
import 'package:Notorization/themes/colors.dart';
import 'package:crypto/crypto.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:Notorization/blockchain_constant.dart' as Blockchain;
import 'package:path/path.dart' as FilePath;

class Notorization extends StatefulWidget {
  @override
  _NotorizationState createState() => _NotorizationState();
}

class _NotorizationState extends State<Notorization> {
  Client httpClient;
  Web3Client ethClient;

  bool data = false;

  //
  final _formKey = GlobalKey<FormState>();

  //
  final myAddress = Blockchain.metamask_address;
  String txHash;

  //
  File file;
  String filename;
  String fileHashValue;
  String transactionAccepted;

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

    setState(() {
      transactionAccepted = result;
    });

    return result;
  }

  convertSHA256(String filename) {
    var bytes = utf8.encode(filename); // data being hashed
    var digest = sha256.convert(bytes);

    // Hash File
    // File file = ;
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
                          color: primaryColor),
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
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.grey[900],
        centerTitle: true,
        title: Text("Notarization"),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(
                    top: 25.0,
                  ),
                  width: double.infinity,
                  child: RaisedButton(
                    //elevation: 5.0,
                    elevation: 0.0,
                    onPressed: () async {
                      //Without parameters:
                      final path = await FlutterDocumentPicker.openDocument();

                      setState(() {
                        file = File(path);
                        filename = FilePath.basename(path);
                      });

                      Digest digest = await sha256.bind(file.openRead()).first;

                      setState(() {
                        fileHashValue = "0x" + digest.toString();
                      });

                      print("====== Uploading and hashing are done ======");
                      print(path);
                      print(filename);
                      print(fileHashValue);
                    },
                    padding: EdgeInsets.all(15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: primaryColor,
                    child: Text(
                      "Choose File",
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
                      try {
                        if (filename != null && file != null) {
                          // dynamic hashValue = convertSHA256(filename);
                          // print(hashValue);
                          print("HashValue : $fileHashValue");
                          print("Checking existence");
                          bool isExisted = await checkExistence(fileHashValue);
                          print("Proceed Record");

                          await writeRecord(fileHashValue, filename);

                          if (isExisted) {
                            dynamic transaction =
                                await getRecord(fileHashValue);
                            statusDialog(context,
                                "Your document is already existed. Check $transaction");
                          } else {
                            statusDialog(context,
                                "$filename will be included in the transaction");

                            // TODO : Post into Firebase
                            // Filename, Transaction, Timestamp
                            // dynamic transaction =
                            //     await getRecord(fileHashValue);

                            await DatabaseService().addNotarizationDocument(
                                filename, transactionAccepted, DateTime.now());
                          }
                        } else {
                          statusDialog(context, "NO FILE");
                        }
                      } catch (e) {
                        print(e.toString());
                        dynamic result = await getRecord(fileHashValue);
                        statusDialog(context,
                            "Your document is already existed. Check $result");
                      }
                    },
                    padding: EdgeInsets.all(15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: primaryColor,
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
                filename != null && fileHashValue != null
                    ? Container(
                        padding: EdgeInsets.only(
                          top: 25.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.file_present,
                              color: Colors.white,
                            ),
                            SizedBox(width: 20),
                            Text(filename,
                                style: TextStyle(color: Colors.white)),
                            SizedBox(width: 20),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    fileHashValue = null;
                                    filename = null;
                                  });
                                },
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ))
                          ],
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.only(
                          top: 25.0,
                        ),
                        child: Text(
                          "NO FILE",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
