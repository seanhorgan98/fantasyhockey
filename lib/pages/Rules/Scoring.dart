import 'package:flutter/material.dart';

class Scoring extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Scoring", style: TextStyle(fontFamily: 'Titillium')),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        padding: EdgeInsets.all(12),
        children: <Widget>[
          Text("Points", style: TextStyle(fontFamily: 'Titillium', fontSize: 40)),
          Text(
            "Points are calculated per game\n" +
            "Admins have final say on all points",
            style: TextStyle(fontFamily: 'Titillium', fontSize: 25)
          ),
          Text("Values", style: TextStyle(fontFamily: 'Titillium', fontSize: 40)),
          Text(getPointsList(), style: TextStyle(fontFamily: 'Titillium', fontSize: 25))
        ],
      ),
    );
  }

  //Tidy up build by building this externally
  String getPointsList() {
    return "Game Played:\t 1\n" +
      "Goal (Forward):\t 4\n" + 
      "Goal (Midfield):\t 5\n" +
      "Goal (Defense):\t 6\n" + 
      "Goal (Short):\t 3\n" +
      "Goal (Flick):\t 3\n" +
      "Missed Flick:\t -3\n" +
      "Assist:\t 3\n" +
      "Assist (Flick):\t 3\n" +
      "Assist (Short):\t 0\n" +
      "Own Goal:\t -4\n" +
      "Clean Sheet (Defense):\t 5\n" +
      "Clean Sheet (Midfield):\t 1\n" +
      "Concede 2 (Defense):\t -1\n" +
      "Concede 5+ (Defense):\t -2\n" +
      "Green Card:\t -2\n" +
      "Yellow Card:\t -5\n" +
      "Red Card:\t -20\n" +
      "MotM:\t 5\n" +
      "Donkey:\t -3\n" +
      "Boat Race Win:\t 5\n" +
      "Boat Race Loss:\t -3\n";  
  }

}

