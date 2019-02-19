import 'dart:async';

import 'package:elements/data/errors/app_error.dart';
import 'package:elements/data/models/user_steps.dart';
import 'package:elements/data/sources/fire_auth_source.dart';
import 'package:elements/data/sources/fire_store_source.dart';
import 'package:elements/data/sources/fit_store_source.dart';
import 'package:rxdart/rxdart.dart';

class StepsRepository {
  final _fitStoreSource = FitStoreSource();
  final _fireAuthSource = FireAuthSource();
  final _fireStoreSource = FireStoreSource();
  final BehaviorSubject<UserSteps> _userStepsSubject =
      BehaviorSubject<UserSteps>();

  StreamSubscription<UserSteps> _subscription;

  Stream<UserSteps> get userSteps => _userStepsSubject.stream;

  Stream<bool> get connected =>
      _fitStoreSource.connected.transform(fitTransform);

  StepsRepository() {
    _fireAuthSource.currentUser().then((user) {
      _subscription = _fireStoreSource.getUserSteps(user.userId).listen(
        (UserSteps userSteps) {
          _userStepsSubject.sink.add(userSteps);
        },
      );
    });
  }

  Future<int> getGoogleFitStepsFrom(DateTime from) async {
    String stepsAsString = await _fitStoreSource
        .getTotalStepsFrom(from.millisecondsSinceEpoch.toString());
    return int.parse(stepsAsString);
  }

  Future<List> getGoogleFitLastWeekSteps() async {
    var weeklySteps = await _fitStoreSource.getDailyWeekSteps();
    var todaySteps = await _fitStoreSource.getTodaySteps();
    weeklySteps[0] = todaySteps;
    return weeklySteps;
  }

  Future<void> setSteps(int active, int consumed) async {
    var user = await _fireAuthSource.currentUser();
    await _fireStoreSource.setSteps(
      user,
      active,
      consumed,
      DateTime.now(),
      await getGoogleFitLastWeekSteps(),
    );
  }

  Future<void> connect() => _fitStoreSource.connect();

  StreamTransformer<bool, bool> get fitTransform =>
      StreamTransformer<bool, bool>.fromHandlers(
        handleData: (connected, sink) async {
          if (!connected) {
            sink.addError(AppError(code: ErrorCode.fitConnectError));
            return;
          }
          bool subscribed = await _fitStoreSource.isSubscribed();
          if (!subscribed) {
            subscribed = await _fitStoreSource.subscribe();
          }
          if (!subscribed) {
            sink.addError(AppError(code: ErrorCode.fitSubscribeError));
            return;
          }
          sink.add(true);
        },
      );

  void dispose() {
    _subscription.cancel();
    _fitStoreSource.dispose();
    _userStepsSubject.close();
  }
}
