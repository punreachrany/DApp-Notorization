import 'package:Notorization/screens/notarization/Notorization.dart';
import 'package:Notorization/models.dart/notarization_documents.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  // collection reference
  final CollectionReference documentsCollection =
      FirebaseFirestore.instance.collection('documents');

  Future<void> addNotarizationDocument(
      String filename, String transaction, DateTime timestamp) async {
    return await documentsCollection.add({
      'filename': filename,
      'transaction': transaction,
      'timestamp': timestamp,
    });
  }

  Stream<List<NotarizationDocuments>> get notorizationDocuments {
    return documentsCollection
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map(_documentList);
  }

  List<NotarizationDocuments> _documentList(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      final dataInfo = doc.data();
      return NotarizationDocuments(
        filename: dataInfo['filename'] ?? null,
        transaction: dataInfo['transaction'] ?? null,
        timestamp: dataInfo['timestamp'].toDate() ?? null,
      );
    }).toList();
  }
}
