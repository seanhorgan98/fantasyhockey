import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasy_hockey/classes/AddPlayerPopup.dart';
import 'package:fantasy_hockey/classes/PlayerData.dart';
import 'package:flutter/material.dart';

class AddGamePage extends StatefulWidget{
  @override
  AddGamePageState createState() => new AddGamePageState();
}


class AddGamePageState extends State<AddGamePage>{

  List<PlayerData> players = new List<PlayerData>();
  String opponent;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Add Game", style: TextStyle(fontFamily: 'Titillium')),
      ),
      //gonna have to stream body, on changes to playerssd
      body: ListView(
        padding: EdgeInsets.all(15),
        children: <Widget>[
          RaisedButton(
            onPressed: subGame,
            child: Text("Submit Game", style: TextStyle(color: Colors.white),),
            color: Colors.black,
          ),
          //Maybe text box for opponent name
          TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Opponent Name'
            ),
            textAlign: TextAlign.center,
            onSubmitted: (text) {updateOpp(text);},
          ),
          //15 players
          buildPlayerWidget(context, 0),
          buildPlayerWidget(context, 1),
          buildPlayerWidget(context, 2),
          buildPlayerWidget(context, 3),
          buildPlayerWidget(context, 4),
          buildPlayerWidget(context, 5),
          buildPlayerWidget(context, 6),
          buildPlayerWidget(context, 7),
          buildPlayerWidget(context, 8),
          buildPlayerWidget(context, 9),
          buildPlayerWidget(context, 10),
          buildPlayerWidget(context, 11),
          buildPlayerWidget(context, 12),
          buildPlayerWidget(context, 13),
          buildPlayerWidget(context, 14)
        ],
      )
    );
  }
  
  // sets state of opponent using textbow
  void updateOpp(String text){
    setState(() {
      opponent = text;
    });
  }
  
  // build helper
  Widget buildPlayerWidget(BuildContext context, int index){
    if(players.length > index ){
      return RaisedButton(
        color: Colors.orange,
        child:Text(players[index].getName()),
        onPressed: () {playerPopup(index);},
      );
    } else {
      return RaisedButton(
        child:Text("Add Player"),
        onPressed: () {setPlayerName(context);},
      );
    } 
  }

  //Function to add player to game
  void setPlayerName(BuildContext context){
    _asyncSimpleDialogAdd(context).then(
      (data) {
        if(data != null){
          setState(() {
            players.add(data);
          });
        }
      }
    );

  }

  //Popup for attempting to get new player name
  Future<PlayerData> _asyncSimpleDialogAdd(BuildContext context) async {
    return await showDialog<PlayerData>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Add a Player'),
          children: <Widget>[
            Container(
              height: 300.0,
              width: 300.0,
              child: listAllPlayers(),
            )
          ],
        );
      }
    );
  }

  //List of all players for popup
  Widget listAllPlayers(){
    return StreamBuilder(
      stream: Firestore.instance.collection("Players").snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData) {return const Text("Loading...");}
        return ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.all(5),
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index)
            {return addPlayerButton(
              context,
              snapshot.data.documents[index].documentID,
              snapshot.data.documents[index]['position']
            );}
        );
      }
    );
  }

  //list item widget
  Widget addPlayerButton(BuildContext context, String name, int position) {
    if(name == 'No Player') {
      return Container();
    }
    return SimpleDialogOption(
      onPressed: () {
        Navigator.pop(context, new PlayerData(name, position));
      },
      child: Text(name),
    );
  }
  //called from above
  playerPopup(int index) async {
    // Remove player button somewhere?

    PlayerData playerDataToUpdate = players[index];

    //Open page to update scores for this player
    playerDataToUpdate = await Navigator.push(
      context, MaterialPageRoute(
        builder: (context) => AddPlayerPopup(playerData: players[index])
      )
    );
    if(playerDataToUpdate == null){
      Navigator.pop(context);
      return;
    }
  }

  // Gets confirmation before writing everything
  // Exits widget
  void subGame() async {
    //Check players have been added
    if(players.isEmpty){
      _ackAlert(context, "Invalid Command", "No players in game");
      return;
    }

    //Conformation popup
    await _asyncConfirmPopup(context).then(
      (int result) {
        if(result == 0 || result == null){
          return;
        } else {
          writeData();
          Navigator.pop(context);
        }
      }
    );
    
  }

  /*
  Handles reading player data
  Writing back to firestore
  */
  void writeData() async {
    try{

      DocumentReference addedDocRef = Firestore.instance.collection("Games").document();
      addedDocRef.setData({"Opponent": opponent});

      for(PlayerData i in players){
        PlayerData currentData = new PlayerData(i.getName(), i.getPosition());

        // update player points
        i.giveApp();
        i.calcPoints();

        //Create Document for game
        addedDocRef.updateData( {i.getName(): i.toMap()} );

        //Update Players
        Firestore.instance.collection("Players").document(i.getName()).get().then(
          (doc) {
            //load player data then add
            currentData.loadData(doc);
            currentData.add(i);
            //Write to Firestore
            DocumentReference freshRef = doc.reference;
            freshRef.updateData( currentData.toMap() );
          }
        );
      }
    } catch (err){
      print(err.toString());
    } 
  }
  
  
  //Simple Popup Messages
  Future<void> _ackAlert(BuildContext context, String alertTitle, String alert) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(alertTitle),
          content: Text(alert),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
 
  //Popup for confirmation
  Future<int> _asyncConfirmPopup(BuildContext context) async {
    return await showDialog<int>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text("Submit Game?"),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 1);
              },
              child: Text('Confirm'),
            ),
            Row(),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 0);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      });
  }

}
