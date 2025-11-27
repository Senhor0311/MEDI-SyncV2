import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Future<bool> registerUser({
    required String email,
    required String password,
    required String name,
    required String role,
    required String phoneNumber,
    String? specialty, // ADD THIS PARAMETER
  }) async {
    try {
      print('🔄 Starting registration for: $email');

      // Create user in Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        print('❌ User is null after registration');
        return false;
      }

      print('✅ Firebase Auth user created: ${user.uid}');

      // Create user data for Firestore
      final userData = {
        'uid': user.uid,
        'email': email,
        'name': name,
        'role': role,
        'phoneNumber': phoneNumber,
        if (specialty != null) 'specialty': specialty, // ADD SPECIALTY IF PROVIDED
        'createdAt': FieldValue.serverTimestamp(),
      };

      // Save to Firestore
      await _firestore.collection('users').doc(user.uid).set(userData);

      print('✅ Firestore document created successfully');
      return true;

    } catch (e) {
      print('❌ Registration error: $e');

      // Handle specific errors
      if (e is FirebaseAuthException) {
        print('Firebase Auth Error: ${e.code} - ${e.message}');
      } else if (e is FirebaseException) {
        print('Firestore Error: ${e.code} - ${e.message}');
      }

      return false;
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      print('❌ Sign in error: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}