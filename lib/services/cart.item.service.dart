import 'package:bapp/models/cart.item.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartItemService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new cart item
  Future<void> addCartItem(CartItemModel cartItem) async {
    await _firestore.collection('cartItems').add(cartItem.toMap());
  }

  // Retrieve all cart items for a specific user
  Future<List<CartItemModel>> getCartItems(String userId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('cartItems')
        .where('userId', isEqualTo: userId)
        .get();

    return querySnapshot.docs
        .map((doc) => CartItemModel.fromDocumentSnapshot(doc))
        .toList();
  }

  // Update a cart item
  Future<void> updateCartItem(String docId, CartItemModel cartItem) async {
    await _firestore
        .collection('cartItems')
        .doc(docId)
        .update(cartItem.toMap());
  }

  // Delete a cart item
  Future<void> deleteCartItem(String docId) async {
    await _firestore.collection('cartItems').doc(docId).delete();
  }
}
