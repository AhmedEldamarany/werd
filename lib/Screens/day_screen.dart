import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:werd/firestroing.dart';

//todo do I need stateful ?
class Day extends StatefulWidget {
  @override
  _DayState createState() => _DayState();
}

class _DayState extends State<Day> {
  List<bool> myValues = [false, false, false, false];
  List<int> prayerValues = [0, 0, 0, 0, 0];
  FireStoring firestoring = new FireStoring();
  bool showPrayers = false;
  final myColor = Color(0xff092257);
  int dayPoints = 0;

  void endTheDay() {
    dayPoints = 0;
    for (int i in prayerValues)
      dayPoints += i;
    for (bool j in myValues)
      if (j) dayPoints++;
    print(dayPoints);
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
      body: Container(
        padding: EdgeInsets.only(top: 20),
        //margin: EdgeInsets.only(top: 80),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topRight: Radius.circular(120)),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: firestoring.chatRoomStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              firestoring.sendAgain(myValues);
              firestoring.send(prayerValues);
              return Text('hi');
            } else {
              var data = snapshot.data.documents;
              for (var smallData in data) {
                if (smallData.documentID == 'prayers')
                  for (int i = 0; i < prayerValues.length; i++) {
                    prayerValues[i] = smallData.data['$i'];
                  }
                else if (smallData.documentID == 'werds')
                  for (int i = 0; i < myValues.length; i++) {
                    myValues[i] = smallData.data['$i is'];
                  }
              }
              return ListView(
                children: <Widget>[
                  prayerListTile(),
                  myListTile('ورد القرآن', 0),
                  myListTile('قيام الليل', 1),
                  myListTile('أذكار الصباح', 2),
                  myListTile('أذكار المساء', 3),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  CheckboxListTile myListTile(String title, int hisVal, {fontSize = 22.0}) {
    return CheckboxListTile(
      activeColor: Colors.white,
      checkColor: Colors.green,
      selected: myValues[hisVal],
      onChanged: (val) {
        setState(() {
          myValues[hisVal] = val;
          firestoring.sendAgain(this.myValues);
        });
      },
      value: myValues[hisVal],
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
                firestoring.send(this.prayerValues);
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
                firestoring.send(this.prayerValues);
              });
            },
          ),
        ],
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }
}
