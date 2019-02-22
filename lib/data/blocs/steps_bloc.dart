import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elements/data/bloc_provider.dart';
import 'package:elements/data/models/user_steps.dart';
import 'package:elements/data/repositories/steps_repository.dart';

class StepsBloc extends BlocBase {
  final _stepsRepository = StepsRepository();

  StreamSubscription<bool> _streamSubscription;

  Stream<List<int>> get userWeekSteps =>
      _stepsRepository.userSteps.transform(_weekTransform);

  Stream<int> get userTotalSteps =>
      _stepsRepository.userSteps.transform(_userTotalStepsTransform);

  Stream<int> get userActiveSteps =>
      _stepsRepository.userSteps.transform(_userActiveStepsTransform);

  StepsBloc() {
    _streamSubscription = _stepsRepository.connected.listen((connected) async {
      await _refreshSteps();
    });
  }

  StreamTransformer<UserSteps, List<int>> get _weekTransform =>
      StreamTransformer<UserSteps, List<int>>.fromHandlers(
        handleData: (UserSteps userSteps, sink) {
          sink.add(userSteps.weekDays);
        },
      );

  StreamTransformer<UserSteps, int> get _userTotalStepsTransform =>
      StreamTransformer<UserSteps, int>.fromHandlers(
        handleData: (UserSteps userSteps, sink) {
          sink.add(userSteps.activeSteps + userSteps.consumedSteps);
        },
      );

  StreamTransformer<UserSteps, int> get _userActiveStepsTransform =>
      StreamTransformer<UserSteps, int>.fromHandlers(
        handleData: (UserSteps userSteps, sink) {
          sink.add(userSteps.activeSteps);
        },
      );

  Future<void> _refreshSteps() async {
    _stepsRepository.userSteps.listen((userSteps) async {
      var timestamp = userSteps.consumedTimestamp;
      int stepsFrom = await _stepsRepository
          .getGoogleFitStepsFrom(timestamp != null ? timestamp : _now());
      int activeSteps = userSteps.activeSteps + stepsFrom;
      await _stepsRepository.setSteps(
        activeSteps,
        userSteps.consumedSteps,
      );
    }).asFuture();
  }

  void connect() => _stepsRepository.connect();

  @override
  void dispose() async {
    _streamSubscription.cancel();
    _stepsRepository.dispose();
  }

  _now() => Timestamp.now();
}
