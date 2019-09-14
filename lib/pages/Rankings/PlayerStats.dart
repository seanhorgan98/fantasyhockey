import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PlayerStats extends StatefulWidget{
  @override
  PlayerStatsState createState() => new PlayerStatsState();
}

class PlayerStatsState extends State<PlayerStats>{

  String sortField = "totalPoints";

  _buildListItem(BuildContext context, int index, AsyncSnapshot snapshot) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Flexible(child: Text(snapshot.data.documents[index].documentID), flex: 2, fit: FlexFit.tight),
        Expanded(child: Center(child: Text(snapshot.data.documents[index]['gw'].toString())), flex: 1),
        Expanded(child: Center(child: Text(snapshot.data.documents[index]['totalPoints'].toString())), flex: 1),
        Expanded(child: Center(child: Text(snapshot.data.documents[index]['appearances'].toString())), flex: 1),
        Expanded(child: Center(child: Text(snapshot.data.documents[index]['motms'].toString())), flex: 1)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    while(sortField == null){
      return Center(child: CircularProgressIndicator());
    }

    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Player Stats", style: TextStyle(fontFamily: 'Titillium')),
      ),
      body: Container(
        child: StreamBuilder(
          stream: Firestore.instance.collection("Players").where(sortField, isGreaterThan: -1).orderBy(sortField, descending: true).snapshots(),
          builder: (context, snapshot){
            if(!snapshot.hasData) {return const Text("Loading...");}

            return Column(
              children: <Widget>[
                headerRow(),

                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(15),
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) =>
                      _buildListItem(context, index, snapshot),
                      separatorBuilder: (BuildContext context, int index) => Divider(height: 15,),
                  ),
                ),
              ],
            );
          }
        ),
      )
    );  
  }

  Widget headerRow(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Flexible(child: Center(child: Text("Name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),)), flex: 2, fit: FlexFit.tight),
        header("GW", "gw"),
        header("Total", "totalPoints"),
        header("Apps", "appearances"),
        header("MotM", "motms"),
      ],
    );
  }

  Widget header(String label, String field){
    return Expanded(
      child: Center(
        child: RaisedButton(
          onPressed: () { sort(field); },
          child: Text(label,
            softWrap: false,
            style: TextStyle(
              fontSize: 14
            )
          )
        )
      ), 
      flex: 1
    );
  }

  sort(String field) {
    setState(() {
      sortField = field;
    });
  
  }
}