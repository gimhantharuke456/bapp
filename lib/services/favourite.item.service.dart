import 'package:bapp/models/favourite.item.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavouriteItemService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new favourite item
  Future<void> addFavouriteItem(FavouriteItemModel favouriteItem) async {
    await _firestore
        .collection('favouriteItems')
        .doc()
        .set(favouriteItem.toMap());
  }

  // Retrieve all favourite items for a specific user
  Future<List<FavouriteItemModel>> getFavouriteItems(String userId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('favouriteItems')
        .where('userId', isEqualTo: userId)
        .get();

    List<FavouriteItemModel> items = querySnapshot.docs
        .map((doc) => FavouriteItemModel.fromDocumentSnapshot(doc))
        .toList();
    return items;
  }

  // Update a favourite item
  Future<void> updateFavouriteItem(
      String docId, FavouriteItemModel favouriteItem) async {
    await _firestore
        .collection('favouriteItems')
        .doc(docId)
        .update(favouriteItem.toMap());
  }

  // Delete a favourite item
  Future<void> deleteFavouriteItem(String docId) async {
    await _firestore.collection('favouriteItems').doc(docId).delete();
  }
}
