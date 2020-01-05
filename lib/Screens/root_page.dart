import 'package:flutter/material.dart';
import 'package:werd/auth.dart';
import 'package:werd/main.dart';
import 'loginScreen.dart';

class RootPage extends StatefulWidget {
  final Auth auth;

  RootPage({this.auth});

  @override
  State<StatefulWidget> createState() => new RootPageState();
}

enum AuthStatus { out, In }

class RootPageState extends State<RootPage> {
  AuthStatus _authStatus = AuthStatus.out;

  initState() {
    super.initState();
    Auth.getCurrentUser().then((userId) {
      setState(() {
        _authStatus = userId == null ? AuthStatus.out : AuthStatus.In;
      });
    });
  }

  void signedIn() {
    setState(() {
      _authStatus = AuthStatus.In;
    });
  }

  void _signedout() {
    setState(() {
      _authStatus = AuthStatus.out;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_authStatus) {
      case AuthStatus.out:
        return LoginScreen(auth: widget.auth, signedIn: signedIn);
      case AuthStatus.In:
//        return MyApp(
//          auth: widget.auth,
//          signedOut: _signedout,
//        );
    }
  }
}
