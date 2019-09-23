import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GoalScorers extends StatefulWidget {
  @override
  _GoalScorersState createState() => _GoalScorersState();
}

class _GoalScorersState extends State<GoalScorers> {

  _buildListItem(BuildContext context, int index, AsyncSnapshot snapshot){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(child: Text("\t" + (index+1).toString() + ". "), flex: 2),
        Flexible(child: Text(snapshot.data.documents[index].documentID), flex: 6, fit: FlexFit.tight),
        Expanded(child: Text(snapshot.data.documents[index]['goals'].toString()), flex: 3)            
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text("Top Goal Scorers"),
        ),
        body: Container(
              child: StreamBuilder(
                stream: Firestore.instance.collection("Players").where("goals", isGreaterThan: -1).orderBy("goals", descending: true).snapshots(),
                builder: (context, snapshot){
                  if(!snapshot.hasData) {return const Text("Loading...");}

                  return ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(15),
                    itemCount: snapshot.data.documents.length,
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