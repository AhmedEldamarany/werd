import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth.dart';

class FireStoring {
  //region fields
  static Firestore _myFireStore = Firestore.instance;
  String _pathToDay;
  String _pathToWeek;
  static String gn_myId = '';
  String doc;
  int today;
  static Auth myAuth = Auth();
  DateTime myDate = DateTime.now();

  FireStoring() {
    today = myDate.weekday;
    _pathToDay = '/UserId/Week/$today';
    _pathToWeek = '/UserId';
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

  Stream<QuerySnapshot> dayStream() {
    return _myFireStore.collection(_pathToDay).snapshots();
  }

  Stream<QuerySnapshot> weekStream() {
    _myFireStore.document().snapshots();
    return _myFireStore.collection(_pathToWeek).snapshots();
  }
//endregion
}
