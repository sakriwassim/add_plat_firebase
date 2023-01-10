import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';
import 'firestore_controller.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChange => _firebaseAuth.authStateChanges();

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required bool isAdmin,
  }) async {
    final User? user = (await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ))
        .user;
    if (user != null) {
      await Firestore.addUserWithId(
        user.uid,
        UserModel(name: name, isAdmin: isAdmin),
      );
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
