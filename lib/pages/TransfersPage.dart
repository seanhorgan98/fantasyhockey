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

  _buildListItem(BuildContext context, int index) {
    return StreamBuilder(
      stream: Firestore.instance.collection("Players").orderBy(sortBy, descending: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(!snapshot.hasData) {return const Text('Loading...');}
        if(snapshot.data.documents[index].documentID == teamData['players'][outIndex]) {
          return new Container(width: 0, height: 0);
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              child: Text(snapshot.data.documents[index].documentID), 
              onPressed: confirmTransfer(snapshot.data.documents[index])
              ),
            Text(snapshot.data.documents[index]['price'].toString()),
            Text(snapshot.data.documents[index]['totalPoints'].toString()),
            Text(snapshot.data.documents[index]['appearances'].toString()),
          ],
        );
      },
    );
  }

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

  Widget _addHeader(String text, int index){
    return RaisedButton(
      child: Text(text),
      color: Colors.blueGrey[200],
      onPressed: () {
        sortData(index);
      }
    );
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

  confirmTransfer(DocumentSnapshot doc){
    //TODO handle transfer confirmation, firestore edits, redirect to team
  }
}
