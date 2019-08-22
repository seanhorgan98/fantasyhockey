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
              onPressed: () => getData(0),
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
              onPressed:() => getData(1),
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
              onPressed: () => getData(2),
            )
          ),
          Flexible(
            flex: 1,
            child: Container(),
          ),
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Container(
              alignment: Alignment.bottomCenter,
              margin: new EdgeInsets.symmetric(horizontal: 30, vertical: 7),
              height: 50,
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                color: Theme.of(context).accentColor,
                onPressed: endGW,
                child: Text("End GW", style: TextStyle(fontSize: 18, fontFamily: 'Titillium')),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(),
          ),
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Container(
              alignment: Alignment.bottomCenter,
              margin: new EdgeInsets.symmetric(horizontal: 30, vertical: 7),
              height: 50,
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                color: Theme.of(context).accentColor,
                onPressed: startGW,
                child: Text("Start GW", style: TextStyle(fontSize: 18, fontFamily: 'Titillium')),
              ),
            ),
          )  
        ]
      )
    );
      
  }



  /*
  First function gets data for section function to handle
  Adds gw to total - only time total is changed
  */
  void endGW(){
    Firestore.instance.collection('Teams').getDocuments().then( 
      (snap) => eachUserEnd(snap)
    );

    Firestore.instance.collection('Players').getDocuments().then(
      (snap) => eachEndPlayer(snap)
    );
  }

  void eachEndPlayer(QuerySnapshot snapshot){
    WriteBatch batch = Firestore.instance.batch();
    for(DocumentSnapshot player in snapshot.documents){
      if(player.documentID == 'No Player'){
        continue;
      }

      int newTotal = player['totalPoints'] + player['gw'];

      DocumentReference uRef = player.reference;
      batch.updateData(uRef, {
        "totalPoints": newTotal
      });
    }
    batch.commit();
  }

  void eachUserEnd(QuerySnapshot snapshot){
    for (DocumentSnapshot user in snapshot.documents){
      if(user.documentID == '000'){
        continue;
      }
      
      List totalList = user['totals'];
      var newList = [totalList[0], totalList[1] + totalList[0] ];
      
      //write
      Firestore.instance.runTransaction( (transaction) async {
        DocumentSnapshot freshSnap = await transaction.get(user.reference);
        transaction.update(freshSnap.reference, {
          'totals': newList
        });
      });
    }
  }




  /*
  First function gets data for section function to handle
  sets gw to 0 
  */
  void startGW(){
    Firestore.instance.collection('Players').getDocuments().then( 
      (snap) => eachUserStart(snap)
    );
  }

  void eachUserStart(QuerySnapshot snapshot){
    WriteBatch batch = Firestore.instance.batch();
    for (DocumentSnapshot player in snapshot.documents){
      //Skip empty player
      if(player.documentID == 'No Player'){
        continue;
      }
      //reset player gw
      DocumentReference uRef = player.reference;
      batch.updateData(uRef, {
        "gw": 0
      });
    }
    //finish writes
    batch.commit();
  }



  //Functions for Transfer Setting handling

  //Get Teams Document and send to set
  getData(int value){
    Firestore.instance.collection("Teams").snapshots().take(1).forEach(
      (snapshot) => set(snapshot, value) 
    );
  }

  //  Set all transferSetting values to value
  void set(QuerySnapshot snapshot, int value){
    WriteBatch batch = Firestore.instance.batch();
    var data = snapshot.documents;
    for( DocumentSnapshot i in data){
      DocumentReference iref = i.reference;
      batch.updateData(iref, {'transferSetting': value});
    }
    batch.commit();
  }


}
