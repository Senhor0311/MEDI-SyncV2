import 'package:cloud_firestore/cloud_firestore.dart';

class ClinicModel {
  final String id;
  final String name;
  final String address;
  final String? phoneNumber; // Added phone number field

  ClinicModel({
    required this.id,
    required this.name,
    required this.address,
    this.phoneNumber,
  });

  factory ClinicModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    return ClinicModel(
      id: doc.id,
      name: data?['name'] ?? 'Unknown Clinic',
      address: data?['address'] ?? 'No Address',
      phoneNumber: data?['phoneNumber'], // Add phone number
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
    };
  }
}