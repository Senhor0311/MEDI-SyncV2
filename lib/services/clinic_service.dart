import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medisync/models/clinic_model.dart';

class ClinicService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _clinicsCollection = FirebaseFirestore.instance.collection('clinics');

  /// Fetches a stream of all clinics
  Stream<List<ClinicModel>> getClinics() {
    return _clinicsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => ClinicModel.fromFirestore(doc)).toList();
    });
  }

  /// Creates a new clinic
  Future<void> createClinic({
    required String name,
    required String address,
    String? phoneNumber,
  }) async {
    await _clinicsCollection.add({
      'name': name,
      'address': address,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Updates an existing clinic
  Future<void> updateClinic({
    required String clinicId,
    required String name,
    required String address,
    String? phoneNumber,
  }) async {
    await _clinicsCollection.doc(clinicId).update({
      'name': name,
      'address': address,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Deletes a clinic
  Future<void> deleteClinic(String clinicId) async {
    await _clinicsCollection.doc(clinicId).delete();
  }

  /// Gets a single clinic by ID
  Future<ClinicModel?> getClinic(String clinicId) async {
    final doc = await _clinicsCollection.doc(clinicId).get();
    if (doc.exists) {
      return ClinicModel.fromFirestore(doc);
    }
    return null;
  }

  /// Gets clinic name by ID (useful for displaying clinic names)
  Future<String> getClinicName(String clinicId) async {
    try {
      final doc = await _clinicsCollection.doc(clinicId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>?;
        return data?['name'] ?? 'Unknown Clinic';
      }
      return 'Unknown Clinic';
    } catch (e) {
      print('Error fetching clinic name: $e');
      return 'Unknown Clinic';
    }
  }
}