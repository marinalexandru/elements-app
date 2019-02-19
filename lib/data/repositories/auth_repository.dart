import 'package:elements/data/models/User.dart';
import 'package:elements/data/sources/fire_auth_source.dart';
import 'package:elements/data/sources/fire_store_source.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class AuthRepository {
  final _fireStoreSource = FireStoreSource();
  final _fireStoreAuth = FireAuthSource();

  Future<void> createUser(String email, String password) async {
    var user = await _fireStoreAuth.createUser(email, _hash(password));
    await _fireStoreSource.insertUserInDatabase(user);
  }

  Future<void> signIn(String email, String password) async {
    var user = await _fireStoreAuth.signIn(email, _hash(password));
    await _fireStoreSource.insertUserInDatabase(user);
  }

  Future<User> currentUser() async {
    return await _fireStoreAuth.currentUser();
  }

  Future<void> signOut() async {
    return await _fireStoreAuth.signOut();
  }

  String _hash(String pass) {
    var bytes = utf8.encode(pass);
    return sha256.convert(bytes).toString();
  }
}
