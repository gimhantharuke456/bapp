import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String?
      id; // Optional ID that can be null if not fetched from Firestore
  final List<Map<String, dynamic>>
      itemList; // List of items, each item is a map
  final String home;
  final String city;
  final String district;
  final String userId;

  Order({
    this.id,
    required this.itemList,
    required this.home,
    required this.city,
    required this.district,
    required this.userId,
  });

  // Factory method to create an Order from a Firestore DocumentSnapshot
  factory Order.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Order(
      id: doc.id,
      itemList: List<Map<String, dynamic>>.from(data['itemList']),
      home: data['home'] ?? '',
      city: data['city'] ?? '',
      district: data['district'] ?? '',
      userId: data['userId'] ?? '',
    );
  }

  // Convert the Order instance to a Map for Firestore operations
  Map<String, dynamic> toMap() {
    return {
      'itemList': itemList,
      'home': home,
      'city': city,
      'district': district,
      'userId': userId,
    };
  }
}
