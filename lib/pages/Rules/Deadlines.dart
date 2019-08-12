import 'package:flutter/material.dart';

class Deadlines extends StatelessWidget{

  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        title: Text("Deadlines", style: TextStyle(fontFamily: 'Titillium')),
        backgroundColor: Colors.black,
      ),
      body: ListView(
          padding: EdgeInsets.all(12),
          children: <Widget>[
            Text("Transfer Window", style: TextStyle(fontFamily: 'Titillium', fontSize: 40)),
            Text(
              "The Transfer Window will:\n" +
              "- open Midnight after Sunday\n" +
              "- close 12pm on Wednesday",
              style: TextStyle(fontFamily: 'Titillium', fontSize: 25)
            ),
            Text("Re-arranged Games", style: TextStyle(fontFamily: 'Titillium', fontSize: 40)),
            Text(
              "In the event of a Re-arranged midweek game, " +
              "the transfer window may be shortened or moved.\n" +
              "This is to ensure matches do not occur during the window",
              style: TextStyle(fontFamily: 'Titillium', fontSize: 25)
            ),
          ],
      ),
    );
  }
}