import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'firestore.dart';

abstract class BaseAuth {
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<String> createUserWithEmailAndPassword(
      String name, String email, String password);
  Future<String> currentUserId();
  Future<void> signOut();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    return user.uid;
  }

  Future<String> createUserWithEmailAndPassword(
      String name, String email, String password) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    FireStore.addUser(user.uid, name, email);

    return user.uid;
  }

  Future<String> currentUserId() async {
    FirebaseUser user = await _firebaseAuth.currentUser();

    return user.uid;
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
