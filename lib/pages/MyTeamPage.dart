import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasy_hockey/pages/auth.dart';
import 'package:flutter/material.dart';
import 'package:fantasy_hockey/pages/TransfersPage.dart';

enum Response { Captain, Substitute, Stats, Transfer }

class MyTeamPage extends StatefulWidget{
  //Constructor
  MyTeamPage({this.auth});
  final BaseAuth auth;
  @override
  MyTeamPageState createState() => new MyTeamPageState();
}

class MyTeamPageState extends State<MyTeamPage> {

  String teamID = "000";

  @override
  void initState() {
    super.initState();
    teamID="000";
    _getCurrentUser(widget.auth);
  }

  _getCurrentUser(BaseAuth auth) async{
    String test = await auth.currentUser();   
    Firestore.instance.collection("Users").document(test).get().then((snapshot){
      setState(() {
        teamID = snapshot.data['team'];
      });
    });

  }
  
  /*
    Main Build Method, Starts Widget
    Calls BuildDisplay and reloads when user team db page changes
  */
  
  @override
  Widget build(BuildContext context) {

    while(teamID == "000"){
      return new Center(child: new CircularProgressIndicator());
    }
    
    return StreamBuilder(
      stream: Firestore.instance.collection('Teams').document(teamID).snapshots(),
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting) {
          return new Center(child: new CircularProgressIndicator());
        } 
        var userDocument = snapshot.data;
        return Builder(
          builder: (BuildContext context) {
            return _buildDisplay(context, userDocument);
          }
        );
      } 
    );
    
  }

  /*
    Secondary Build Widget
    In charge of layout and elements
    Called by build
    Calls getStructuredGridCell
  */
  Widget _buildDisplay(BuildContext context, DocumentSnapshot doc){
    double fontHead = 22;
    double fontBody = 18; 
    if(MediaQuery.of(context).size.height < 850 ){
      fontHead = 14;
      fontBody = 10;
    }

    var transfers = doc ['transfers'][0].toString() + "\nTransfers";
    // Check if unlimited transfers
    if(doc['transferSetting'] == 2){
      transfers = "∞\nTransfers";
    }
    //Header update
    var headerGW = doc['totals'][0].toString() + "\nGW";
    var headerBudget = "£" + doc['transfers'][1].toString() + "m" + "\nBudget";
    var headerTotal = doc['totals'][1].toString() + "\nTotal";
    var headerTransfers = transfers;

    double headerBarHeight = 35.0;

    //Building Display
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children:<Widget>[

          //Team Name

          Flexible(flex: 1, child: Container(),),

          Flexible(
            fit: FlexFit.loose,
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5)
              ),
              width: MediaQuery.of(context).size.width*0.9,
              height: 50,

              child: Container(
                alignment: Alignment.center,
                child:Text(doc['teamName'], style: TextStyle(fontSize: fontHead, fontFamily: 'Titillium', fontWeight: FontWeight.bold))
                )
            ),
          ),

          Flexible(flex: 1, child: Container(),),

          Flexible(
            fit: FlexFit.loose,
            flex: 4,
            child: Container(
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  //Budget display
                  Expanded(child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      headerBudget,
                      style: TextStyle(fontSize: fontBody, fontFamily: 'Titillium'),
                      textAlign: TextAlign.center,
                    ),
                  ),),

                  //Vertical Divider
                  Container(color: Colors.grey, height: headerBarHeight, width: 1,),

                  //Transfers display
                  Expanded(child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      headerTransfers,
                      style: TextStyle(fontSize: fontBody, fontFamily: 'Titillium'),
                      textAlign: TextAlign.center,
                    ),
                  ),),

                  //Vertical Divider
                  Container(color: Colors.grey, height: headerBarHeight, width: 1,),

                  //GW display
                  Expanded(child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      headerGW,
                      style: TextStyle(fontSize: fontBody, fontFamily: 'Titillium'),
                      textAlign: TextAlign.center,
                    ),
                  ),),

                  //Vertical Divider
                  Container(color: Colors.grey, height: headerBarHeight, width: 1,),
                  
                  //Total Points display
                  Expanded(child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      headerTotal,
                      style: TextStyle(fontSize: fontBody, fontFamily: 'Titillium'),
                      textAlign: TextAlign.center,
                    ),
                  ),)
                ],
              ),
            ),
          ),

          Flexible(flex: 1, child: Container(),),

          Expanded(
            flex: 35,
            child: Container(
              width: MediaQuery.of(context).size.width*0.9,
              height: MediaQuery.of(context).size.height*0.6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Defenders",  
                    style: TextStyle(fontFamily: 'Titillium', fontWeight: FontWeight.bold, color: Colors.white, fontSize: fontBody),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Expanded(flex: 1,child: Container(),),
                      getStructuredGridCell(0, doc, Colors.white, context),
                      Expanded(flex: 1,child: Container(),),
                      getStructuredGridCell(1, doc, Colors.white, context),
                      Expanded(flex: 1,child: Container(),),          
                    ],
                  ),

                  Text(
                    "Midfielders",
                    style: TextStyle(fontFamily: 'Titillium', fontWeight: FontWeight.bold, color: Colors.white, fontSize: fontBody),

                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Expanded(flex: 1,child: Container(),),
                      getStructuredGridCell(2, doc, Colors.white, context),
                      Expanded(flex: 1,child: Container(),),
                      getStructuredGridCell(3, doc, Colors.white, context),
                      Expanded(flex: 1,child: Container(),),          
                    ],
                  ),

                  Text(
                    "Attackers",
                    style: TextStyle(fontFamily: 'Titillium', fontWeight: FontWeight.bold, color: Colors.white, fontSize: fontBody),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Expanded(flex: 1,child: Container(),),
                      getStructuredGridCell(4, doc, Colors.white, context),
                      Expanded(flex: 1,child: Container(),),
                      getStructuredGridCell(5, doc, Colors.white, context),
                      Expanded(flex: 1,child: Container(),),          
                    ],
                  ),

                  Text(
                    "Flex",
                    style: TextStyle(fontFamily: 'Titillium', fontWeight: FontWeight.bold, color: Colors.white, fontSize: fontBody),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Expanded(flex: 1,child: Container(),),
                      getStructuredGridCell(6, doc, Colors.white, context),
                      Expanded(flex: 1,child: Container(),),      
                    ],
                  ),
                  
                  
                ],

              ),
            ),
          ),

          Flexible(flex: 1, child: Container(),),

          ]
      )
    );
  }


  /*
    Builds individual buttons for player data
    Called by _buildDisplay
    calls _asyncSimpleDialog onclick
    calls _handleMenuChoice to deal with menu response
  */
  ButtonTheme getStructuredGridCell(int index, DocumentSnapshot doc, Color color, BuildContext context) {
    String player = doc['players'][index].toString();
    String points = doc['points'][index].toString();
    String price = "£" + doc['prices'][index].toString();
    int cap = doc['captain'];
    double size = 18;
    int setting = doc['transferSetting'];

    double fontBody = 18; 
    double captain  = 18;
    if(MediaQuery.of(context).size.height < 850 ){
      fontBody = 12;
      captain = 12;
    }

    String display = player;
    // Special treatment for captain
    if(cap == index){
      display = display + " (C)";
    }
    if(display.length > 15){
      captain = 10;
    }
    //Check if transfers enabled
    if(setting == 1){ 
      points = "Last Week: " + points;
    } else {
      points = "This Week: " + points;
    } 

    return new ButtonTheme(
      child: Expanded(
        flex: 9,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.grey, width: 0.5),
            color: Colors.white,
          ),
          child: MaterialButton(            
            child: new Column(
                  children: <Widget>[
                    Text(display, style: TextStyle(fontSize: captain, color: Colors.black, fontFamily: 'Titillium', fontWeight: FontWeight.bold)),
                    Text(points, style: TextStyle(fontSize: fontBody, color: Colors.black, fontFamily: 'Titillium')),
                    Text(price, style: TextStyle(fontSize: fontBody, color: Colors.black, fontFamily: 'Titillium'))
                  ] 
                    //textAlign: TextAlign.center,                  
                ),
            onPressed: () {
              Future<Response> popup =  _asyncSimpleDialog(context, player);
              popup.then((value) => 
                _handleMenuChoice(value, index, doc)).catchError((error) => 
                  _handleMenuChoiceError(error));
              }
            ),
        ),
        ),
      );
  }

  /*
    Handles Menu Responses
    Called by getStructuredGridCell onclick
    calls 1 of 4 handler functions
    If error - _handleMenuChoiceError
    NULLs ignored safely
  */
  void _handleMenuChoice(Response value, int index, DocumentSnapshot doc) {
    if (value == Response.Captain) { 
      _handleCaptainResponse(index, doc);
    } else if (value == Response.Substitute ) {
      _handleSubstituteResponse(index, doc);
    } else if (value == Response.Stats) {
      _handleStatsResponse(index, doc);
    } else if (value == Response.Transfer) {
      _handleTransferResponse(index, doc);
    }
  }
  
  /*
    Simple Error handler with basic message and error as string
  */  
  void _handleMenuChoiceError(Error error) {
      _ackAlert(context,  "Error",  "Something went wrong\n" + error.toString());
  }

  /*
    Handler function for each response
    Called by _handleMenuChoice
    Substitute has helper function - _makeSub
    NULL handled safely
  */
  void _handleCaptainResponse(int index, DocumentSnapshot doc){
    //check if valid player to make captain
    if (index == 6 || index == doc['captain']) {
      _ackAlert(context,  "Invalid Sub",  "Invalid Player to make Captain");
      return;
    }
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
  }

  void _handleSubstituteResponse(int index, DocumentSnapshot doc){
    //Handle subbing sub
    if(index == 6){
      int position = doc['sub'];
      if (position == 0){
        Future<int> popup =  _asyncSimpleDialogSubs(context, doc['players'][0], doc['players'][1]);
        popup.then((value) => 
          _makeSub(value, doc, 0)).catchError((error) => 
            _handleMenuChoiceError(error));
      } else if (position == 1) {
        Future<int> popup =  _asyncSimpleDialogSubs(context, doc['players'][2], doc['players'][3]);
        popup.then((value) =>
          _makeSub(value, doc, 1)).catchError((error) => 
            _handleMenuChoiceError(error));
      } else if (position == 2) {
        Future<int> popup =  _asyncSimpleDialogSubs(context, doc['players'][4], doc['players'][5]);
        popup.then((value) => 
          _makeSub(value, doc, 2)).catchError((error) => 
            _handleMenuChoiceError(error));
      }
    //swap choice with 6
    } else if(doc['sub']*2 == index || doc['sub']*2 == index -1 ) {
      _makeSub(index, doc, 0);
    } else {
      // Handle Invalid Sub
      _ackAlert(context,  "Invalid Sub",  "Substitute can't come on for this Player");
    }
  }

  void _handleStatsResponse(int index, DocumentSnapshot doc){
    _ackAlert(context,  "Coming Soon",  "Low Priotity");
  }

  void _handleTransferResponse(int index, DocumentSnapshot doc){
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => 
        TransfersPage(outIndex: index, teamData: doc)));
  }
  
  /*
    Helper method for _handleSubstituteResponse
    Null index handled
  */  
  void _makeSub(int index, DocumentSnapshot doc, int position){
    // Handle normal sub
    if(index == null) {
      return;
    } else {
      index = index + 2*position;
    }
    var players = doc['players'];
    var points = doc['points'];
    var prices = doc['prices'];
    var temp = [players[index], points[index], prices[index]];
    players[index] = players[6];
    points[index] = points[6];
    prices[index] = prices[6];
    players[6] = temp[0];
    points[6] = temp[1];
    prices[6] = temp[2];
    // swap index with 6
    Firestore.instance.runTransaction((transaction) async {
      DocumentSnapshot freshSnap = await transaction.get(doc.reference);
      await transaction.update(freshSnap.reference, {
        'points': points,
        'players': players,
        'prices' : prices,           
      });     
    });   
  }
  
  /*
    Methods for popups
    Copied from example online
  */  
  //On Button Click Popop
  Future<Response> _asyncSimpleDialog(BuildContext context, String player) async {
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

  //Popup for attempting to sub bench player
  Future<int> _asyncSimpleDialogSubs(BuildContext context, String player1, String player2) async {
    return await showDialog<int>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select Player to Sub out '),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 0);
              },
              child: Text(player1),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 1);
              },
              child: Text(player2),
            ),
          ],
        );
      });
  }
  
  //Simple Popup Messages
  Future<void> _ackAlert(BuildContext context, String alertTitle, String alert) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(alertTitle),
          content: Text(alert),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  

}
