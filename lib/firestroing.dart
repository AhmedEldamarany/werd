import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth.dart';

class FireStoring {
  //region fields
  static Firestore _myFireStore = Firestore.instance;
  String _pathToDay;
  static String gn_myId = '';
  String doc;
  int today;
  static Auth myAuth = Auth();
  DateTime myDate = DateTime.now();

  FireStoring() {
    today = myDate.weekday;
    _pathToDay = '/UserId/Week/$today';
  }

//endregion

//region  Methods
//todo implement the Auth object
//shouldn't call send unless getCurrentUser is called in auth otherwise it will crash
  updatePrayers(List<int> prayers) {
    for (int j = 0; j < prayers.length; j++) {
      int i = prayers[j];
      _myFireStore
          .collection(_pathToDay)
          .document('prayers')
          .setData({'$j': i}, merge: true);
    }
  }

  updateWerds(List<bool> prayers) {
    for (int j = 0; j < prayers.length; j++) {
      bool i = prayers[j];
      _myFireStore
          .collection(_pathToDay)
          .document('werds')
          .setData({'$j is': i}, merge: true);
    }
  }

  void setDayTotale(int dayTotal) async {
    await _myFireStore
        .collection(_pathToDay)
        .document('dayTotal')
        .setData({'DayTotal': dayTotal});
  }

//  subscribe() async {
//    await for (var snapshot
//        in _myFireStore.collection(_pathToMsgs).snapshots()) {
//      for (var message in snapshot.documents) {}
//    }
//  }

//  createPrivateChat(String hisId) {
//    //remove from here
////needed in this app
//    String doc = '$_myId + $hisId';
//    _myFireStore
//        .collection('OneToOneChats')
//        .document(doc)
//        .setData({'user1': _myId, 'user2': hisId});
//
//    //to be moved to send
////    _pathToMsgs = 'OneToOneChats/$doc/messages';
//  }

  Future<String> myId() async {
//    final users = await _myFireStore.collection('AllUsers').getDocuments();
//    for (var doc in users.documents) {
//      if (doc.data['name'] == 'ahmed Alla') {
//        _myDocumentId = doc.documentID;
//        return _myDocumentId;
//      }
//    }
//    return null;
  }

  Stream<QuerySnapshot> chatRoomStream() {
    return _myFireStore.collection(_pathToDay).snapshots();
  }

//endregion
}
