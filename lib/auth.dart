import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  static final _myAuth = FirebaseAuth.instance;
  static AuthResult result;
  static FirebaseUser _user;

//TODO result is always NOT NULL which makes it useless [somehow] user result.user instead

  static Future<bool> signMeUp({String email, String password}) async {
    try {
      result = await _myAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e, s) {
      print('auth says : $e ANNNDDD $s');
      return false;
    }
    return true;
  }

  static Future<bool> signMeIn(String email, String password) async {
    try {
      result = await _myAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return result != null;
    } catch (e, s) {
      print('auth says ::: $s');
      return false;
    }
  }

  static getCurrentUser() async {
    try {
      _user = await _myAuth.currentUser();
      if (_user != null) {
        return _user.uid;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<void> signOut() async {
    return _myAuth.signOut();
  }
}

class FireStoring {
  //region fields
  static Firestore _myFireStore = Firestore.instance;
  static String _pathToMsgs = '/oneToOneChats/vjm1dLfdDrBLsWT0dVix/messages';
  static String _myId = '';
  String doc;

//  FireStoring(this.doc) {}

//endregion

//region  Methods

  pathTomsg() {}

//shouldn't call send uless getCurrentUser is called in auth otherwise it will crash
  send(List<int> prayers) {
    for (int j = 0; j < prayers.length; j++) {
      int i = prayers[j];
      _myFireStore
          .collection('UserId')
          .document('prayers')
          .setData({'$j': i}, merge: true);
    }
  }

  sendAgain(List<bool> prayers) {
    for (int j = 0; j < prayers.length; j++) {
      bool i = prayers[j];
      _myFireStore.collection('UserId')
        ..document('werds').setData({'$j is': i}, merge: true);
    }
  }

  subscribe() async {
    await for (var snapshot
        in _myFireStore.collection(_pathToMsgs).snapshots()) {
      for (var message in snapshot.documents) {}
    }
  }

  static createPrivateChat(String hisId) {
    //remove from here
//needed in this app
    String doc = '$_myId + $hisId';
    _myFireStore
        .collection('OneToOneChats')
        .document(doc)
        .setData({'user1': _myId, 'user2': hisId});

    //to be moved to send
    _pathToMsgs = 'OneToOneChats/$doc/messages';
  }

  static Future<String> myId() async {
//    final users = await _myFireStore.collection('AllUsers').getDocuments();
//    for (var doc in users.documents) {
//      if (doc.data['name'] == 'ahmed Alla') {
//        _myDocumentId = doc.documentID;
//        return _myDocumentId;
//      }
//    }
//    return null;
  }

  static Stream chatRoomStream() {
    return _myFireStore.collection('UserId').snapshots();
  }

//endregion
}
