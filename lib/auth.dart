import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  static String _myEmail;
  static final _myAuth = FirebaseAuth.instance;
  static AuthResult result;
  static FirebaseUser user;

//TODO result is always NOT NULL which makes it useless [somehow] user result.user instead

  static signMeUp(
      {String email, String password, String pfpurl, String userName}) async {
    try {
      result = await _myAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      UserUpdateInfo updateInfo;
      updateInfo.photoUrl = pfpurl;
      updateInfo.displayName = userName;
      result.user.updateProfile(updateInfo);
    } catch (e, s) {
      print('auth says : $s');
      return false;
    }
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
      user = await _myAuth.currentUser();
      if (user != null) {
        _myEmail = user.email;

        return user;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static myUserId() async {
    if (user == null) await getCurrentUser();
    return user.uid;
  }

  static getUserId(FirebaseUser user) async {
    return user.uid;
  }

  static Future<void> signOut() async {
    return _myAuth.signOut();
  }
}

class FireStoring {
  //region fields
  static int lastId = -1;
  static Firestore _myFireStore = Firestore.instance;
  static String _pathToMsgs = '/oneToOneChats/vjm1dLfdDrBLsWT0dVix/messages';
  static String _myId = '';
  String doc;

//  FireStoring(this.doc) {}

//endregion

//region  Methods

  pathTomsg() {}

//shouldn't call send uless getCurrentUser is called in auth otherwise it will crash
  send(String mymsg) {
    //no need here
    ++lastId;
    _myFireStore
        .collection(_pathToMsgs)
        .add({'number': lastId, 'sender': Auth.myUserId(), 'text': mymsg});
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
    _myId = Auth.myUserId();
//    final users = await _myFireStore.collection('AllUsers').getDocuments();
//    for (var doc in users.documents) {
//      if (doc.data['name'] == 'ahmed Alla') {
//        _myDocumentId = doc.documentID;
//        return _myDocumentId;
//      }
//    }
//    return null;
  }

  static Stream chatRoomStream(String room) {
    return _myFireStore.collection(room).orderBy('number').snapshots();
  }

//endregion
}
