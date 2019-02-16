import 'dart:async';
import 'package:elements/data/bloc_provider.dart';
import 'package:elements/data/blocs/transforms.dart';
import 'package:elements/data/errors/app_error.dart';
import 'package:rxdart/rxdart.dart';

class RegisterValidationBloc extends BlocBase with Transforms {
  final BehaviorSubject<String> _emailSubject = BehaviorSubject();
  final BehaviorSubject<String> _passwordSubject = BehaviorSubject();
  final BehaviorSubject<String> _repeatPasswordSubject = BehaviorSubject();

  Sink<String> get emailSink => _emailSubject.sink;

  Sink<String> get passwordSink => _passwordSubject.sink;

  Sink<String> get repeatPasswordSink => _repeatPasswordSubject.sink;

  Stream<bool> get enabled =>
      CombineLatestStream.list([email, password, repeatPassword])
          .transform(toSuccessStateStreamTransform<List<String>>());

  Stream<String> get email =>
      _emailSubject.stream.transform(emailValidationTransform);

  Stream<String> get password =>
      _passwordSubject.stream.transform(passwordValidationTransform);

  Stream<String> get repeatPassword => _repeatPasswordSubject.stream
          .transform(passwordValidationTransform)
          .doOnData((rp) {
        if (rp != _passwordSubject.value) {
          _repeatPasswordSubject
              .addError(AppError(code: ErrorCode.passwordMatch));
        }
      });

  @override
  void dispose() async {
    _emailSubject.value = null;
    _passwordSubject.value = null;
    _repeatPasswordSubject.value = null;

    await _emailSubject.drain();
    await _passwordSubject.drain();
    await _repeatPasswordSubject.drain();

    _emailSubject.close();
    _passwordSubject.close();
    _repeatPasswordSubject.close();
  }
}
