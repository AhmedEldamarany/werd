import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:werd/firestroing.dart';

import '../constants.dart';

class WeekReport extends StatelessWidget {
  FireStoring fireStoring = new FireStoring();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(120)),
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
            List<MessageBubble> AllPeople = List<MessageBubble>();
            var data = snapshot.data.documents;
            for (var smallData in data) {
              print(smallData.documentID);
              myAvg = smallData.data['avg'];
              if (myAvg > 0)
                AllPeople.add(MessageBubble(
                  text: '$myAvg',
                  isCurrentUser: true,
                ));
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
