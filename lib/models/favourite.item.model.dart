import 'package:cloud_firestore/cloud_firestore.dart';

class FavouriteItemModel {
  final String? id;
  final String itemId;
  final String userId;
  int quantity; // Adding quantity as an integer field
  String collectionId;
  FavouriteItemModel(
      {this.id,
      required this.itemId,
      required this.userId,
      this.quantity = 1, // Default quantity set to 1
      this.collectionId = "all"});

  set setQty(int qty) => quantity = qty;
  set setCollection(String id) => collectionId = id;
  // Factory method to create a FavouriteItemModel from a Firestore DocumentSnapshot
  factory FavouriteItemModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return FavouriteItemModel(
        id: doc.id,
        itemId: data['itemId'] ??
            '', // Use empty string as default if itemId is null
        userId: data['userId'] ??
            '', // Use empty string as default if userId is null
        quantity: data['quantity']?.toInt() ?? 1,
        collectionId: data['collectionId'] ?? 'all');
  }

  // Method to convert the FavouriteItemModel instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'userId': userId,
      'quantity': quantity,
      'collectionId': collectionId
    };
  }
}
