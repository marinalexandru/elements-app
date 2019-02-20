import 'dart:async';

import 'package:elements/data/models/User.dart';
import 'package:elements/data/models/user_elements.dart';
import 'package:elements/data/sources/fire_auth_source.dart';
import 'package:elements/data/sources/fire_store_source.dart';
import 'package:rxdart/rxdart.dart';

class ElementsRepository {
  final _fireAuthSource = FireAuthSource();
  final _fireStoreSource = FireStoreSource();
  final BehaviorSubject<UserElements> _userElementsSubject =
      BehaviorSubject<UserElements>();

  StreamSubscription<UserElements> _subscription;

  Stream<UserElements> get userElements => _userElementsSubject.stream;

  ElementsRepository() {
    _fireAuthSource.currentUser().then((user) {
      _subscription = _fireStoreSource.getUserElementsStream(user.userId).listen(
        (UserElements userSteps) {
          _userElementsSubject.sink.add(userSteps);
        },
      );
    });
  }

  Future<void> saveElements({
    int water = 0,
    int earth = 0,
    int fire = 0,
    int wind = 0,
  }) async {
    User user = await _fireAuthSource.currentUser();
    UserElements dbUserElements = await userElements.last;
    return await _fireStoreSource.setElements(
      user,
      dbUserElements.water + water,
      dbUserElements.earth + earth,
      dbUserElements.fire + fire,
      dbUserElements.wind + wind,
    );
  }

  void dispose() {
    _userElementsSubject.close();
    _subscription.cancel();
  }
}
