import 'package:cloud_firestore/cloud_firestore.dart';

class UserSteps {
  final int activeSteps;
  final int consumedSteps;
  final Timestamp consumedTimestamp;
  final List<int> weekDays;

  UserSteps({
    this.activeSteps = 0,
    this.consumedSteps = 0,
    this.consumedTimestamp,
    this.weekDays = const [0, 0, 0, 0, 0, 0, 0],
  });
}
