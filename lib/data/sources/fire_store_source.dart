import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:elements/data/errors/app_error.dart';

const keyEmail = 'email';
const keyPasswordHash = 'passwordHash';
const collectionUsers = 'users';

class FireStoreSource {
  Firestore _fireStore = Firestore.instance;
  FirebaseAuth _fireAuth = FirebaseAuth.instance;

  FireStoreSource() {
    _fireStore.settings(
      persistenceEnabled: true,
      timestampsInSnapshotsEnabled: true,
    );
  }

  Future<FirebaseUser> createUser(String email, String passwordHash) async {
    try {
      return await _fireAuth.createUserWithEmailAndPassword(
          email: email, password: passwordHash);
    } catch (e) {
      throw _transformFireBaseExceptionToAppError(e);
    }
  }

  Future<FirebaseUser> signIn(String email, String passwordHash) async {
    try {
      return await _fireAuth.signInWithEmailAndPassword(
          email: email, password: passwordHash);
    } catch (e) {
      throw _transformFireBaseExceptionToAppError(e);
    }
  }

  Future<FirebaseUser> currentUser() async {
    return await _fireAuth.currentUser();
  }

  Future<void> signOut() async {
    return await _fireAuth.signOut();
  }

  AppError _transformFireBaseExceptionToAppError(e) {
    if (e is PlatformException) {
      switch (e.code) {
        case "ERROR_OPERATION_NOT_ALLOWED":
          return AppError(
              code: ErrorCode.errorAnonymousSignInNotAllowed, originalError: e);
        case "ERROR_EMAIL_ALREADY_IN_USE":
          return AppError(
              code: ErrorCode.errorUserAlreadyRegistered, originalError: e);
        case "ERROR_INVALID_CREDENTIAL":
          return AppError(
              code: ErrorCode.errorInvalidCredentials, originalError: e);
        case "ERROR_WEAK_PASSWORD":
          return AppError(code: ErrorCode.errorWeakPassword, originalError: e);
        case "ERROR_INVALID_EMAIL":
        case "ERROR_USER_NOT_FOUND":
        case "ERROR_WRONG_PASSWORD":
        case "ERROR_USER_DISABLED":
          return AppError(
              code: ErrorCode.errorInvalidCredentials, originalError: e);
        default:
          return AppError(code: ErrorCode.processingError, originalError: e);
      }
    } else {
      return AppError(code: ErrorCode.processingError, originalError: e);
    }
  }
}
