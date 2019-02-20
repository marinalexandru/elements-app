import 'package:elements/data/bloc_provider.dart';
import 'package:elements/data/models/User.dart';
import 'package:elements/data/repositories/auth_repository.dart';
import 'package:rxdart/rxdart.dart';

class AuthBloc extends BlocBase {
  final _repository = AuthRepository();
  final BehaviorSubject<String> _emailSubject = BehaviorSubject();
  final BehaviorSubject<String> _passwordSubject = BehaviorSubject();
  final BehaviorSubject<bool> _authSubject = BehaviorSubject();
  final BehaviorSubject<bool> _loadingSubject = BehaviorSubject();

  Sink<String> get emailSink => _emailSubject.sink;

  Sink<String> get passwordSink => _passwordSubject.sink;

  Stream<bool> get auth => _authSubject.stream;

  Stream<bool> get loading => _loadingSubject.stream;

  AuthBloc() {
    _notify();
  }

  void logout() async {
    _loadingSubject.add(true);
    await _repository.signOut();
    _loadingSubject.add(false);
    _notify();
  }

  void createUser() async {
    _loadingSubject.add(true);
    try {
      await _repository.createUser(_emailSubject.value, _passwordSubject.value);
      _authSubject.add(true);
      _notify();
    } catch (e) {
      _authSubject.addError(e);
    }
    _loadingSubject.add(false);
  }

  void signIn() async {
    _loadingSubject.add(true);
    try {
      await _repository.signIn(_emailSubject.value, _passwordSubject.value);
      _authSubject.add(true);
      _notify();
    } catch (e) {
      _authSubject.addError(e);
    }
    _loadingSubject.add(false);
  }

  void _notify() {
    _repository.currentUser().then((User user) {
      _authSubject.add(user != null);
    });
  }

  @override
  void dispose() async {
    await _authSubject.drain();
    await _loadingSubject.drain();
    await _emailSubject.drain();
    await _passwordSubject.drain();

    _authSubject.close();
    _loadingSubject.close();
    _emailSubject.close();
    _passwordSubject.close();
  }
}
