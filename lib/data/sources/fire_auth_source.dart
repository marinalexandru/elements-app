import 'package:elements/data/errors/app_error.dart';
import 'package:elements/data/models/User.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class FireAuthSource {
  final FirebaseAuth _fireAuth = FirebaseAuth.instance;

  Future<User> currentUser() async {
    var fireBaseUser = await _fireAuth.currentUser();
    if (fireBaseUser == null) {
      return null;
    }
    return User(
      userEmail: fireBaseUser.email,
      userId: fireBaseUser.uid,
    );
  }

  Future<void> signOut() async {
    return await _fireAuth.signOut();
  }

  Future<User> createUser(String email, String passwordHash) async {
    try {
      var fireBaseUser = await _fireAuth.createUserWithEmailAndPassword(
          email: email, password: passwordHash);
      if (fireBaseUser == null) {
        return null;
      }
      return User(
        userId: fireBaseUser.uid,
        userEmail: fireBaseUser.email,
      );
    } catch (e) {
      throw _transformFireBaseExceptionToAppError(e);
    }
  }

  Future<User> signIn(String email, String passwordHash) async {
    try {
      var fireBaseUser = await _fireAuth.signInWithEmailAndPassword(
          email: email, password: passwordHash);
      if (fireBaseUser == null) {
        return null;
      }
      return User(
        userId: fireBaseUser.uid,
        userEmail: fireBaseUser.email,
      );
    } catch (e) {
      throw _transformFireBaseExceptionToAppError(e);
    }
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
