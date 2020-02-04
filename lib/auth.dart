import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  static final _myAuth = FirebaseAuth.instance;
  static AuthResult result;
  static FirebaseUser _user;

//TODO result is always NOT NULL which makes it useless [somehow] user
// result.user instead

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
      print('auth says ::: $e');
      return false;
    }
  }

  static Future<String> getCurrentUser() async {
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
