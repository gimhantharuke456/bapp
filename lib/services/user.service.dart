import 'package:bapp/models/user.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create or Update User
  Future<void> saveUser(UserModel user) async {
    String? userId = _auth.currentUser?.uid;
    if (userId != null) {
      await _firestore.collection('users').doc(userId).set(user.toMap());
    } else {
      throw Exception("No authenticated user found.");
    }
  }

  // Read User
  Future<UserModel?> getUser() async {
    String? userId = _auth.currentUser?.uid;
    if (userId != null) {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromDocumentSnapshot(doc);
      } else {
        throw Exception("User not found.");
      }
    } else {
      throw Exception("No authenticated user found.");
    }
  }

  // Delete User
  Future<void> deleteUser() async {
    String? userId = _auth.currentUser?.uid;
    if (userId != null) {
      await _firestore.collection('users').doc(userId).delete();
    } else {
      throw Exception("No authenticated user found.");
    }
  }
}
