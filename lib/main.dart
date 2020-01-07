import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Screens/loginScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Werd',
      theme: ThemeData(),
      home: LoginScreen(),
    );
  }
}

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  List<bool> myValues = [false, false, false, false, false];
  List<int> prayerValues = [0, 0, 0, 0, 0];

  bool showPrayers = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff092257),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Day 1',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20),
        //margin: EdgeInsets.only(top: 80),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topRight: Radius.circular(120)),
        ),
        child: ListView(
          children: <Widget>[
            prayerListTile(),
            myListTile('ورد القرآن', 1),
            myListTile('قيام الليل', 2),
            myListTile('أذكار الصباح', 3),
            myListTile('أذكار المساء', 4),
          ],
        ),
      ),
    );
  }

  CheckboxListTile myListTile(String title, int hisVal, {fontsize = 22.0}) {
    return CheckboxListTile(
      activeColor: Colors.white,
      checkColor: Colors.green,
      selected: myValues[hisVal],
      onChanged: (val) {
        setState(() {
          myValues[hisVal] = val;
        });
      },
      value: myValues[hisVal],
      subtitle: Text(
        'very Important',
        style: TextStyle(color: Colors.indigo, fontSize: 12),
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.indigo, fontSize: fontsize),
      ),
    );
  }

  ListTile prayerListTile() {
    return ListTile(
      subtitle: showPrayers
          ? Column(
              children: <Widget>[
                thePrayer(0),
                thePrayer(1),
                thePrayer(2),
                thePrayer(3),
                thePrayer(4),
              ],
            )
          : null,
      onTap: () {
        setState(() {
          if (showPrayers)
            showPrayers = false;
          else
            showPrayers = true;
        });
      },
      title: Text(
        'الصلاة',
        style: TextStyle(color: Colors.indigo, fontSize: 22),
      ),
    );
  }

  thePrayer(int thisPrayer) {
    return ListTile(
      title: Text('Fajr'),
      trailing: Row(
        children: <Widget>[
          Text('جماعة'),
          Radio(
            value: 28,
            groupValue: prayerValues[thisPrayer],
            onChanged: (v) {
              setState(() {
                prayerValues[thisPrayer] = v;
              });
            },
          ),
          Text('فذ'),
          Radio(
            value: 1,
            groupValue: prayerValues[thisPrayer],
            onChanged: (v) {
              setState(() {
                prayerValues[thisPrayer] = v;
              });
            },
          ),
        ],
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }
}
