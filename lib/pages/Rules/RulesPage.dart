import 'package:flutter/material.dart';
import 'package:fantasy_hockey/pages/Rules/Deadlines.dart';
import 'package:fantasy_hockey/pages/Rules/HowTo.dart';
import 'package:fantasy_hockey/pages/Rules/Scoring.dart';
import 'package:fantasy_hockey/pages/Rules/Transfers.dart';

class RulesPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rules", style: TextStyle(fontFamily: 'Titillium')),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center( child: Text(
              "Choose a topic to read up on",
              style: TextStyle(fontFamily: 'Titillium', fontSize: 25)
            )),

            RaisedButton(
              child: Text("HOW TO PLAY",
              style: TextStyle(fontFamily: 'Titillium', fontSize: 45)),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HowTo()))
            ),

            RaisedButton(
              child: Text("TRANSFERS",
              style: TextStyle(fontFamily: 'Titillium', fontSize: 45)),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Transfers()))
            ),

            RaisedButton(
              child: Text("DEADLINES",
              style: TextStyle(fontFamily: 'Titillium', fontSize: 45)),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Deadlines()))
            ),

            RaisedButton(
              child: Text("SCORING",
              style: TextStyle(fontFamily: 'Titillium', fontSize: 45)),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Scoring()))
            )
          ]
        )
      )
    );
  }
  
}