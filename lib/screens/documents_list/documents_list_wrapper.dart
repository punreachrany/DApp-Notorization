import 'package:Notorization/models.dart/notarization_documents.dart';
import 'package:Notorization/screens/documents_list/documents_list.dart';
import 'package:Notorization/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DocumentsListWrapper extends StatefulWidget {
  @override
  _DocumentsListWrapperState createState() => _DocumentsListWrapperState();
}

class _DocumentsListWrapperState extends State<DocumentsListWrapper> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<NotarizationDocuments>>.value(
      value: DatabaseService().notorizationDocuments,
      child: DocumentsList(),
    );
  }
}
