import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fantasy_hockey/pages/AddGamePage.dart';

class Mod extends StatefulWidget{
  @override
  ModState createState() => new ModState();
}

class ModState extends State<Mod>{

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Moderation", style: TextStyle(fontFamily: 'Titillium')),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            //Add Game
            Container(
              margin: new EdgeInsets.symmetric(horizontal: 30, vertical: 7),
              height: 50,
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                color: Theme.of(context).accentColor,
                onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => AddGamePage()));},
                child: Text("Add Game", style: TextStyle(fontSize: 18, fontFamily: 'Titillium')),
              ),
            ),
            //Freeze Transfers
            Container(
              margin: new EdgeInsets.symmetric(horizontal: 30, vertical: 7),
              height: 50,
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                color: Theme.of(context).accentColor,
                onPressed: freezeTransfers(),
                child: Text("Freeze Transfers", style: TextStyle(fontSize: 18, fontFamily: 'Titillium')),
              ),
            ),
            //Test button to add data to firebase
            Container(
              margin: new EdgeInsets.symmetric(horizontal: 30, vertical: 7),
              height: 50,
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                color: Theme.of(context).accentColor,
                onPressed: addDataToFirebase(),
                child: Text("Add Player to firebase", style: TextStyle(fontSize: 18, fontFamily: 'Titillium')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  freezeTransfers(){
    // TODO script for freezing transfers
    // Loop through teams, set transfer[0] = 0?
    return;
  }
  
  //TODO add button for unfreezing transfers, popup if fail



  addDataToFirebase(){
    String player = "Ben Dunwoody";
    Firestore.instance.runTransaction((transaction) async { await transaction.set(Firestore.instance.collection("Players").document(player),
        {
          'goals': 0,
          'appearances': 0,
          'assistFlicks': 0,
          'assists': 0,
          'boatRaceLoss': 0,
          'boatRaceWin': 0,
          'defender2Conceeded': 0,
          'defender5Conceeded': 0,
          'defenderCleanSheets': 0,
          'defenderGoals': 0,
          'donkeys': 0,
          'motms': 0,
          'flickGoals': 0,
          'forwardGoals': 0,
          'greenCards': 0,
          'gw': 0,
          'midfieldCleenSheets': 0,
          'midfielderGoals': 0,
          'missedFlicks': 0,
          'ownGoals': 0,
          'price': 0,
          'redCards': 0,
          'shortGoals': 0,
          'totalPoints': 0,
          'yellowCards': 0,
          'team': "2XI"
         }
      );
    });
    print("Added: $player");
    print("Transaction Cancelled");
  }

}

class Data{
  final int goals = 0;
  final int appearances = 0;
  final int assistFlicks = 0;
  final int assists = 0;
  final int boatRaceLoss = 0;
  final int boatRaceWin = 0;
  final int defender2Conceeded = 0;
  final int defender5Conceeded = 0;
  final int defenderCleanSheets = 0;
  final int defenderGoals = 0;
  final int donkeys = 0;
  final int motms = 0;
  final int flickGoals = 0;
  final int forwardGoals = 0;
  final int greenCards = 0;
  final int gw = 0;
  final int midfieldCleenSheets = 0;
  final int midfielderGoals = 0;
  final int missedFlicks = 0;
  final int ownGoals = 0;
  final int price = 0;
  final int redCards = 0;
  final int shortGoals = 0;
  final int totalPoints = 0;
  final int yellowCards = 0;
  


  Map<String, dynamic> toJson() =>
  {
    'goals': goals,
    'appearances': appearances,
    'assistFlicks': assistFlicks,
    'assists': assists,
    'boatRaceLoss': boatRaceLoss,
    'boatRaceWin': boatRaceWin,
    'defender2Conceeded': defender2Conceeded,
    'defender5Conceeded': defender5Conceeded,
    'defenderCleanSheets': defenderCleanSheets,
    'defenderGoals': defenderGoals,
    'donkeys': donkeys,
    'motms': motms,
    'flickGoals': flickGoals,
    'forwardGoals': forwardGoals,
    'greenCards': greenCards,
    'gw': gw,
    'midfieldCleenSheets': midfieldCleenSheets,
    'midfielderGoals': midfielderGoals,
    'missedFlicks': missedFlicks,
    'ownGoals': ownGoals,
    'price': price,
    'redCards': redCards,
    'shortGoals': shortGoals,
    'totalPoints': totalPoints,
    'yellowCards': yellowCards,
  };
}