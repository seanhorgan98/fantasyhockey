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

  int outIndex;
  DocumentSnapshot teamData;
  String sortBy = "totalPoints";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Player Stats", style: TextStyle(fontFamily: 'Titillium')),
      ),
      body: Container(
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
  
  Widget _addHeaderInfo(BuildContext context){
    String outPlayerName = teamData['players'][outIndex];
    int budget = int.parse(teamData['prices'][outIndex]) + int.parse(teamData['transfers'][1]);
    String transfers = teamData['transfers'][0];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text("Remaining Budget:\n" + budget.toString()),
        Text("Transfer Out:\n" + outPlayerName),
        Text("Remaining Transfers:\n" + transfers)
      ]
    );
  }    
  
  Widget _buildHeaders(){
    var headers = ['Name', 'Price', 'Points', 'Games\nPlayed'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _addHeader(headers[0], 0),
        _addHeader(headers[1], 1),
        _addHeader(headers[2], 2),
        _addHeader(headers[3], 3)
      ],
    );
  }

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

  Widget _addHeader(String text, int index){
    return RaisedButton(
      child: Text(text),
      color: Colors.blueGrey[200],
      onPressed: () {
        sortData(index);
      }
    );
  }
  
  Widget _buildListItem(BuildContext context, int index) {
    return StreamBuilder(
      stream: Firestore.instance.collection("Players").orderBy(sortBy, descending: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(!snapshot.hasData) {return const Text('Loading...');}

        if(snapshot.data.documents[index].documentID == teamData['players'][outIndex]) {
          return Container(width: 0, height: 0);
        }

        int position;
        if (outIndex < 2) { position = 0;}
        else if (outIndex > 3) { position = 2; }
        else if (outIndex == 2 || outIndex == 3) { position = 1; }
        else if (outIndex == 6) { position = teamData['sub']; }      
        if(snapshot.data.documents[index]['position'] != position) {
          return Container(width: 0, height: 0);
        }

        if (teamData['players'].contains(snapshot.data.documents[index].documentID)){
          return Container(width: 0, height: 0);
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              child: Text(snapshot.data.documents[index].documentID), 
              onPressed: () {
              Future<int> popup = _asyncConfirmPopup(context, snapshot.data.documents[index].documentID);
              popup.then((value) => 
                confirmTransfer(value, snapshot.data.documents[index])).catchError((error) 
                => confirmError(error));
              }
              ),
            Text(snapshot.data.documents[index]['price'].toString()),
            Text(snapshot.data.documents[index]['totalPoints'].toString()),
            Text(snapshot.data.documents[index]['appearances'].toString()),
          ],
        );
      },
    );
  }

  void confirmTransfer(int value, DocumentSnapshot player){
    //no transfer confirmation
    if (value == null || value == 0) {return;}
    //no remaining transfers
    if (teamData['transfers'][0] == '0'){
      _ackAlert(context, 'Invalid Transfer', 'No remaining transfers');
      return;
    }
    //Transfer too expensive
    if (int.parse(teamData['transfers'][0]) + int.parse(teamData['prices'][outIndex]) < player['price'] ) {
      _ackAlert(context, 'Invalid Transfer', 'Player too expensive');
      return;
    }

    //TODO firestore edits
    //Team x3, sub, transfers, budget

    navigateBack();
  }

  void confirmError(Error err){
    _ackAlert(context,  "Error",  "Something went wrong\n" + err.toString());
  }

  //Popup for attempting to transfer bench player
  Future<int> _asyncConfirmPopup(BuildContext context,String name) async {
    return await showDialog<int>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text("Transfer in:" + name),
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

  void navigateBack(){
    Navigator.pop(context);
  }

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
