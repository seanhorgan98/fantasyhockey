import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasy_hockey/pages/Fixtures.dart';
import 'package:fantasy_hockey/pages/Rules.dart';
import 'package:fantasy_hockey/pages/PlayerStats.dart';
import 'package:fantasy_hockey/pages/Mod.dart';
import 'package:fantasy_hockey/pages/auth.dart';
import 'package:flutter/material.dart';

class StatsPage extends StatelessWidget{
  //Constructor
  StatsPage({this.auth, this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;


  void _signOut() async{
    try{
      await auth.signOut();
      onSignedOut();
    } catch (e){
      print(e);
    }
  }

  Widget buildLeaderWidgets(String queryString){
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Players').orderBy(queryString, descending: true).limit(1).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        return Text(
          //Returning the player name + ": " + number of stat
          (snapshot.data.documents[0].documentID) + ": " + (snapshot.data.documents[0][queryString].toString()),
          style: TextStyle(fontSize: 20, fontFamily: 'Titillium'));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          //Title
          Container(
            padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: Align(
              alignment: Alignment.center,
              child: Text("Statistics", style: TextStyle(fontSize: 30, fontFamily: 'Titillium', color: Colors.black)),
            )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[


              //Top Scorer
              Container(
                margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                width: (MediaQuery.of(context).size.width*0.8)/2,
                height: 170,
                color: Colors.yellow[800],
                alignment: Alignment.center,
                child: 
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      //Title
                      Text("Top Scorer", style: TextStyle(fontSize: 15),),
                      //Query Players collection for player with most goals
                      buildLeaderWidgets('goals')
                    ],
                  )
                
              ),


              //Top Assister
              Container(
                margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                width: (MediaQuery.of(context).size.width*0.8)/2,
                height: 170,
                color: Colors.yellow[800],
                alignment: Alignment.center,
                child: 
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      //Title
                      Text("Most Assists", style: TextStyle(fontSize: 15),),
                      //Query Players collection for player with most goals
                      buildLeaderWidgets('assists')
                    ],
                  )
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[


              //Top Points
              Container(
                margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
                width: (MediaQuery.of(context).size.width*0.8)/2,
                height: 170,
                color: Colors.yellow[800],
                alignment: Alignment.center,
                child: 
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      //Title
                      Text("Most Total Points", style: TextStyle(fontSize: 15),),
                      //Query Players collection for player with most goals
                      buildLeaderWidgets('totalPoints')
                    ],
                  )
              ),


              //Best GW
              Container(
                margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
                width: (MediaQuery.of(context).size.width*0.8)/2,
                height: 170,
                color: Colors.yellow[800],
                alignment: Alignment.center,
                child: 
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      //Title
                      Text("Top GW", style: TextStyle(fontSize: 15),),
                      //Query Players collection for player with most goals
                      buildLeaderWidgets('gw')
                    ],
                  )
              ),
            ],
          ),
          //Player stats
          Container(
            margin: new EdgeInsets.symmetric(horizontal: 30, vertical: 7),
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width,
              height: 50,
              color: Theme.of(context).accentColor,
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => PlayerStats()));                 
              },
              child: Text("Player Stats", style: TextStyle(fontSize: 18, fontFamily: 'Titillium')),
            ),
          ),
          
          //Fixtures & Results
          Container(
            margin: new EdgeInsets.symmetric(horizontal: 30, vertical: 7),
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width,
              height: 50,
              color: Theme.of(context).accentColor,
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Fixtures()));                 
              },
              child: Text("Fixtures & Results", style: TextStyle(fontSize: 18, fontFamily: 'Titillium')),
            ),
          ),
          
          //Rules
          Container(
            margin: new EdgeInsets.symmetric(horizontal: 30, vertical: 7),
            height: 50,
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width,
              color: Theme.of(context).accentColor,
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Rules()));                 
              },
              child: Text("Rules", style: TextStyle(fontSize: 18, fontFamily: 'Titillium')),
            ),
          ),
        //Add Game/Mod button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                child: FlatButton(
                  color: Colors.grey[400],
                  onPressed: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context) => Mod()));                 
                  },
                  child: Text("MOD"),
                ),
            ),
            Container(
              child: FlatButton(
                color: Colors.red,
                child: Text("Log Out"),
                onPressed: _signOut,
              ),
            )
            ],
          ),
        ],
      ),
    );
  }
}