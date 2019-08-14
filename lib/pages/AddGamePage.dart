
import 'package:fantasy_hockey/classes/PlayerData.dart';
import 'package:flutter/material.dart';

class AddGamePage extends StatefulWidget{
  @override
  AddGamePageState createState() => new AddGamePageState();
}


class AddGamePageState extends State<AddGamePage>{

  List<PlayerData> players = new List<PlayerData>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Add Game", style: TextStyle(fontFamily: 'Titillium')),
      ),
      //gonna have to stream body, on changes to players
      body: ListView(
        padding: EdgeInsets.all(15),
        children: <Widget>[
          RaisedButton(
            onPressed: subGame,
            child: Text("Submit Game", style: TextStyle(color: Colors.white),),
            color: Colors.black,
          ),
          //Maybe text box for opponent name
          //15 players
          buildPlayerWidget(0),
          buildPlayerWidget(1),
          buildPlayerWidget(2),
          buildPlayerWidget(3),
          buildPlayerWidget(4),
          buildPlayerWidget(5),
          buildPlayerWidget(6),
          buildPlayerWidget(7),
          buildPlayerWidget(8),
          buildPlayerWidget(9),
          buildPlayerWidget(10),
          buildPlayerWidget(11),
          buildPlayerWidget(12),
          buildPlayerWidget(13),
          buildPlayerWidget(14)             
        ],
      )
    );
  }

  buildPlayerWidget(int index){
    if(players.length > index ){
      return RaisedButton(
        color: Colors.red,
        child:Text(index.toString()),
        onPressed: () {playerPopup(index);},
      );
    } else {
      return RaisedButton(
        child:Text("Add Player"),
        onPressed: setPlayerName,
      );
    } 
  }

  playerPopup(int index){
    //TODO popup
    // Remove player
    // Add point
    // Remove points
    return;
  }

  setPlayerName(){
    //TODO give options
    //Popup with all unused player names
    return;
  }


  subGame(){
    //TODO add subGame
    // Could validate?
    // 1 motm, 1 donkey
    return;
  }



}



// (context, index) =>
//                 _headerCheck(context, index),