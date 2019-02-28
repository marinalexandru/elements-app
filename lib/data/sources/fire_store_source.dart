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

  Stream<UserElements> userElementsStream(String userId) => _fireStore
      .collection(FIRE_KEY_ELEMENTS)
      .document(userId)
      .snapshots()
      .transform(_elementSnapshotTransform);

  Stream<UserSteps> userStepsStream(String userId) => _fireStore
      .collection(FIRE_KEY_STEPS)
      .document(userId)
      .snapshots()
      .transform(_stepSnapshotTransform);

  Future<UserElements> getUserElements(String userId) => _fireStore
      .collection(FIRE_KEY_ELEMENTS)
      .document(userId)
      .get()
      .then((doc) => _makeUserElementsFromDocumentData(doc));

  Future<UserSteps> getUserSteps(String userId) => _fireStore
      .collection(FIRE_KEY_STEPS)
      .document(userId)
      .get()
      .then((doc) => _makeUserStepsFromDocumentData(doc));

  Future<void> setSteps(
          User user, int active, int consumed, DateTime t, List<int> week) =>
      _fireStore.collection(FIRE_KEY_STEPS).document(user.userId).setData({
        FIRE_KEY_ACTIVE_STEPS: active,
        FIRE_KEY_CONSUMED_STEPS: consumed,
        FIRE_KEY_CONSUMED_TIMESTAMP: t,
        FIRE_KEY_WEEK_DAY1: week[0],
        FIRE_KEY_WEEK_DAY2: week[1],
        FIRE_KEY_WEEK_DAY3: week[2],
        FIRE_KEY_WEEK_DAY4: week[3],
        FIRE_KEY_WEEK_DAY5: week[4],
        FIRE_KEY_WEEK_DAY6: week[5],
        FIRE_KEY_WEEK_DAY7: week[6],
      });

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
              sink.add(_makeUserElementsFromDocumentData(document));
            },
          );

  UserElements _makeUserElementsFromDocumentData(DocumentSnapshot document) {
    if (document == null || document.data == null) {
      return UserElements();
    }
    return UserElements(
      water: document.data[FIRE_KEY_WATER],
      earth: document.data[FIRE_KEY_EARTH],
      fire: document.data[FIRE_KEY_FIRE],
      wind: document.data[FIRE_KEY_WIND],
    );
  }

  StreamTransformer<DocumentSnapshot, UserSteps> get _stepSnapshotTransform =>
      StreamTransformer<DocumentSnapshot, UserSteps>.fromHandlers(
        handleData: (document, sink) {
          sink.add(_makeUserStepsFromDocumentData(document));
        },
      );

  UserSteps _makeUserStepsFromDocumentData(DocumentSnapshot document){
    if (document == null || document.data == null) {
      return UserSteps();
    }
    return UserSteps(
      activeSteps: document.data[FIRE_KEY_ACTIVE_STEPS],
      consumedSteps: document.data[FIRE_KEY_CONSUMED_STEPS],
      consumedTimestamp: document.data[FIRE_KEY_CONSUMED_TIMESTAMP],
      weekDays: [
        document.data[FIRE_KEY_WEEK_DAY1],
        document.data[FIRE_KEY_WEEK_DAY2],
        document.data[FIRE_KEY_WEEK_DAY3],
        document.data[FIRE_KEY_WEEK_DAY4],
        document.data[FIRE_KEY_WEEK_DAY5],
        document.data[FIRE_KEY_WEEK_DAY6],
        document.data[FIRE_KEY_WEEK_DAY7],
      ],
    );
  }
}
