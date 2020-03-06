import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth.dart';

class FireStoring {
  //region fields
  static Firestore _myFireStore = Firestore.instance;
  String _pathToDay;
  String _pathToWeek;
  String _dbWeek = 'Week';
  String _dbDayTotal = 'dayTotal';
  String _dbPrayers = 'prayers';
  String _dbWerds = 'werds';

  int today;
  static Auth myAuth = Auth();
  DateTime myDate = DateTime.now();
  String userId;
  String _pathToWeeklyAvg;

  FireStoring(String userID) {
    userId = userID;
    today = myDate.weekday;
    _pathToDay = 'Users/$userId/data/$_dbWeek/$today';
    _pathToWeek = '/Users/$userId/data';
    _pathToWeeklyAvg = 'Users';
  }
//endregion

//region  Methods
  int getToday() {
    return today;
  }

//todo implement the Auth object
  String myUId() {}
  updatePrayers(List<int> prayers) {
    for (int j = 0; j < prayers.length; j++) {
      int i = prayers[j];
      _myFireStore
          .collection(_pathToDay)
          .document(_dbPrayers)
          .setData({'$j': i}, merge: true);
    }
  }

  updateWerds(List<bool> prayers) {
    for (int j = 0; j < prayers.length; j++) {
      bool i = prayers[j];
      _myFireStore
          .collection(_pathToDay)
          .document(_dbWerds)
          .setData({'$j is': i}, merge: true);
    }
  }

  void setDayTotale(int dayTotal) async {
    await _myFireStore
        .collection(_pathToDay)
        .document(_dbDayTotal)
        .setData({_dbDayTotal: dayTotal});
  }

  void setWeekAverage() async {
    double myAvg = await _calculateWeekAvg();
    _myFireStore
        .collection(_pathToWeeklyAvg)
        .document(userId)
        .setData({'avg': myAvg});
  }

  Future<double> _calculateWeekAvg() async {
    int n = 0;
    int sum = 0;

    for (int i = 1; i <= 7; i++) {
      try {
        DocumentSnapshot snapshot = await _myFireStore
            .collection(_pathToWeek)
            .document(_dbWeek)
            .collection('$i')
            .document(_dbDayTotal)
            .get();
        int shit = snapshot.data[_dbDayTotal];
//        print('$shit in $i n is $n');
        if (shit != 0) {
          n++;
          sum += shit;
        }
      } catch (e) {
//        print('errors lol in $i n is $n ');
      }
    }

    return num.parse((sum / n).toStringAsFixed(2));
  }

  Stream<QuerySnapshot> dayStream() {
    return _myFireStore.collection(_pathToDay).snapshots();
  }

  Stream<QuerySnapshot> weekStream() {
    return _myFireStore
        .collection(_pathToWeeklyAvg)
        .orderBy('avg', descending: true)
        .snapshots();
  }

//endregion
}
