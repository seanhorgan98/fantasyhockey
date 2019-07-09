import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
enum Response { Captain, Substitute, Stats, Transfer }

class MyTeamPage extends StatefulWidget{
  @override
  MyTeamPageState createState() => new MyTeamPageState();
}

class MyTeamPageState extends State<MyTeamPage> {
  ButtonTheme getStructuredGridCell(index, doc, color, context) {
    String player = doc['players'][index];
    int points = doc['points'][index];
    int cap = doc['captain'];


    String display = player;
    // Special treatment for captain
    if(cap == index){
      display = player + " (C)";
      //Calculate extra points
      //if (triple captain)
      //points * 3
      points = 2 * points;
    }

    //Show weekly score
    display = display + "\n" + points.toString();

    return new ButtonTheme(
      minWidth: 180,
      height: 95,
      child: RaisedButton(
        elevation: 10,
        color: color,
        child: new Center(
              child: new Text(
                display,
                style: new TextStyle(fontSize: 25, color: Colors.black),
                textAlign: TextAlign.center,                  
              ),
            ),
        onPressed: () {
          Future<Response> popup =  _asyncSimpleDialog(context, player);
          popup.then((value) => 
            handleMenuChoice(value, index, doc)).catchError((error) => 
              handleMenuChoiceError(error));

          }
      )
    );
  }

  //On Button Click Popop
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

  Widget _buildDisplay(BuildContext context, DocumentSnapshot doc){
    return SafeArea(
      child: Column(
        //padding: EdgeInsets.all(15),
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:<Widget>[
          //Transfer and points info
          SizedBox(
            height: 100,
            child: Card(
              color: Colors.purple,
              child: Center(
                child: 
                  Text("GW:" + doc['totals'][0].toString()+ "\nTotal:" + doc['totals'][1],
                    style: TextStyle(fontSize: 30),
                    textAlign: TextAlign.center,
                  )
                ,),
            ),
          ),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[    
                getStructuredGridCell(0, doc, Colors.red, context),
                getStructuredGridCell(1, doc, Colors.red, context),            
              ],
            ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[    
              getStructuredGridCell(2, doc, Colors.orange, context),
              getStructuredGridCell(3, doc, Colors.orange, context),            
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              getStructuredGridCell(4, doc, Colors.yellow, context),
              getStructuredGridCell(5, doc, Colors.yellow, context),              
            ],
          ),



          // Substitute
          Container( 
            color: Colors.purple,
            child: getStructuredGridCell(6, doc, Colors.grey, context)
          ),
          
          //Boosts
          SizedBox(
            height: 50,
            child: Card(
              color: Colors.purple,
              child: Center( child: Text("Boosts", style: TextStyle(fontSize: 30),),),
            ),
          ),

        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('testTeam').snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData) {return const Text('Loading...');}
        return Builder(
          builder: (BuildContext context) {
            return _buildDisplay(context, snapshot.data.documents[0]);
          }
        );
      } 
    );
  }


  /*
  This is where all the navigation / data handdling
  for clicking on players happens
  Captain is finished
  Sub TODO tomorrow
  Stats is future priority
  Transfers needs more work done for it but high priority
  */
  handleMenuChoice(Response value, index, doc) {

    if (value == Response.Captain) { 
      //check if valid player to make captain
      if (index == 6 || index == doc['captain']) {return;}

      //Bunch of nonsense to avoid race conditions
      //Copied straight from tutorial
      Firestore.instance.runTransaction((transaction) async {
        DocumentSnapshot freshSnap = 
          await transaction.get(doc.reference);
        await transaction.update(freshSnap.reference, {
          //make captain index
          'captain': index,
        });
      });
      

    } else if (value == Response.Substitute ) {
      if(index == 6){
        /*
          To substitute the sub will have to open firestore to player data and do if's on that
        */
        // Give choice of same position
        //swap choice with 6
    } else {
        // swap index with 6
    }
    } else if (value == Response.Stats) {
      //Do nothing

    } else if (value == Response.Transfer) {
      //Do nothing for now

    }
    
  }

  handleMenuChoiceError(error) {
      //wtf do you do with errors lol
  }
}

