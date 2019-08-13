
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
      body: ListView(
        padding: EdgeInsets.all(15),
        children: <Widget>[
          RaisedButton(
            onPressed: subGame(),
            child: Text("Submit Game", style: TextStyle(color: Colors.white),),
            color: Colors.black,
          ),
          //18 players
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
          buildPlayerWidget(14),
          buildPlayerWidget(15),
          buildPlayerWidget(16),
          buildPlayerWidget(17)                 
        ],
      )
    );
  }

  buildPlayerWidget(int index){
    if(players.length > index ){
      return RaisedButton(
        child:Text(index.toString()),
        onPressed: playerPopup(index),
      );
    } else {
      return RaisedButton(
        child:Text("Add Player"),
        onPressed: setPlayerName(),
      );
    } 
  }

  playerPopup(int index){
    //TODO popup to add/subtract 1 in each field
    return;
  }

  setPlayerName(){
    //TODO give options
    return;
  }


  subGame(){
    //TODO add subGame
    return;
  }



}



// (context, index) =>
//                 _headerCheck(context, index),