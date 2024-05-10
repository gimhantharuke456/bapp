import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bapp/models/order.model.dart' as o;

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath = 'orders';

  // Add a new order
  Future<void> addOrder(o.Order order) async {
    await _firestore.collection(collectionPath).add(order.toMap());
  }

  // Retrieve all orders by user ID
  Future<List<o.Order>> getOrdersByUserId(String userId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection(collectionPath)
        .where('userId', isEqualTo: userId)
        .get();

    return querySnapshot.docs
        .map((doc) => o.Order.fromDocumentSnapshot(doc))
        .toList();
  }

  // Retrieve a single order by order ID
  Future<o.Order?> getOrderById(String orderId) async {
    DocumentSnapshot doc =
        await _firestore.collection(collectionPath).doc(orderId).get();
    if (doc.exists) {
      return o.Order.fromDocumentSnapshot(doc);
    }
    return null;
  }

  // Update an existing order
  Future<void> updateOrder(String orderId, o.Order order) async {
    await _firestore
        .collection(collectionPath)
        .doc(orderId)
        .update(order.toMap());
  }

  // Delete an order
  Future<void> deleteOrder(String orderId) async {
    await _firestore.collection(collectionPath).doc(orderId).delete();
  }
}
