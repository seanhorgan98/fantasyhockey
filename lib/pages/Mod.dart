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
            Text("Placeholder", style:TextStyle(fontFamily: 'Titillium')),
          ],
        ),
      ),
    );
  }
}