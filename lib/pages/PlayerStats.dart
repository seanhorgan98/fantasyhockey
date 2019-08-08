import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PlayerStats extends StatefulWidget{
  @override
  PlayerStatsState createState() => new PlayerStatsState();
}

class PlayerStatsState extends State<PlayerStats>{

  _buildListItem(BuildContext context, int index) {
    return StreamBuilder(
      stream: Firestore.instance.collection("Players").orderBy("totalPoints", descending: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(!snapshot.hasData) {return const Text('Loading...');}
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Flexible(child: Text(snapshot.data.documents[index].documentID), flex: 3, fit: FlexFit.tight),
            Expanded(child: Text(snapshot.data.documents[index]['goals'].toString()), flex: 1),
            Expanded(child: Text(snapshot.data.documents[index]['gw'].toString()), flex: 1),
            Expanded(child: Text(snapshot.data.documents[index]['totalPoints'].toString()), flex: 1),
            Expanded(child: Text(snapshot.data.documents[index]['appearances'].toString()), flex: 1),
            Expanded(child: Text(snapshot.data.documents[index]['motms'].toString()), flex: 1)
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

            return ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.all(15),
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) =>
                _buildListItem(context, index),
                separatorBuilder: (BuildContext context, int index) => Divider(height: 15,),
            );
          }
        ),
      )
    );  
  }
}