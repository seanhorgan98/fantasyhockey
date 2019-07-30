import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GameWeek extends StatefulWidget {
  @override
  _GameWeekState createState() => _GameWeekState();
}

class _GameWeekState extends State<GameWeek> {

  _buildListItem(BuildContext context, int index){
    return StreamBuilder(
      stream: Firestore.instance.collection("Players").orderBy("gw", descending: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(!snapshot.hasData) {return const Text('Loading...');}
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text((index+1).toString() + ". "),
            Text(snapshot.data.documents[index].documentID),
            Text(snapshot.data.documents[index]['gw'].toString()),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text("Top Game Week"),
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
            ),
      ),
    );
  }
}