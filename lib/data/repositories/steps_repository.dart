import 'dart:async';

import 'package:elements/data/errors/app_error.dart';
import 'package:elements/data/sources/fit_store_source.dart';

class StepsRepository {
  final _fitStoreSource = FitStoreSource();

  StreamSubscription<bool> _connectedListener;

  StepsRepository() {
    _connectedListener = _fitStoreSource.connected.listen((success) async {
      if (!success) {
        throw AppError(code: ErrorCode.fitConnectError);
      }
      bool subscribed = await _fitStoreSource.isSubscribed();
      if (!subscribed) {
        subscribed = await _fitStoreSource.subscribe();
      }
      if (!subscribed) {
        throw AppError(code: ErrorCode.fitSubscribeError);
      }
      _saveSteps();
    });
  }

  void _saveSteps() async {
    var totalStepsFrom = await _fitStoreSource.getTotalStepsFrom(_oneWeekAgo());
    var weeklySteps = await _fitStoreSource.getDailyWeekSteps();
    var todaySteps = await _fitStoreSource.getTodaySteps();
  }

  Future<void> connect() => _fitStoreSource.connect();

  void dispose() {
    _fitStoreSource.dispose();
    _connectedListener.cancel();
  }

  String _oneWeekAgo() =>
      DateTime.now().add(Duration(days: -6)).millisecondsSinceEpoch.toString();
}
