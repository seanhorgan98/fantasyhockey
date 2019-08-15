import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransferLockPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lock Transfers",),
        backgroundColor: Colors.black,
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: RaisedButton(
              child: Text("Lock", style: TextStyle(fontSize: 40)),
              onPressed: () => getData(lock),
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(),
          ),
          Flexible(
            flex: 2,
            fit: FlexFit.tight,          
            child: RaisedButton(
              child: Text("Unlock", style: TextStyle(fontSize: 40)),
              onPressed:() => getData(unlock),
            )
          ),
          Flexible(
            flex: 1,
            child: Container(),
          ),
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: RaisedButton(
              child: Text("Unlimited", style: TextStyle(fontSize: 40),),
              onPressed: () => getData(unlimit),
            )
          ),
        ],
      )
    );
      
  }

  //function to send all user profiles to setter function
  getData(Function set){
    Firestore.instance.collection("Teams").where(
      "transferSetting", isLessThan: 3).snapshots().take(1).forEach(
        (snapshot) => set(snapshot) );
  }


  /*
  Near identical functions passed by buttons
  Take a snapshot and convert it into useable data
  Then update profile to correct settings
  */
  
  lock(QuerySnapshot snapshot){
    var data = snapshot.documents;
    for( DocumentSnapshot i in data){
      Firestore.instance.runTransaction((transaction) async {
        DocumentSnapshot freshSnap = await transaction.get(i.reference);
        await transaction.update(freshSnap.reference, {
          'transferSetting': 0
        });     
      }); 
    }
  }

  unlock(QuerySnapshot snapshot){
    var data = snapshot.documents;
    for( DocumentSnapshot i in data){
      Firestore.instance.runTransaction((transaction) async {
        DocumentSnapshot freshSnap = await transaction.get(i.reference);
        await transaction.update(freshSnap.reference, {
          'transferSetting': 1
        });     
      }); 
    }
  }

  unlimit(QuerySnapshot snapshot){
    var data = snapshot.documents;
    for( DocumentSnapshot i in data){
      Firestore.instance.runTransaction((transaction) async {
        DocumentSnapshot freshSnap = await transaction.get(i.reference);
        await transaction.update(freshSnap.reference, {
          'transferSetting': 2
        });     
      }); 
    }
  }

}