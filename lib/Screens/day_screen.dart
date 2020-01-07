import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:werd/auth.dart';

class Day extends StatefulWidget {
  @override
  _DayState createState() => _DayState();
}

class _DayState extends State<Day> {
  List<bool> myValues = [false, false, false, false];
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
        child: StreamBuilder<QuerySnapshot>(
          stream: FireStoring.chatRoomStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Text('hi');
            else {
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
      bottomSheet: RaisedButton(
        color: Colors.blue,
        onPressed: () {
          FireStoring().send(this.prayerValues);
          FireStoring().sendAgain(this.myValues);
        },
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
