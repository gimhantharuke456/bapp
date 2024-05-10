import 'package:bapp/models/delivery.address.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryDetailsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add new delivery details
  Future<void> addDeliveryDetails(DeliveryDetails details) async {
    await _firestore.collection('deliveryDetails').add(details.toMap());
  }

  // Retrieve delivery details by user ID
  Future<List<DeliveryDetails>> getDeliveryDetailsByUserId(
      String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('deliveryDetails')
          .where('userId', isEqualTo: userId)
          .get();

      return querySnapshot.docs
          .map((doc) => DeliveryDetails.fromDocumentSnapshot(doc))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Update existing delivery details
  Future<void> updateDeliveryDetails(
      String docId, DeliveryDetails details) async {
    await _firestore
        .collection('deliveryDetails')
        .doc(docId)
        .update(details.toMap());
  }

  // Delete delivery details
  Future<void> deleteDeliveryDetails(String docId) async {
    await _firestore.collection('deliveryDetails').doc(docId).delete();
  }
}
