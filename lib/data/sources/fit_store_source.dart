import 'dart:async';

import 'package:elements/data/errors/app_error.dart';
import 'package:flutter/services.dart';

// Channel description
const fitChannel = const MethodChannel('com.marinalexandru.elements/fitSteps');
const methodConnect = 'connect';
const methodGetTotalStepsFrom = 'getTotalStepsFrom';
const methodGetTodaySteps = 'getTodaySteps';
const methodGetDailyWeekSteps = 'getDailyWeekSteps';
const methodSubscribe = 'subscribe';
const methodIsSubscribed = 'isSubscribed';
const callbackConnected = 'connected';
const argFrom = 'from';

class FitStoreSource {
  StreamController<bool> _connectedStreamController = StreamController();

  Stream<bool> get connected => _connectedStreamController.stream;

  FitStoreSource() {
    fitChannel.setMethodCallHandler((MethodCall call) {
      switch (call.method) {
        case callbackConnected:
          _connectedStreamController.sink.add(call.arguments);
          break;
        default:
      }
    });
  }

  Future<void> connect() async {
    try {
      await fitChannel.invokeMethod(methodConnect);
    } on PlatformException catch (e) {
      throw AppError(code: ErrorCode.fitConnectError, originalError: e);
    }
  }

  Future<bool> subscribe() async {
    try {
      return await fitChannel.invokeMethod(methodSubscribe);
    } on PlatformException catch (e) {
      throw AppError(code: ErrorCode.fitSubscribeError, originalError: e);
    }
  }

  Future<bool> isSubscribed() async {
    try {
      return await fitChannel.invokeMethod(methodIsSubscribed);
    } on PlatformException catch (e) {
      throw AppError(code: ErrorCode.fitIsSubscribedError, originalError: e);
    }
  }

  Future<String> getTodaySteps() async {
    try {
      return await fitChannel.invokeMethod(methodGetTodaySteps);
    } on PlatformException catch (e) {
      throw AppError(code: ErrorCode.fitGetStepsError, originalError: e);
    }
  }

  Future<String> getTotalStepsFrom(String from) async {
    try {
      return await fitChannel.invokeMethod(
        methodGetTotalStepsFrom,
        <String, dynamic>{
          argFrom: from,
        },
      );
    } on PlatformException catch (e) {
      throw AppError(code: ErrorCode.fitGetStepsError, originalError: e);
    }
  }

  Future<List<dynamic>> getDailyWeekSteps() async {
    try {
      return await fitChannel.invokeMethod(methodGetDailyWeekSteps);
    } catch (e) {
      throw AppError(code: ErrorCode.fitGetStepsError, originalError: e);
    }
  }

  void dispose() {
    _connectedStreamController.close();
  }
}
