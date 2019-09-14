import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TransfersPage extends StatefulWidget{

  final int outIndex;
  final DocumentSnapshot teamData;

  @override
  TransfersPageState createState(){
    return new TransfersPageState(outIndex : outIndex, teamData: teamData);
  }

  TransfersPage({Key key, @required this.outIndex, @required this.teamData}) : super(key: key);
}


class TransfersPageState extends State<TransfersPage>{
  
  TransfersPageState({Key key, @required this.outIndex, @required this.teamData});

  final int outIndex;
  final DocumentSnapshot teamData;
  String sortBy = "totalPoints";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Transfers", style: TextStyle(fontFamily: 'Titillium')),
      ),
      body: Container(
        margin: EdgeInsets.all(4),
        child: StreamBuilder(
          stream: Firestore.instance.collection("Players").snapshots(),
          builder: (context, snapshot){
            if(!snapshot.hasData) {return const Text("Loading...");}
            return ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(5),
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) =>
                _headerCheck(context, index),
            );
          }
        )
      )
    );  
  }

  //used by build to create headers on first run through
  //Need to move this so 
  Widget _headerCheck(BuildContext context, int index){
    if(index == 0){
      return Column(
        children: <Widget>[
          _addHeaderInfo(context),
          _buildHeaders(),
          _buildListItem(context, index)
        ]
      );
    } else {
      return _buildListItem(context, index);
    }
  }
  
  //builds information to go above table
  Widget _addHeaderInfo(BuildContext context){
    String outPlayerName = (teamData['players'][outIndex]);
    //Next line breaks
    int budget = teamData['prices'][outIndex] + teamData['transfers'][1];
    String transfers = teamData['transfers'][0].toString();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text("Budget:\n£${budget.toString()}m"),
        Text("Out:\n$outPlayerName"),
        Text("Transfers:\n${transfers.toString()}")
      ]
    );
  }    
  
  //builds headers
  Widget _buildHeaders(){
    var headers = ['Name', 'Price', 'Points', 'Games\nPlayed'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(child:_addHeader(headers[0], 0), flex: 4, fit: FlexFit.tight),
        Flexible(child:_addHeader(headers[1], 1), flex: 3),
        Flexible(child:_addHeader(headers[2], 2), flex: 3),
        Flexible(child:_addHeader(headers[3], 3), flex: 3)
      ],
    );
  }

  //sorts data by any non name column
  void sortData(int column){
    if(column == 1){
      setState(() {
        sortBy = "price";
      });
    } else if(column == 2){
      setState(() {
        sortBy = "totalPoints";
      });
    } else if(column == 3) {
      setState(() {
        sortBy = "appearances";
      });
    } 
  }

  //adds header button to header bar
  Widget _addHeader(String text, int index){
    double textSize = 14;
    if(MediaQuery.of(context).size.height < 600){
      textSize = 12;
    }
    return RaisedButton(
      child: Text(text, style: TextStyle(fontFamily: 'Titillium', fontSize: textSize),),
      color: Colors.blueGrey[200],
      onPressed: () {
        sortData(index);
      }
    );
  }
  
  //builds a row in table
  Widget _buildListItem(BuildContext context, int index) {
    double nameSize = 14;
    if(MediaQuery.of(context).size.height < 600){
      nameSize = 11;
    }


    return StreamBuilder(
      stream: Firestore.instance.collection("Players").orderBy(sortBy, descending: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        //Get data before printing
        if(!snapshot.hasData) {return const Text('Loading...');}

        // //filter out null player
        if(snapshot.data.documents[index].documentID == "No Player"){
          return Container();
        }

        //If row is player being sold, emitt
        if(snapshot.data.documents[index].documentID == teamData['players'][outIndex]) {
          return Container(width: 0, height: 0);
        }
        //Filter players by position
        int position;
        if (outIndex < 2) { position = 0;}
        else if (outIndex == 2 || outIndex == 3) { position = 1; }        
        else if (outIndex == 4 || outIndex == 5) { position = 2; }
        //if sold player is sub, ignore filter
        else if (outIndex == 6) {position = snapshot.data.documents[index]['position'];}
        if(snapshot.data.documents[index]['position'] != position) {
          return Container(width: 0, height: 0);
        }
        //Filter out team mates
        if (teamData['players'].contains(snapshot.data.documents[index].documentID)){
          return Container(width: 0, height: 0);
        }
        
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          
          children: <Widget>[
            Flexible(
              child: RaisedButton(
                child: Column(
                  children: <Widget>[
                    Text(snapshot.data.documents[index].documentID.split(" ")[0],
                    style: TextStyle(fontSize: nameSize),
                    ),
                    Text(snapshot.data.documents[index].documentID.split(" ")[1],
                    style: TextStyle(fontSize: nameSize),
                    )
                  ] 
                ), 
                onPressed: () {
                Future<int> popup = _asyncConfirmPopup(context, snapshot.data.documents[index].documentID);
                popup.then((value) => 
                  confirmTransfer(value, snapshot.data.documents[index])).catchError((error) 
                  => confirmError(error));
                }
              ),
              flex: 4,
              fit: FlexFit.tight,
            ), 
            Expanded(
              child : Center(child:Text(snapshot.data.documents[index]['price'].toString())),
              flex: 3,
            ),
            Expanded(
              child : Center(child:Text(snapshot.data.documents[index]['totalPoints'].toString())),
              flex: 3,
            ),
            Expanded(
              child : Center(child:Text(snapshot.data.documents[index]['appearances'].toString())),
              flex: 3,
            ),
          ],
        );
      },
    );
  }

  /*
    IMPORTANT FUNCTION
    All validation for transfer goes on here
    Ensures user confirmed transfer
    Ensures valid transfer x3
    Handles Firestore writes to user team
    Returns to Team page
  */
  void confirmTransfer(int value, DocumentSnapshot player){
    //no transfer confirmation
    if (value == null || value == 0) {return;}
    //no remaining transfers
    if (teamData['transfers'][0] == 0 && teamData['transferSetting'] == 1){
      _ackAlert(context, 'Invalid Transfer', 'No remaining transfers');
      return;
    }
    //Transfers Disabled
    if (teamData['transferSetting'] == 0){
      _ackAlert(context, 'Invalid Transfer', 'Transfers disabled');
      return;      
    }
    //Transfer too expensive
    if ((teamData['transfers'][1] + teamData['prices'][outIndex]) < player['price'] ) {
      _ackAlert(context, 'Invalid Transfer', 'Player too expensive');
      return;
    }

    /*Validate team limit
    //update global state holder
    // Garbage, don't try to understand - Probably pretty easy to break somehow
    Firestore.instance.document("/Players/" + teamData['players'][outIndex]).get().then(
      (snapshot) {
        validateTeams(player, snapshot);
      }
    );
    //valiate number of players per team
    //This doesn't work.
    if (teams[player['teams']] >= 3){
      _ackAlert(context, 'Invalid Transfer', 'Too many players from a team');
      Navigator.pop(context);
      return;
    } 
    */

    //update number of transfers left
    var transfers = teamData['transfers'];
    if(teamData['transferSetting'] == 1){
      transfers[0] = transfers[0] - 1;
    }
    //update prices and budget
    var prices = teamData['prices'];
    transfers[1] = transfers[1] + prices[outIndex] - player['price'];
    prices[outIndex] = player['price'];

    //update players, points and sub position
    var players = teamData['players'];
    players[outIndex] = player.documentID;
    var points = teamData['points'];
    points[outIndex] = player['gw'];
    var sub = teamData['sub'];
    if(outIndex == 6){
      sub = player['position'];
    }

    //Write to Firestore
    Firestore.instance.runTransaction((transaction) async {
      DocumentSnapshot freshSnap = await transaction.get(teamData.reference);
      await transaction.update(freshSnap.reference, {
        'transfers': transfers,
        'points': points,
        'players': players,
        'prices' : prices,
        'sub' : sub
      });     
    });   

    navigateBack();
  }

  //used if transfer confirmation popup fails
  void confirmError(Error err){
    _ackAlert(context,  "Error",  "Something went wrong\n" + err.toString());
  }

  //Popup for transfer confirmation
  Future<int> _asyncConfirmPopup(BuildContext context,String name) async {
    return await showDialog<int>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text("Transfer in: " + name),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 1);
              },
              child: Text('Confirm'),
            ),
            Row(),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 0);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      });
  }

  //This is literally pointless
  void navigateBack(){
    Navigator.pop(context);
  }

  // Reused alert popup
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
