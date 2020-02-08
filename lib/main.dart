import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:werd/Screens/loginScreen.dart';

import 'Screens/day_screen.dart';
import 'auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  var pswd = prefs.get('pswd');
  if (email != null && pswd != null) {
    loggedin = true;
    userId = await Auth.getCurrentUser();
  }
  runApp(MyApp());
}

String userId;
bool loggedin = false;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Werd',
      theme: ThemeData(),
      initialRoute: loggedin ? '/Day' : '/login',
      routes: {
        '/Day': (context) => Day(userId),
        '/login': (context) => LoginScreen()
      },
    );
  }
}
