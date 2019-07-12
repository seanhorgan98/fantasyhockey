import 'package:flutter/material.dart';

class Fixtures extends StatefulWidget{
  @override
  FixturesState createState() => new FixturesState();
}

class FixturesState extends State<Fixtures>{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Fixtures & Results", style: TextStyle(fontFamily: 'Titillium')),
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