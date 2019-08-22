import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fantasy_hockey/pages/AddGamePage.dart';
import 'package:fantasy_hockey/pages/TransferLockPage.dart';

class Mod extends StatefulWidget{
  @override
  ModState createState() => new ModState();
}

class ModState extends State<Mod>{

  PlayerList playerData;

  @override
  void initState() {
    Firestore.instance.collection('Players').getDocuments().then(
      (collection) => setState( () {
        playerData = new PlayerList(collection);
      })
    );
    super.initState();
  }

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
            //Add player to firebase
            Divider(),
            Container(
              alignment: Alignment.bottomCenter,
              margin: new EdgeInsets.symmetric(horizontal: 30, vertical: 7),
              height: 50,
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                color: Theme.of(context).accentColor,
                onPressed: addDataToFirebase,
                child: Text("Add Player to firebase", style: TextStyle(fontSize: 18, fontFamily: 'Titillium')),
              ),
            ),
            //Update Teams
            Container(
              alignment: Alignment.bottomCenter,
              margin: new EdgeInsets.symmetric(horizontal: 30, vertical: 7),
              height: 50,
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                color: Theme.of(context).accentColor,
                onPressed: () => updateTeams(context),
                child: Text("Propogate GW scores", style: TextStyle(fontSize: 18, fontFamily: 'Titillium')),
              ),
            ),
          ],
        ),
      ),
    );
  }


  /*
    Many functions to propogate data
    update Teams gets documents to update
    each user controls flow of other 2
    batch Team handles all write data
    do Write handles the write to firestore
  */
  void updateTeams(BuildContext context){
    Firestore.instance.collection('Teams').getDocuments().then( 
      (snap) => eachUser(snap)
    );
  }

  batchTeam(QuerySnapshot collection, WriteBatch batch){
    for (DocumentSnapshot user in collection.documents){
      //Skip null doc
      if(user.documentID == '000'){
        continue;
      }

      //team var to track data being used here
      TeamPointData team = new TeamPointData(user);
      //update team data using state
      for(int i=0; i<team.names.length;i++){
        team.setPoints(i, playerData.getPlayerPoints(team.names[i]) );
      }
      team.doubleCap();
      team.updateGW();

      // add to batch
      DocumentReference uRef = user.reference;
      batch.updateData(uRef, {
        "points": team.gwPoints,
        "totals": [team.gw, team.total]
      });
    }
  }

  eachUser(QuerySnapshot snapshot) async {
    WriteBatch batch = Firestore.instance.batch();

    await batchTeam(snapshot, batch);

    await doWrite(batch);
  }

  doWrite(WriteBatch batch){
    batch.commit();
  }

  //Depreciated until freshers
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

class TeamPointData {

  int gw;
  int total;
  List gwPoints;
  List names;
  int captain;

  void updateGW(){
    this.gw = this.gwPoints.reduce((a, b) => a + b);
  }

  void doubleCap(){
    this.gwPoints[captain] *= 2;
  }

  TeamPointData(DocumentSnapshot snapshot){
    if(snapshot == null){
      throw IOException;
    }
    this.gw = snapshot['totals'][0];
    this.total = snapshot['totals'][1];
    this.gwPoints = snapshot['points'];
    this.names = snapshot['players'];
    this.captain = snapshot['captain'];
  }

  void setPoints(int i, int value){
    if( i == null || value == null){
      throw IOException;
    }
    this.gwPoints[i] = value;
  }
}

class NamePoints {
  String name;
  int gwPoints;

  NamePoints(DocumentSnapshot snapshot){
    if(snapshot == null){
      throw IOException;
    }
    this.name = snapshot.documentID;
    this.gwPoints = snapshot['gw'];
  }

  int getPoints(){
    return this.gwPoints;
  }

  String getName(){
    return this.name;
  }
}

class PlayerList {
  List<NamePoints> players = new List<NamePoints>();

  PlayerList(QuerySnapshot query){
    if(query == null) {
      throw IOException;
    }
    for (DocumentSnapshot player in query.documents){
      this.players.add(new NamePoints(player));
    }
  }

  int getPlayerPoints(String name){
    for(NamePoints data in players){
      if(data.getName() == name){
        return data.getPoints();
      }
    }
    return 0;
  }

}