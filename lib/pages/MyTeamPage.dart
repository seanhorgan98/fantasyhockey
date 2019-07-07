import 'package:flutter/material.dart';
enum Response { Captain, Substitute, Stats, Transfer }

class MyTeamPage extends StatefulWidget{
  @override
  MyTeamPageState createState() => new MyTeamPageState();
}

class MyTeamPageState extends State<MyTeamPage> {

   //Filler Names, Will need to be loaded from DB
  List players = ["Adshead", "Cabbage", "Horgan", "Montgomery", "SOH", "Bond", "TB3"];
  int captain = 2;

  ButtonTheme getStructuredGridCell(name, captain, color, context) {
    if(captain){
       name = name + "\n(Captain)";
    }

    return new ButtonTheme(
      minWidth: 200,
      height: 100,
      child: RaisedButton(
        elevation: 10,
        color: color,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            new Center(
              child: new Text(
                name,
                style: new TextStyle(fontSize: 25, color: Colors.black),
                textAlign: TextAlign.center,                  
              ),
            ),
          ],
        ),
        onPressed: () {_asyncSimpleDialog(context, name);}
      )
    );
  }

  //On Button Click Popop
  //Not sure how to get this Promise
  Future<Response> _asyncSimpleDialog(context, name) async {
    return await showDialog<Response>(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return SimpleDialog(
            title: Text(name),
            children: <Widget>[
              // Check if benched to disable
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Response.Captain);
                },
                child: const Text('Captain'),
              ),
              // Need two ways to handle - into pitch / off
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Response.Substitute);
                },
                child: const Text('Substitute'),
              ),
              // Navigate - Player stats
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Response.Stats);
                },
                child: const Text('Player Stats'),
              ),
              // Navigate - transfer
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


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.blue[700],
          title: new Text("My Team"),
        ),

        body: SizedBox(
          height: 700,
          child: GridView.count(         
          primary: true,
          crossAxisCount: 1,
          childAspectRatio: 4.5,
          mainAxisSpacing: 0,
          crossAxisSpacing: 20,
          padding: const EdgeInsets.all(5.5),
          children: <Widget>[
            
            //Transfer and points info
            SizedBox(
              height: 10,
              child: Card(
                color: Colors.purple,
                child: Center( child: Text("Some info about team"),),
              ),
            ),
            

            // Row for each position in team
            Row(
              children: <Widget>[
                getStructuredGridCell(players[0], captain == 0, Colors.red, context),
                getStructuredGridCell(players[1], captain == 1, Colors.red, context),
              ],
            ),
            
            Row(
              children: <Widget>[
                getStructuredGridCell(players[2], captain == 2, Colors.orange, context),
                getStructuredGridCell(players[3], captain == 3, Colors.orange, context),
              ],
            ),

            Row(
              children: <Widget>[
                getStructuredGridCell(players[4], captain == 4, Colors.yellow, context),
                getStructuredGridCell(players[5], captain == 5, Colors.yellow, context),
              ],
            ),              
            
            // Substitute
            Container( 
              color: Colors.purple,
              child: getStructuredGridCell(players[6], false, Colors.grey, context)
            ),
            
            //Boosts
            SizedBox(
              height: 10,
              child: Card(
                color: Colors.purple,
                child: Center( child: Text("Boosts"),),
              ),
            ),

          ]  
        )
      )
    );
  }


}


