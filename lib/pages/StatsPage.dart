import 'package:fantasy_hockey/pages/Fixtures.dart';
import 'package:fantasy_hockey/pages/Rules.dart';
import 'package:fantasy_hockey/pages/PlayerStats.dart';
import 'package:fantasy_hockey/pages/Mod.dart';
import 'package:flutter/material.dart';

class StatsPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          //Title
          Container(
            padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: Align(
              alignment: Alignment.center,
              child: Text("Statistics", style: TextStyle(fontSize: 30, fontFamily: 'Titillium', color: Colors.white)),
            )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              //Top Scorer
              Container(
                margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                width: (MediaQuery.of(context).size.width*0.8)/2,
                height: 170,
                color: Colors.yellow[800],
                alignment: Alignment.center,
                child: Text("Top Scorer", style: TextStyle(fontSize: 24, fontFamily: 'Titillium'))
              ),
              //Top Assister
              Container(
                margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                width: (MediaQuery.of(context).size.width*0.8)/2,
                height: 170,
                color: Colors.yellow[800],
                alignment: Alignment.center,
                child: Text("Top Assister", style: TextStyle(fontSize: 24, fontFamily: 'Titillium')),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              //Top Points
              Container(
                margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
                width: (MediaQuery.of(context).size.width*0.8)/2,
                height: 170,
                color: Colors.yellow[800],
                alignment: Alignment.center,
                child: Text("Top Points", style: TextStyle(fontSize: 24, fontFamily: 'Titillium')),
              ),
              //Best GW
              Container(
                margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
                width: (MediaQuery.of(context).size.width*0.8)/2,
                height: 170,
                color: Colors.yellow[800],
                alignment: Alignment.center,
                child: Text("Top GW", style: TextStyle(fontSize: 24, fontFamily: 'Titillium')),
              ),
            ],
          ),
          //Player stats
          Container(
            margin: new EdgeInsets.symmetric(horizontal: 30, vertical: 7),
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width,
              height: 50,
              color: Theme.of(context).accentColor,
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => PlayerStats()));                 
              },
              child: Text("Player Stats", style: TextStyle(fontSize: 18, fontFamily: 'Titillium')),
            ),
          ),
          
          //Fixtures & Results
          Container(
            margin: new EdgeInsets.symmetric(horizontal: 30, vertical: 7),
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width,
              height: 50,
              color: Theme.of(context).accentColor,
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Fixtures()));                 
              },
              child: Text("Fixtures & Results", style: TextStyle(fontSize: 18, fontFamily: 'Titillium')),
            ),
          ),
          
          //Rules
          Container(
            margin: new EdgeInsets.symmetric(horizontal: 30, vertical: 7),
            height: 50,
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width,
              color: Theme.of(context).accentColor,
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Rules()));                 
              },
              child: Text("Rules", style: TextStyle(fontSize: 18, fontFamily: 'Titillium')),
            ),
          ),
          //Add Game/Mod button
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                child: FlatButton(
                  color: Colors.white,
                  onPressed: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context) => Mod()));                 
                  },
                  child: Text("MOD"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
}