import 'dart:async';

import 'package:elements/data/bloc_provider.dart';
import 'package:elements/data/blocs/transforms.dart';
import 'package:rxdart/rxdart.dart';

class LoginValidationBloc extends BlocBase with Transforms {

  final BehaviorSubject<String> _emailSubject = BehaviorSubject();
  final BehaviorSubject<String> _passwordSubject = BehaviorSubject();

  Sink<String> get emailSink => _emailSubject.sink;

  Sink<String> get passwordSink => _passwordSubject.sink;

  Stream<bool> get enabled => CombineLatestStream.list([email, password])
      .transform(toSuccessStateStreamTransform<List<String>>());

  Stream<String> get email =>
      _emailSubject.stream.transform(emailValidationTransform);

  Stream<String> get password =>
      _passwordSubject.stream.transform(passwordValidationTransform);

  @override
  void dispose() async {
    await _emailSubject.drain();
    await _passwordSubject.drain();

    _emailSubject.close();
    _passwordSubject.close();
  }
}
