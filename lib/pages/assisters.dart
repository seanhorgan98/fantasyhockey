import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Assisters extends StatefulWidget {
  @override
  _AssistersState createState() => _AssistersState();
}

class _AssistersState extends State<Assisters> {
  
  _buildListItem(BuildContext context, int index){
    return StreamBuilder(
      stream: Firestore.instance.collection("Players").orderBy("assists", descending: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(!snapshot.hasData) {return const Text('Loading...');}
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text((index+1).toString() + ". "),
            Text(snapshot.data.documents[index].documentID),
            Text(snapshot.data.documents[index]['assists'].toString()),
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
          title: Text("Top Assisters"),
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