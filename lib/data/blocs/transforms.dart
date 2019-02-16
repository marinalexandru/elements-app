import 'dart:async';

import 'package:elements/data/errors/app_error.dart';
import 'package:validate/validate.dart';

class Transforms {
  StreamTransformer<String, String> get emailValidationTransform =>
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
        if (!RegExp(Validate.PATTERN_EMAIL).hasMatch(email)) {
          sink.addError(AppError(code:ErrorCode.invalidEmail));
          return;
        }
        sink.add(email);
      });

  StreamTransformer<String, String> get passwordValidationTransform =>
      StreamTransformer<String, String>.fromHandlers(
          handleData: (password, sink) {
        if ((password.length < 6)) {
          sink.addError(AppError(code:ErrorCode.passwordLength));
          return;
        }
        sink.add(password);
      });

  StreamTransformer<T, bool> toSuccessStateStreamTransform<T>() =>
      StreamTransformer<T, bool>.fromHandlers(
        handleData: (_, sink) {
          sink.add(true);
        },
        handleError: (error, trace, sink) {
          sink.add(false);
        },
      );

}
