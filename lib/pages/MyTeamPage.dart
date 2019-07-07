import 'package:flutter/material.dart';
enum Response { Captain, Substitute, Stats, Transfer }

class MyTeamPage extends StatefulWidget{
  @override
  MyTeamPageState createState() => new MyTeamPageState();
}

class MyTeamPageState extends State<MyTeamPage> {

   //Filler Data, Will need to be loaded from DB
  List teamPlayers = ["Adshead", "Cabbage", "Horgan", "Montgomery", "SOH", "Bond", "TB3"];
  List teamPoints = [-2, 4, 2, 5, 8, 6, 15];
  int captain = 2;

  ButtonTheme getStructuredGridCell(player, points, captain, color, context) {
    // Special treatment for captain
    if(captain){
      //Display
      //TODO - Decide which of these looks better
        player = player + "\n(Captain)";
        //player = player + " (C)";

        //Calculate extra points
        //if (triple captain)
        //points * 3
        points = 2 * points;
    }

    //Show weekly score
    player = player + "\n" + points.toString();

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
                player,
                style: new TextStyle(fontSize: 25, color: Colors.black),
                textAlign: TextAlign.center,                  
              ),
            ),
          ],
        ),
        onPressed: () {_asyncSimpleDialog(context, player);}
      )
    );
  }

  //On Button Click Popop
  //Not sure how to get this Promise
  Future<Response> _asyncSimpleDialog(context, player) async {
    return await showDialog<Response>(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return SimpleDialog(
            title: Text(player),
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
                getStructuredGridCell(teamPlayers[0], teamPoints[0], captain == 0, Colors.red, context),
                getStructuredGridCell(teamPlayers[1], teamPoints[1], captain == 1, Colors.red, context),
              ],
            ),
            
            Row(
              children: <Widget>[
                getStructuredGridCell(teamPlayers[2], teamPoints[2], captain == 2, Colors.orange, context),
                getStructuredGridCell(teamPlayers[3], teamPoints[3], captain == 3, Colors.orange, context),
              ],
            ),

            Row(
              children: <Widget>[
                getStructuredGridCell(teamPlayers[4], teamPoints[4], captain == 4, Colors.yellow, context),
                getStructuredGridCell(teamPlayers[5], teamPoints[5], captain == 5, Colors.yellow, context),
              ],
            ),              
            
            // Substitute
            Container( 
              color: Colors.purple,
              child: getStructuredGridCell(teamPlayers[6], teamPoints[6], false, Colors.grey, context)
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


