import 'package:flutter/material.dart';

class HowTo extends StatelessWidget{

  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        title: Text("How To Play", style: TextStyle(fontFamily: 'Titillium')),
        backgroundColor: Colors.black,
      ),
      body: ListView(
          padding: EdgeInsets.all(12),
          children: <Widget>[
            Text("Aim of the game", style: TextStyle(fontFamily: 'Titillium', fontSize: 40)),
            Text(
              "Your goal is to create the highest scoring team from the players available. " +
              "For details on points, see the SCORING section",
              style: TextStyle(fontFamily: 'Titillium', fontSize: 25)
            ),
            Text("Managing Your Team", style: TextStyle(fontFamily: 'Titillium', fontSize: 40)),
            Text(
              "Every week you should pick a Captain for the week, " +
              "this player's points are doubled.\n" +
              "The sub player's points are not counted.\n"
              "You are also given 1 free transfer each week, for more details see TRANSFERS",
              style: TextStyle(fontFamily: 'Titillium', fontSize: 25)
            ),
          ],
      ),
    );
  }
}

