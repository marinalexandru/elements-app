
import 'package:meta/meta.dart';

class AppError implements Exception {
  AppError({
    @required this.code,
    this.originalError,
  }) : assert(code != null);

  /// An error code.
  final ErrorCode code;

  /// Original error that caused this, possibly null.
  final dynamic originalError;

  @override
  String toString() => 'AppException($code, $originalError)';
}

enum ErrorCode {
  errorUserAlreadyRegistered,
  errorInvalidCredentials,
  invalidEmail,
  passwordLength,
  passwordMatch,
  errorWeakPassword,
  errorAnonymousSignInNotAllowed,
  processingError
}
