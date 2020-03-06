import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:werd/firestroing.dart';

import '../constants.dart';

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
  BannerAd myBanner;
  List<bool> werdValues;
  List<int> prayerValues;
  bool showPrayers;
  int dayPoints;
  String weekAvg;

  String title;

  MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['all', 'beautiful apps', 'game', 'todo', 'calaender'],
    nonPersonalizedAds: true,
    designedForFamilies: true,
    testDevices: <String>[],
  );

  //
  @override
  void initState() {
    super.initState();

    weekAvg = 'متوسط الأسبوع';
    title = weekDays[firestoring.getToday() - 1];
    dayPoints = 0;
    showPrayers = false;
    werdValues = [false, false, false, false];
    prayerValues = [0, 0, 0, 0, 0];
    FirebaseAdMob.instance.initialize(appId: kAppId);
    myBanner = buildMyBannerAd()
      ..load();
  }

  @override
  void dispose() {
    myBanner?.dispose();
    super.dispose();
  }

  void endTheDay() {
    dayPoints = 0;
    for (int i in prayerValues)
      dayPoints += i;
    for (bool j in werdValues)
      if (j) dayPoints++;
    firestoring.setDayTotale(dayPoints);
  }

  BannerAd buildMyBannerAd() {
    return BannerAd(
        adUnitId: kAppUnitId,
        size: AdSize.fullBanner,
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          print(event);
        });
  }

  @override
  Widget build(BuildContext context) {
    myBanner
      ..load()
      ..show();
    return Scaffold(
      backgroundColor: myColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: PageView(
        onPageChanged: (i) {
          setState(() {
            if (i == 1)
              title = weekAvg;
            else
              title = weekDays[firestoring.getToday() - 1];
          });
        },
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

          if (snapshot.connectionState != ConnectionState.active &&
              snapshot.connectionState != ConnectionState.waiting) {
            print('nothing');
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.active &&
              !snapshot.hasData) {
            print('filling');
            firestoring.updatePrayers(prayerValues);
            firestoring.updateWerds(werdValues);
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
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
                myListTile('ورد القرآن', 0, 'يِهْدِي لِلَّتِي هِيَ أَقْوَمُ'),
                myListTile('قيام الليل', 1,
                    'وَالَّذِينَ يَبِيتُونَ لِرَبِّهِمْ سُجَّدًا وَقِيَامًا'),
                myListTile('أذكار الصباح', 2, ''),
                myListTile('أذكار المساء', 3, ''),
                ListTile(
                  title: Text(
                    'Total   $dayPoints',
                    style: TextStyle(color: Colors.indigo, fontSize: 22),
                  ),
                ),
              ],
            );
          } else
            return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  CheckboxListTile myListTile(String title, int hisVal, String subTitle,
      {fontSize = 22.0}) {
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
        subTitle,
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
          prayerTile(0, 'الفجر'),
          prayerTile(1, 'الظهر'),
          prayerTile(2, 'العصر'),
          prayerTile(3, 'المغرب'),
          prayerTile(4, 'العشاء'),
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

  prayerTile(int thisPrayer, String prayerName) {
    return ListTile(
      title: Text(prayerName),
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
              print(smallData.documentID == Day.userId);
              myAvg = smallData.data['avg'];
              if (myAvg > 0)
                allPeople.add(MessageBubble(
                  text: '$myAvg',
                  isCurrentUser: smallData.documentID == Day.userId,
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

  final MainAxisAlignment myAlignment = MainAxisAlignment.start;
  final MainAxisAlignment hisAlignment = MainAxisAlignment.end;
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
                color: isCurrentUser ? KmyColors[0] : KmyColors[0],
                fontSize: 24),
          ),
          margin: EdgeInsets.all(2),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.elliptical(20, 40)),
            color: isCurrentUser ? KmyColors[4] : Colors.grey,
          ),
        ),
      ],
    );
  }
}
