import 'package:Notorization/models.dart/notarization_documents.dart';
import 'package:Notorization/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DocumentsList extends StatefulWidget {
  @override
  _DocumentsListState createState() => _DocumentsListState();
}

Widget documentsTile(String filename, String transaction, DateTime timestamp) {
  return Column(
    children: [
      Divider(
        color: Colors.white,
      ),
      Container(
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.white),
          // borderRadius: BorderRadius.circular(10),
          color: Colors.grey[900],
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        // margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.file_present,
              size: 50,
              color: Colors.white,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        "$filename",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Container(
                      child: Text(
                        "$transaction",
                        style: TextStyle(
                            // fontSize: 18,
                            // fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),

        // Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: <Widget>[
        //     Container(
        //       padding: EdgeInsets.only(top: 10),
        //       child: Row(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           Expanded(flex: 2, child: Text("Filename : ")),
        //           // SizedBox(width: 10),
        //           Expanded(flex: 4, child: Text("$filename")),
        //         ],
        //       ),
        //     ),
        //     Container(
        //         padding: EdgeInsets.only(top: 10),
        //         child: Row(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             Expanded(flex: 2, child: Text("Transaction : ")),
        //             // SizedBox(width: 10),
        //             Expanded(flex: 4, child: Text("$transaction")),
        //           ],
        //         )),
        //     Container(
        //         padding: EdgeInsets.symmetric(vertical: 10),
        //         child: Text("${timestamp.toString()}")),
        //   ],
        // ),
      ),
    ],
  );
}

class _DocumentsListState extends State<DocumentsList> {
  @override
  Widget build(BuildContext context) {
    final documentsList =
        Provider.of<List<NotarizationDocuments>>(context) ?? [];
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.grey[900],
        centerTitle: true,
        title: Text("Document list"),
      ),
      body: Container(
        color: Colors.grey[900],
        child: ListView.builder(
          itemCount: documentsList.length + 1,
          itemBuilder: (context, index) {
            if (index == documentsList.length) {
              return Divider(
                color: Colors.white,
              );
            }
            return documentsTile(
                documentsList[index].filename,
                documentsList[index].transaction,
                documentsList[index].timestamp);
          },
        ),
      ),
    );
  }
}
