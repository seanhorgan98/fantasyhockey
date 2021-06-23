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
            child: RaisedButton(
              child: Text("Add Transfer", style: TextStyle(fontSize: 40),),
              onPressed: () => addTransfer(),
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


  addTransfer(){
    Firestore.instance.collection("Teams").getDocuments().then(
      (snapshot) => increaseTransfers(snapshot) 
    );
  }

  increaseTransfers(QuerySnapshot snapshot){
    WriteBatch batch = Firestore.instance.batch(); 
    for( DocumentSnapshot team in snapshot.documents){
      //if(team['teamName'] != 'Horgan Donors' ){continue;} 
      var newValue;
      switch(team['transfers'][0]) { 
        case 0: { 
          newValue = 1;
        } 
        break; 
        
        case 1: { 
          newValue = 2;
        } 
        break; 
            
        case 2: { 
          newValue = 2; 
        }
        break;
      }
      var oldData = team['transfers'];
      var newData = [newValue, oldData[1]];
      DocumentReference iref = team.reference;
      batch.updateData(iref, {'transfers': newData});
    }
    batch.commit();
  }


  /*
  First function gets data for section function to handle
  Adds gw to total - only time total is changed
  */
  void endGW() async{
    await Firestore.instance.collection('Teams').getDocuments().then( 
      (snap) => eachUserEnd(snap)
    );

    await Firestore.instance.collection('Players').getDocuments().then(
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
    WriteBatch batch = Firestore.instance.batch();
    for (DocumentSnapshot user in snapshot.documents){
      if(user.documentID == '000'){
        continue;
      }
      
      List totalList = user['totals'];
      var newList = [totalList[0], totalList[1] + totalList[0] ];
      
      //write
      DocumentReference uRef = user.reference;
      batch.updateData(uRef, {
        'totals': newList
      });
    }
    batch.commit();
  }




  /*
  First function gets data for section function to handle
  sets gw to 0 
  */
  void startGW() async {
    await Firestore.instance.collection('Teams').getDocuments().then( 
      (snap) => eachUserStart(snap)
    );

    await Firestore.instance.collection('Players').getDocuments().then(
      (snap) => eachPlayerStart(snap)
    );
  }

  void eachPlayerStart(QuerySnapshot snapshot){
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

  void eachUserStart(QuerySnapshot snapshot){
    WriteBatch batch = Firestore.instance.batch();
    for (DocumentSnapshot user in snapshot.documents){
      if(user.documentID == '000'){
        continue;
      }
      
      List totalList = user['totals'];
      var newList = [0, totalList[1] ];
      
      //write
      DocumentReference uRef = user.reference;
      batch.updateData(uRef, {
        'totals': newList
      });
    }
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
