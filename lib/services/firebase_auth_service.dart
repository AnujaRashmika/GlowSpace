import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = UserModel(
      uid: credential.user!.uid,
      name: name,
      email: email,
      phone: phone,
      createdAt: DateTime.now(),
    );

    await _db.collection('users').doc(user.uid).set({
      ...user.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    });

    await credential.user!.updateDisplayName(name);
    return user;
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final doc = await _db.collection('users').doc(credential.user!.uid).get();
    if (doc.exists) {
      return UserModel.fromFirestore(doc.data()!, doc.id);
    }

    // Fallback if user doc missing
    return UserModel(
      uid: credential.user!.uid,
      name: credential.user!.displayName ?? '',
      email: credential.user!.email ?? email,
    );
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
