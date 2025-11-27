// lib/models/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phoneNumber;
  final String role;
  final String? specialty;
  final String? clinicId;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.role,
    this.specialty,
    this.clinicId,
    required this.createdAt,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      role: data['role'] ?? 'patient',
      specialty: data['specialty'],
      clinicId: data['clinicId'],
      createdAt: (data['createdAt'] as Timestamp? ?? Timestamp.now()).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role,
      if (specialty != null) 'specialty': specialty,
      if (clinicId != null) 'clinicId': clinicId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel && runtimeType == other.runtimeType && uid == other.uid;

  @override
  int get hashCode => uid.hashCode;
}
