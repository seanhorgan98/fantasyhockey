import 'package:flutter/material.dart';

class MyTeamPage extends StatelessWidget{
  final MyGridView myGridView = new MyGridView();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.blue[700],
          title: new Text("My Team"),
        ),
        body: myGridView.build(),
      );
  }
}

class MyGridView{
  List players = ["Adshead", "Cabbage", "Horgan", "Montgomery", "SOH", "Bond"];
  
  Card getStructuredGridCell(name, color) {
    return new Card(
        elevation: 1.5,
        color: color,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            new Center(
              child: new Text(name),
            )
          ],
        ));
  }

  GridView build() {
    return new GridView.count(
      primary: true,
      padding: const EdgeInsets.all(10.0),
      crossAxisCount: 2,
      childAspectRatio: 0.85,
      mainAxisSpacing: 5.0,
      crossAxisSpacing: 5,
      children: <Widget>[
        //Filler Names, Will need to be loaded from DB
        getStructuredGridCell(players[0], Colors.green),
        getStructuredGridCell(players[1], Colors.green),
        getStructuredGridCell(players[2], Colors.red),
        getStructuredGridCell(players[3], Colors.red),
        getStructuredGridCell(players[4], Colors.yellow),
        getStructuredGridCell(players[5], Colors.yellow),
      ],
    );
  }
}


