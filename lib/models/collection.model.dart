import 'package:cloud_firestore/cloud_firestore.dart';

class CollectionModel {
  final String? id;
  final String name;
  final String userId;

  CollectionModel({
    this.id,
    required this.name,
    required this.userId,
  });

  // Factory method to create a CollectionModel from a Firestore DocumentSnapshot
  factory CollectionModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return CollectionModel(
      id: doc.id,
      name: data['name'] ?? '',
      userId: data['userId'] ?? '',
    );
  }

  // Method to convert the CollectionModel instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'userId': userId,
    };
  }
}
