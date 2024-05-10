import 'package:cloud_firestore/cloud_firestore.dart';

class CartItemModel {
  final String? id;
  final String itemId;
  final String userId;
  int quantity;
  final double price; // Price per item

  CartItemModel({
    this.id,
    required this.itemId,
    required this.userId,
    this.quantity = 1,
    required this.price,
  });

  set setQty(int qty) => quantity = qty;

  // Factory method to create a CartItemModel from a Firestore DocumentSnapshot
  factory CartItemModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return CartItemModel(
      id: doc.id,
      itemId: data['itemId'] ?? '',
      userId: data['userId'] ?? '',
      quantity: data['quantity']?.toInt() ?? 1,
      price: data['price']?.toDouble() ?? 0.0,
    );
  }

  // Method to convert the CartItemModel instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'userId': userId,
      'quantity': quantity,
      'price': price,
    };
  }
}
