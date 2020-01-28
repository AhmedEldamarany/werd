import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:werd/firestroing.dart';

class WeekReport extends StatelessWidget {
  FireStoring fireStoring = new FireStoring();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topRight: Radius.circular(120)),
      ),
      padding: EdgeInsets.only(left: 30, top: 30),
      child: StreamBuilder<QuerySnapshot>(
        stream: fireStoring.weekStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Text('wait');
          //todo something to load
          else {
            double myAvg;
            List<Text> AllPeople = List<Text>();
            var data = snapshot.data.documents;
            for (var smallData in data) {
              myAvg = smallData.data['avg'];
              AllPeople.add(avgText(myAvg));
            }
            fireStoring.setWeekAverage();

            return ListView(
              children: AllPeople,
            );
          }
        },
      ),
    );
  }

  Text avgText(double avg) {
    return Text(
      '$avg',
      style: TextStyle(color: Colors.red, fontSize: 33),
    );
  }
}
