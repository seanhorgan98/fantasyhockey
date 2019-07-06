import 'package:flutter/material.dart';

enum Response { Captain, Substitute, Stats, Transfer }

class MyTeamPage extends StatefulWidget{
  @override
  MyTeamPageState createState() => new MyTeamPageState();
}

class MyTeamPageState extends State<MyTeamPage> {
  final MyGridView myGridView = new MyGridView();


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.blue[700],
          title: new Text("My Team"),
        ),
        body: myGridView.build(context),
      );
  }


}

class MyGridView{
 //Filler Names, Will need to be loaded from DB
  List players = ["Adshead", "Cabbage", "Horgan", "Montgomery", "SOH", "Bond", "TB3"];

  Future<Response> _asyncSimpleDialog(context, name) async {
    return await showDialog<Response>(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return SimpleDialog(
            title: Text(name),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Response.Captain);
                },
                child: const Text('Captain'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Response.Substitute);
                },
                child: const Text('Substitute'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Response.Stats);
                },
                child: const Text('Player Stats'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Response.Transfer);
                },
                child: const Text('Transfer Out'),
              ),
            ],
          );
        });
  }

  RaisedButton getStructuredGridCell(name, color, context) {
    return new RaisedButton(
      elevation: 5,
      color: color,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          new Center(
            child: new Text(
              name,
              style: new TextStyle(fontSize: 25, color: Colors.black)                  
            ),
          ),
        ],
      ),
      onPressed: () {_asyncSimpleDialog(context, name);}
    );
  }


  GridView build(context) {
    return new GridView.count(
      primary: true,
      padding: const EdgeInsets.all(10.0),
      crossAxisCount: 2,
      childAspectRatio: 0.85,
      mainAxisSpacing: 10.0,
      crossAxisSpacing: 10,
      children: <Widget>[
        getStructuredGridCell(players[0], Colors.red, context),
        getStructuredGridCell(players[1], Colors.red, context),
        getStructuredGridCell(players[2], Colors.orange, context),
        getStructuredGridCell(players[3], Colors.orange, context),
        getStructuredGridCell(players[4], Colors.yellow, context),
        getStructuredGridCell(players[5], Colors.yellow, context),
        getStructuredGridCell(players[6], Colors.grey, context),
      ],
      
    );
  }
}


