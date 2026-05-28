import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createDeck({
    required String title,
    required String description,
    required String ownerId,
  }) async {
    await _db.collection('decks').add({
      'title': title,
      'description': description,
      'ownerId': ownerId,
      'createdAt': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getDecks() {
    return _db
        .collection('decks')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}