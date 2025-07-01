import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socket_io_admin_client/core/constants/app_db_constants.dart';

class FirebaseAuthDataSource {
  // Firebase Auth & Cloud Firestore
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  // Sign Up With Email and Password
  Future<User> signUpWithEmailPassword(
    String userName,
    String email,
    String password,
  ) async {
    final result = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = result.user!;
    final uid = user.uid;

    // add display name
    await user.updateDisplayName(userName);

    // Store data in cloud firestore
    await firebaseFirestore
        .collection(AppDBConstants.userCollection)
        .doc(uid)
        .set({'uid': uid, 'email': email, 'userName': userName});

    return result.user!;
  }

  // Sign In With Email Password
  Future<User> signInWithEmailPassword(String email, String password) async {
    final result = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return result.user!;
  }

  // Forget Password with Email Password
  Future<void> sendPasswordResetEmail(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  // Sign Out
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  /// 📄 Fetch username from Firestore using UID
  Future<String> fetchUsername(String uid) async {
    final doc = await firebaseFirestore.collection('users').doc(uid).get();
    return doc.data()?['username'] ?? '';
  }
}
