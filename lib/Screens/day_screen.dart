import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:werd/Screens/weekly_report.dart';
import 'package:werd/firestroing.dart';

import '../constants.dart';

//todo do I need stateful ?
class Day extends StatefulWidget {
  @override
  _DayState createState() => _DayState();
}

class _DayState extends State<Day> {
  List<bool> werdValues = [false, false, false, false];
  List<int> prayerValues = [0, 0, 0, 0, 0];
  FireStoring firestoring = new FireStoring();
  bool showPrayers = false;
  int dayPoints = 0;
  void endTheDay() {
    dayPoints = 0;
    for (int i in prayerValues)
      dayPoints += i;
    for (bool j in werdValues)
      if (j) dayPoints++;
    firestoring.setDayTotale(dayPoints);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Day 1',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: PageView(
        reverse: true,
        children: <Widget>[
          pageOne(),
          WeekReport(),
        ],
      ),
    );
  }

  Container pageOne() {
    return Container(
      padding: EdgeInsets.only(top: 20),
      //margin: EdgeInsets.only(top: 80),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topRight: Radius.circular(120)),
      ),
      child: StreamBuilder<QuerySnapshot>(
        stream: firestoring.dayStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            firestoring.updateWerds(werdValues);
            firestoring.updatePrayers(prayerValues);
            return Text('hi'); //Todo return loading thing
          } else {
            var data = snapshot.data.documents;
            for (var smallData in data) {
              if (smallData.documentID == 'prayers')
                for (int i = 0; i < prayerValues.length; i++) {
                  prayerValues[i] = smallData.data['$i'];
                }
              else if (smallData.documentID == 'werds')
                for (int i = 0; i < werdValues.length; i++) {
                  werdValues[i] = smallData.data['$i is'];
                }
              else
                dayPoints = smallData.data[0];
            }
            endTheDay();
            return ListView(
              children: <Widget>[
                prayerListTile(),
                myListTile('ورد القرآن', 0),
                myListTile('قيام الليل', 1),
                myListTile('أذكار الصباح', 2),
                myListTile('أذكار المساء', 3),
                ListTile(
                  title: Text(
                    'Total   $dayPoints',
                    style: TextStyle(color: Colors.indigo, fontSize: 22),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  CheckboxListTile myListTile(String title, int hisVal, {fontSize = 22.0}) {
    return CheckboxListTile(
      activeColor: Colors.white,
      checkColor: Colors.green,
      selected: werdValues[hisVal],
      onChanged: (val) {
        setState(() {
          werdValues[hisVal] = val;
          firestoring.updateWerds(this.werdValues);
        });
      },
      value: werdValues[hisVal],
      subtitle: Text(
        'very Important',
        style: TextStyle(color: Colors.indigo, fontSize: 12),
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.indigo, fontSize: fontSize),
      ),
    );
  }

  ListTile prayerListTile() {
    return ListTile(
      subtitle: showPrayers
          ? Column(
              children: <Widget>[
                prayerTile(0),
                prayerTile(1),
                prayerTile(2),
                prayerTile(3),
                prayerTile(4),
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

  prayerTile(int thisPrayer) {
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
                firestoring.updatePrayers(this.prayerValues);
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
                firestoring.updatePrayers(this.prayerValues);
              });
            },
          ),
        ],
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }
}
