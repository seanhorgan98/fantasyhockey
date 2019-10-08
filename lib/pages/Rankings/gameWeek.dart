import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GameWeek extends StatefulWidget {
  @override
  _GameWeekState createState() => _GameWeekState();
}

class _GameWeekState extends State<GameWeek> {

  _buildListItem(BuildContext context, int index, AsyncSnapshot snapshot){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(child: Text("\t" + (index+1).toString() + ". "), flex: 2),
        Flexible(child: Text(snapshot.data.documents[index].documentID), flex: 6, fit: FlexFit.tight),
        Expanded(child: Text(snapshot.data.documents[index]['gw'].toString()), flex: 3)            
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text("Game Week"),
        ),
        body: Container(
              child: StreamBuilder(
                stream: Firestore.instance.collection("Players").where("gw", isGreaterThan: -1).orderBy("gw", descending: true).snapshots(),
                builder: (context, snapshot){
                  if(!snapshot.hasData) {return const Text("Loading...");}

                  return ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(15),
                    itemCount: (snapshot.data.documents.length),
                    itemBuilder: (context, index) =>
                      _buildListItem(context, index, snapshot),
                    separatorBuilder: (BuildContext context, int index) => Divider(height: 15,),
                  );
                }
              ),
            ),
      ),
    );
  }
}