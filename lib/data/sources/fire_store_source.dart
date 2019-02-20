import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elements/data/models/User.dart';
import 'package:elements/data/models/user_elements.dart';
import 'package:elements/data/models/user_steps.dart';
import 'package:elements/data/sources/fire_store_keys.dart';

class FireStoreSource {
  Firestore _fireStore = Firestore.instance;

  FireStoreSource() {
    _fireStore.settings(
      persistenceEnabled: true,
      timestampsInSnapshotsEnabled: true,
    );
  }

  Future<void> insertUserInDatabase(User user) =>
      _fireStore.collection(FIRE_KEY_USERS).document(user.userId).setData(
        {
          FIRE_KEY_USER_ID: user.userId,
          FIRE_KEY_USER_EMAIL: user.userEmail,
        },
      );

  Stream<UserElements> getUserElements(String userId) => _fireStore
      .collection(FIRE_KEY_ELEMENTS)
      .document(userId)
      .snapshots()
      .transform(_elementSnapshotTransform);

  Stream<UserSteps> getUserSteps(String userId) => _fireStore
      .collection(FIRE_KEY_STEPS)
      .document(userId)
      .snapshots()
      .transform(_stepSnapshotTransform);

  Future<void> setSteps(
          User user, int active, int consumed, DateTime t, List<int> week) =>
      _fireStore.collection(FIRE_KEY_STEPS).document(user.userId).setData(
        {
          FIRE_KEY_ACTIVE_STEPS: active,
          FIRE_KEY_CONSUMED_STEPS: consumed,
          FIRE_KEY_CONSUMED_TIMESTAMP: t,
          FIRE_KEY_WEEK_DAYS: week,
        },
      );

  Future<void> setElements(User u, int water, int earth, int fire, int wind) =>
      _fireStore.collection(FIRE_KEY_ELEMENTS).document(u.userId).setData(
        {
          FIRE_KEY_WATER: water,
          FIRE_KEY_EARTH: earth,
          FIRE_KEY_FIRE: fire,
          FIRE_KEY_WIND: wind,
        },
      );

  StreamTransformer<DocumentSnapshot, UserElements>
      get _elementSnapshotTransform =>
          StreamTransformer<DocumentSnapshot, UserElements>.fromHandlers(
            handleData: (document, sink) {
              if (document == null || document.data == null) {
                sink.add(UserElements());
                return;
              }
              sink.add(
                UserElements(
                  water: document.data[FIRE_KEY_WATER],
                  earth: document.data[FIRE_KEY_EARTH],
                  fire: document.data[FIRE_KEY_FIRE],
                  wind: document.data[FIRE_KEY_WIND],
                ),
              );
            },
          );

  StreamTransformer<DocumentSnapshot, UserSteps> get _stepSnapshotTransform =>
      StreamTransformer<DocumentSnapshot, UserSteps>.fromHandlers(
        handleData: (document, sink) {
          if (document == null || document.data == null) {
            sink.add(UserSteps());
            return;
          }

          sink.add(
            UserSteps(
              activeSteps: document.data[FIRE_KEY_ACTIVE_STEPS],
              consumedSteps: document.data[FIRE_KEY_CONSUMED_STEPS],
              consumedTimestamp: document.data[FIRE_KEY_CONSUMED_TIMESTAMP],
              weekDays: document.data[FIRE_KEY_WEEK_DAYS]
                  .cast<String>()
                  .map((e) => int.parse(e))
                  .toList().cast<int>(),
            ),
          );
        },
      );
}
