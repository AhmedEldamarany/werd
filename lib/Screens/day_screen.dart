import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:werd/firestroing.dart';

import '../constants.dart';

//todo do I need stateful ?
class Day extends StatefulWidget {
  static String userId;

  Day(String uID) {
    userId = uID;
  }

  @override
  _DayState createState() => _DayState();
}

FireStoring firestoring = new FireStoring(Day.userId);

class _DayState extends State<Day> {
  List<bool> werdValues = [false, false, false, false];
  List<int> prayerValues = [0, 0, 0, 0, 0];
  bool showPrayers = false;
  int dayPoints = 0;

  //

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
          weekDays[firestoring.getToday() - 1],
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
          print('${snapshot.hasData} is weired');

          if (!snapshot.hasData &&
              snapshot.connectionState != ConnectionState.active) {
            print('nothing');
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData && !snapshot.hasError) {
            print('filling');
            firestoring.updatePrayers(prayerValues);
            firestoring.updateWerds(werdValues);
            return Center(child: CircularProgressIndicator());
          } else {
            print('has data');
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

class WeekReport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(120)),
      ),
      padding: EdgeInsets.only(left: 30, top: 30),
      child: StreamBuilder<QuerySnapshot>(
        stream: firestoring.weekStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Text('wait');
          //todo something to load
          else {
            double myAvg;
            List<MessageBubble> allPeople = List<MessageBubble>();
            var data = snapshot.data.documents;
            for (var smallData in data) {
              print(smallData.documentID);
              myAvg = smallData.data['avg'];
              if (myAvg > 0)
                allPeople.add(MessageBubble(
                  text: '$myAvg',
                  isCurrentUser: true,
                ));
            }
            firestoring.setWeekAverage();

            return ListView(
              children: allPeople,
            );
          }
        },
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.text, this.sender, this.isCurrentUser, this.id});

  final MainAxisAlignment myAlignment = MainAxisAlignment.end;
  final MainAxisAlignment hisAlignment = MainAxisAlignment.start;
  final id;
  final String text, sender;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isCurrentUser ? myAlignment : hisAlignment,
      children: <Widget>[
        Container(
//          transform: Matrix4.rotationZ(isCurrentUser ? 0.1 : -0.1),
          child: Text(
            text,
            style: TextStyle(
                color: isCurrentUser ? KmyColors[0] : KmyColors[5],
                fontSize: 24),
          ),
          margin: EdgeInsets.all(2),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.elliptical(20, 40)),
            color: isCurrentUser ? KmyColors[4] : KmyColors[2],
          ),
        ),
      ],
    );
  }
}
