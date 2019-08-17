import 'package:cloud_firestore/cloud_firestore.dart';
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
        color: Colors.red,
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
    return await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(players[index].getName()),
          children: <Widget>[
            Container(
              height: 450.0,
              width: 400.0,
              child: ListView.builder(
                itemCount: players[index].toList().length,
                itemBuilder: (context, field) {
                  return playerPopupRow(players[index], field);
                },
              ),
            )

          ],
        );
      }
    );
  }
  //called from above
  Widget playerPopupRow(PlayerData player, int index){
    //appearences, goals, gw, price, totalPoints
    List<int> badIndex = [0, 14, 15, 20, 23];
    //Remove position fields
    // 12 is forward goal
    // 5, 6 are def concede, 7 is clean, 8 is goal
    // 16 is mid cleen, 17 is goal
    switch(player.getPosition()){
      case 0:
        badIndex.addAll([16,17]);
        badIndex.add(12);
        break;
      case 1:
        badIndex.add(12);
        badIndex.addAll([5,6,7,8]);
        break;
      case 2:
        badIndex.addAll([16,17]);
        badIndex.addAll([5,6,7,8]);
        break;
    }

    if(badIndex.contains(index)){
      return Container();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        //Field Name
        Flexible(
          flex: 2,
          child: Text(player.fieldListFancy()[index]),
          fit: FlexFit.tight,
        ),
        Flexible(
          flex: 1,
          child: Text(player.toList()[index].toString()),
          fit: FlexFit.loose,
        ),        
      
        //Up
        RaisedButton(
          child: Text("+"),
          onPressed: () {increment(1, index, player);},
        ),
        //Down
        RaisedButton(
          child: Text("-"),
          onPressed: () {increment(-1, index, player);},
        ),
      ],
    );
  }

  // changes state based on +/- click
  void increment(int change, int index, PlayerData player){
    List temp = player.toList();
    temp[index]+= change;
    for(PlayerData i in players){
      if (i.getName() == player.getName()){
        setState(() {
          i.setData(temp);
        });
      }
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
        if(result == 0){
          return;
        } else {
          writeData();
        }
      }
    );
    Navigator.pop(context);
  }

  /*
  Handles reading player data
  Writing back to firestore
  */
  writeData() async {
    try{
      for(PlayerData i in players){
        PlayerData currentData = new PlayerData(i.getName(), i.getPosition());

        // update player points
        i.giveApp();
        i.calcPoints();

        //Create Document for game 
        DocumentReference addedDocRef = Firestore.instance.collection("Games").document();
        addedDocRef.setData({"Opponent": opponent});
        addedDocRef.updateData({
          i.getName(): i.toMap(),
        });

        //Update Players
        Firestore.instance.collection("Players").document(i.getName()).get().then(
          (doc) {
            currentData.loadData(doc);
            currentData.add(i);

            List fields = currentData.fieldList();
            List data = currentData.toList();

            //Write to Firestore
            Firestore.instance.runTransaction((transaction) async {
              DocumentSnapshot freshSnap = await transaction.get(doc.reference);
              await transaction.update(freshSnap.reference, {
                fields[0]: data[0],
                fields[1]: data[1],
                fields[2]: data[2],
                fields[3]: data[3],
                fields[4]: data[4],
                fields[5]: data[5],
                fields[6]: data[6],
                fields[7]: data[7],
                fields[8]: data[8],
                fields[9]: data[9],
                fields[10]: data[10],
                fields[11]: data[11],
                fields[12]: data[12],
                fields[13]: data[13],
                fields[14]: data[14],
                fields[15]: data[15],
                fields[16]: data[16],
                fields[17]: data[17],
                fields[18]: data[18],
                fields[19]: data[19],
                fields[20]: data[20],
                fields[21]: data[21],
                fields[22]: data[22],
                fields[23]: data[23],
              });
            });
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
