import 'package:flutter/material.dart';

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
                onPressed: (){print("Add Game");},
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
                onPressed: (){print("Freeze Transfers");},
                child: Text("Freeze Transfers", style: TextStyle(fontSize: 18, fontFamily: 'Titillium')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}