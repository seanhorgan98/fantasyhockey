import 'package:flutter/material.dart';

class Transfers extends StatelessWidget{

  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        title: Text("Transfers", style: TextStyle(fontFamily: 'Titillium')),
        backgroundColor: Colors.black,
      ),
      body: ListView(
          padding: EdgeInsets.all(12),
          children: <Widget>[
            Text("Free Transfers", style: TextStyle(fontFamily: 'Titillium', fontSize: 40)),
            Text(
              "After each gameweek, you will be given one transfer.\n" +
              "This will stack up to two but after that, any extra transfers are discarded.\n" +
              "There are no other transfers outside of this.",
              style: TextStyle(fontFamily: 'Titillium', fontSize: 25)
            ),
            Text("Valid Transfers", style: TextStyle(fontFamily: 'Titillium', fontSize: 40)),
            Text(
              "For a transfer to be valid:\n" +
              "- You must be able to afford the new player\n" +
              "- You must have a transfer available\n" +
              "- You must be in the Transfer Window, see DEADLINES for details\n",
              style: TextStyle(fontFamily: 'Titillium', fontSize: 25)
            ),
            Text("Prices", style: TextStyle(fontFamily: 'Titillium', fontSize: 40)),
            Text(
              "Player prices may change throughout the year.\n" +
              "If a player that you own increases/decreases in value, so will your budget",
              style: TextStyle(fontFamily: 'Titillium', fontSize: 25 ),           
            ),
          ],
      ),
    );
  }
}