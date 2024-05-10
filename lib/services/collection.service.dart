import 'package:bapp/models/collection.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CollectionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new collection
  Future<void> addCollection(CollectionModel collection) async {
    await _firestore.collection('collections').add(collection.toMap());
  }

  // Retrieve all collections for a specific user
  Future<List<CollectionModel>> getCollections(String userId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('collections')
        .where('userId', isEqualTo: userId)
        .get();

    return querySnapshot.docs
        .map((doc) => CollectionModel.fromDocumentSnapshot(doc))
        .toList();
  }
}
