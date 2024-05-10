import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryDetails {
  final String? id;
  final String home;
  final String city;
  final String district;
  final String userId;

  DeliveryDetails({
    this.id,
    required this.home,
    required this.city,
    required this.district,
    required this.userId,
  });

  // Factory method to create a DeliveryDetails instance from a Firestore DocumentSnapshot
  factory DeliveryDetails.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return DeliveryDetails(
      id: doc.id, // Capture the document ID
      home: data['home'] ?? '', // Default to an empty string if not provided
      city: data['city'] ?? '', // Default to an empty string if not provided
      district:
          data['district'] ?? '', // Default to an empty string if not provided
      userId:
          data['userId'] ?? '', // Default to an empty string if not provided
    );
  }

  // Method to convert the DeliveryDetails instance to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'home': home,
      'city': city,
      'district': district,
      'userId': userId,
    };
  }
}
