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
                int myAvg;
                var data = snapshot.data.documents;
                for (var smallData in data) {
                  myAvg = smallData.data['avg'];
                }
                return ListView(
                  children: <Widget>[Text('$myAvg')],
                );
              }
            },
          )),
    );
  }
}
