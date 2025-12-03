import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String username;
  final String displayName;
  final String email;
  final String role; // "chef" or "amateur"
  final DateTime createdAt;
  final bool isVerifiedChef;
  final String? photoUrl;

  UserModel({
    required this.uid,
    required this.username,
    required this.displayName,
    required this.email,
    required this.role,
    required this.createdAt,
    this.isVerifiedChef = false,
    this.photoUrl,
  });

  // Convert to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'displayName': displayName,
      'email': email,
      'role': role,
      'createdAt': Timestamp.fromDate(createdAt),
      'isVerifiedChef': isVerifiedChef,
      'photoUrl': photoUrl,
    };
  }

  // Create from Firestore document
  factory UserModel.fromMap(String uid, Map<String, dynamic> map) {
    return UserModel(
      uid: uid,
      username: map['username'] ?? '',
      displayName: map['displayName'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'amateur',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      isVerifiedChef: map['isVerifiedChef'] ?? false,
      photoUrl: map['photoUrl'],
    );
  }
}