import 'package:firebase_auth/firebase_auth.dart';
import 'package:elements/data/sources/fire_store_source.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class AuthRepository {
  final _fireStoreSource = FireStoreSource();

  Future<void> createUser(String email, String password) async {
    await _fireStoreSource.createUser(email, _hash(password));
  }

  Future<void> signIn(String email, String password) async {
    await _fireStoreSource.signIn(email, _hash(password));
  }

  Future<FirebaseUser> currentUser() async {
    return await _fireStoreSource.currentUser();
  }

  Future<void> signOut() async {
    return await _fireStoreSource.signOut();
  }

  String _hash(String pass) {
    var bytes = utf8.encode(pass);
    return sha256.convert(bytes).toString();
  }
}
