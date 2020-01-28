import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:werd/Screens/weekly_report.dart';

import 'Screens/day_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Werd',
      theme: ThemeData(),
      initialRoute: '/Day',
      routes: {'/Day': (context) => Day(), '/Week': (context) => WeekReport()},
    );
  }
}
