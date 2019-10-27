import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fantasy_hockey/pages/Mod/AddGamePage.dart';
import 'package:fantasy_hockey/pages/Mod/TransferLockPage.dart';
import 'package:fantasy_hockey/classes/PlayerList.dart';

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
            //Add Dummy Team
            Container(
              alignment: Alignment.bottomCenter,
              margin: new EdgeInsets.symmetric(horizontal: 30, vertical: 7),
              height: 50,
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                color: Theme.of(context).accentColor,
                onPressed: () => addDummyTeam(context),
                child: Text("Add dummy team to firebase", style: TextStyle(fontSize: 18, fontFamily: 'Titillium')),
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

  void addDummyTeam(BuildContext context){
    Firestore.instance.runTransaction((transaction) async { await transaction.set(Firestore.instance.collection("Teams").document(),
        {
          'teamName': "Autogen Team",
          'totals': [0, 0]
         }
      );
    });
    
  }

  //Depreciated until freshers
  addDataToFirebase(){
    String player = "Adam Stevenson";
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
          'position': 0,
          'price': 9,
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


