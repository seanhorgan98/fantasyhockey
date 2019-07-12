import 'package:flutter/material.dart';

class PlayerStats extends StatefulWidget{
  @override
  PlayerStatsState createState() => new PlayerStatsState();
}

class PlayerStatsState extends State<PlayerStats>{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Player Stats", style: TextStyle(fontFamily: 'Titillium')),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            Text("Placeholder", style:TextStyle(fontFamily: 'Titillium')),
          ],
        ),
      ),
    );
  }
}