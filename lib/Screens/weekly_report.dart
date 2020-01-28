import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:werd/firestroing.dart';

class WeekReport extends StatelessWidget {
  FireStoring fireStoring = new FireStoring();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: StreamBuilder<QuerySnapshot>(
            stream: fireStoring.weekStream(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Text('wait');
              else {
                print('this is else');
                double myAvg;
                List<Text> AllPeople = List<Text>();
                var data = snapshot.data.documents;
                print('${data.length} this is lenghrs');
                for (var smallData in data) {
                  print('doc Id isssssss ${smallData.documentID}');
                  myAvg = smallData.data['avg'];
                  AllPeople.add(Text(
                    '$myAvg',
                    style: TextStyle(color: Colors.red, fontSize: 33),
                  ));
                  print('my Avg is $myAvg and length is ${data.length}');
                }
                fireStoring.setWeekAverage();

                return ListView(
                  children: AllPeople,
                );
              }
            },
          )),
    );
  }
}
