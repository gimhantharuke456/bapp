import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String name;
  final String phone;
  final String address;
  final String city;
  final String email;
  final int themeColor;

  UserModel({
    required this.name,
    required this.phone,
    required this.address,
    required this.city,
    required this.email,
    this.themeColor = 0,
  });

  factory UserModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      name: data['name'] ?? 'No Name',
      phone: data['phone'] ?? 'No Phone',
      address: data['address'] ?? 'No Address',
      city: data['city'] ?? 'No City',
      email: data['email'] ?? 'No Email',
      themeColor: data['themeColor'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'address': address,
      'city': city,
      'email': email,
      'themeColor': themeColor,
    };
  }
}
