import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fantasy_hockey/pages/AddGamePage.dart';
import 'package:fantasy_hockey/pages/TransferLockPage.dart';

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
                onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => TransferLockPage()));},
                child: Text("Transfer Lock/Unlock", style: TextStyle(fontSize: 18, fontFamily: 'Titillium')),
              ),
            ),
            //Aadd player to firebase
            Container(
              margin: new EdgeInsets.symmetric(horizontal: 30, vertical: 7),
              height: 50,
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                color: Theme.of(context).accentColor,
                onPressed: addDataToFirebase,
                child: Text("Add Player to firebase", style: TextStyle(fontSize: 18, fontFamily: 'Titillium')),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
  }

}