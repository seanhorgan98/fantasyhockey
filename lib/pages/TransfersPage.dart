import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fantasy_hockey/classes/PlayerList.dart';

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
  String sortBy = "price";
  PlayerList players;


  @override
  void initState() {

    var position;
    if (outIndex < 2) { position = 0;}
    else if (outIndex == 2 || outIndex == 3) { position = 1; }        
    else if (outIndex == 4 || outIndex == 5) { position = 2; }
    //if sold player is sub, ignore filter
    else if (outIndex == 6) { position = 3; }


    Firestore.instance.collection("Players").getDocuments().then(
      (snapshot) => buildState(snapshot, position)

    );
    super.initState();
  }

  void buildState(QuerySnapshot snapshot, int position){
    var tempPlayers;
    tempPlayers = new PlayerList(snapshot);
    tempPlayers = tempPlayers.filterPos(position);
    print("got here");
    setState(() {
      players = tempPlayers.sort(sortBy);
    });
  }


  @override
  Widget build(BuildContext context) {

    while(players == null){
      return CircularProgressIndicator();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Transfers", style: TextStyle(fontFamily: 'Titillium')),
      ),
      body: Container(
        margin: EdgeInsets.all(4),
        child: Column(
          children: <Widget>[
            _addHeaderInfo(context),
            _buildHeaders(),
                  
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(5),
                itemCount: players.getLength(),
                itemBuilder: (context, index) =>
                  _buildListItem(context, index),
              ),
            ),
          ],
        )
          
      )
    );  
  }

  
  //builds information to go above table
  Widget _addHeaderInfo(BuildContext context){
    String outPlayerName = (teamData['players'][outIndex]);
    //Next line breaks
    int budget = teamData['prices'][outIndex] + teamData['transfers'][1];
    String transfers;
    if(teamData['transferSetting'] == 2){
      transfers = "∞";
    } else {
      transfers = teamData['transfers'][0].toString();
    }
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
    var headers = ['Name', 'Price', 'Points', 'Played'];
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
        players = players.sort(sortBy);
      });
    } else if(column == 2){
      setState(() {
        sortBy = "totalPoints";
        players = players.sort(sortBy);
      });
    } else if(column == 3) {
      setState(() {
        sortBy = "apps";
        players = players.sort(sortBy);
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

    // //filter out null player
    if(players.getPlayer(index).getName() == "No Player"){
      return Container();
    }

    //Filter out team mates
    if (teamData['players'].contains(players.getPlayer(index).getName())){
      return Container();
    }
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      
      children: <Widget>[
        Flexible(
          flex: 4,
          fit: FlexFit.tight,
          child: RaisedButton(
            child: Column(
              children: <Widget>[
                Text(players.getPlayer(index).getName().split(" ")[0],
                style: TextStyle(fontSize: nameSize),
                ),
                Text(players.getPlayer(index).getName().split(" ")[1],
                style: TextStyle(fontSize: nameSize),
                )
              ] 
            ), 
            onPressed: () {
            Future<int> popup = _asyncConfirmPopup(context, players.getPlayer(index).getName());
            popup.then((value) => 
              confirmTransfer(value, players.getPlayer(index))).catchError((error) 
              => confirmError(error));
            }
          ),
        ), 
        Expanded(
          flex: 3,
          child : Center(child:Text(players.getPlayer(index).getPrice().toString())),
        ),
        Expanded(
          flex: 3,
          child : Center(child:Text(players.getPlayer(index).getTotal().toString())),
        ),
        Expanded(
          flex: 3,
          child : Center(child:Text(players.getPlayer(index).getApps().toString())),
        ),
      ]
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
  void confirmTransfer(int value, NamePoints player){
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
    if ((teamData['transfers'][1] + teamData['prices'][outIndex]) < player.getPrice() ) {
      _ackAlert(context, 'Invalid Transfer', 'Player too expensive');
      return;
    }


    //update number of transfers left
    var transfers = teamData['transfers'];
    if(teamData['transferSetting'] == 1){
      transfers[0] = transfers[0] - 1;
    }
    //update prices and budget
    var prices = teamData['prices'];
    transfers[1] = transfers[1] + prices[outIndex] - player.getPrice();
    prices[outIndex] = player.getPrice();

    //update players, points and sub position
    var players = teamData['players'];
    players[outIndex] = player.getName();
    var points = teamData['points'];
    points[outIndex] = player.getGWPoints();
    var sub = teamData['sub'];
    if(outIndex == 6){
      sub = player.getPosition();
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
