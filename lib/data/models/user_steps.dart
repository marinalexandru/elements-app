import 'package:elements/data/sources/fire_store_keys.dart';

class UserSteps {
  int activeSteps;
  int consumedSteps;
  DateTime consumedTimestamp;
  List<int> weekDays;

  UserSteps({
    this.activeSteps,
    this.consumedSteps,
    this.consumedTimestamp,
    this.weekDays,
  });
}
