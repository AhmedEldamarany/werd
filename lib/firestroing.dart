import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth.dart';

class FireStoring {
  //region fields
  static Firestore _myFireStore = Firestore.instance;
  String _pathToDay;
  String _pathToWeek;
  String dbWeek = 'Week';
  String dbdayTotal = 'dayTotal';
  String dbPrayers = 'prayers';
  String dbWerds = 'werds';
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
          .document(dbPrayers)
          .setData({'$j': i}, merge: true);
    }
  }

  updateWerds(List<bool> prayers) {
    for (int j = 0; j < prayers.length; j++) {
      bool i = prayers[j];
      _myFireStore
          .collection(_pathToDay)
          .document(dbPrayers)
          .setData({'$j is': i}, merge: true);
    }
  }

  void setDayTotale(int dayTotal) async {
    await _myFireStore
        .collection(_pathToDay)
        .document(dbdayTotal)
        .setData({dbdayTotal: dayTotal});
  }

  void setWeekAverage() async {
    double myAvg = await _calculateWeekAvg();
    _myFireStore
        .collection(_pathToWeek)
        .document(dbWeek)
        .setData({'avg': myAvg});
  }

  Future<double> _calculateWeekAvg() async {
    int n = 0;
    int sum = 0;

    for (int i = 1; i <= 7; i++) {
      try {
        DocumentSnapshot snapshot = await _myFireStore
            .collection(_pathToWeek)
            .document('Week')
            .collection('$i')
            .document(dbdayTotal)
            .get();
        int shit = snapshot.data[dbdayTotal];
        print('$shit in $i n is $n');
        if (shit != 0) {
          n++;
          sum += shit;
        }
      } catch (e) {
        print('errors lol in $i n is $n ');
      }
    }
    return sum / n;
  }

  Stream<QuerySnapshot> dayStream() {
    return _myFireStore.collection(_pathToDay).snapshots();
  }

  Stream<QuerySnapshot> weekStream() {
    return _myFireStore.collection(_pathToWeek).snapshots();
  }
//endregion
}
