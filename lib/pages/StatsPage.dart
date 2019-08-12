import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasy_hockey/pages/RulesPage.dart';
import 'package:fantasy_hockey/pages/PlayerStats.dart';
import 'package:fantasy_hockey/pages/Mod.dart';
import 'package:fantasy_hockey/pages/assisters.dart';
import 'package:fantasy_hockey/pages/auth.dart';
import 'package:fantasy_hockey/pages/gameWeek.dart';
import 'package:fantasy_hockey/pages/goalScorers.dart';
import 'package:fantasy_hockey/pages/totalPoints.dart';
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
        if(!snapshot.hasData) {return const Text('Loading...');}
        return Text(
          //Returning the player name + ": " + number of stat
          "1.\n${snapshot.data.documents[0].documentID}\t${snapshot.data.documents[0]['team']}\n${snapshot.data.documents[0][queryString].toString()}",
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
              child: Text("Statistics", style: TextStyle(fontSize: 30, fontFamily: 'Titillium', color: Colors.white)),
            )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[


              //Top Scorer
              Container(
                width: (MediaQuery.of(context).size.width*0.9)/2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: Colors.grey[50]),
                child: 
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      //Title
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5), color: Colors.white),
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(15, 5, 5, 5),
                        alignment: Alignment.centerLeft,
                        height: 50,
                        child: Text("Goals", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      ),
                      //Query Players collection for player with most goals
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 5, 5, 5),
                        child: buildLeaderWidgets('goals')
                      ),
                      //See Full List
                      Container(
                        alignment: Alignment.bottomRight,
                        child: FlatButton(
                          child: Text("See full table...", style: TextStyle(color: Colors.grey),),
                          onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => GoalScorers()));},
                        )
                      )
                    ],
                  )
                
              ),


              //Top Assister
              Container(
                width: (MediaQuery.of(context).size.width*0.9)/2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: Colors.grey[50]),
                alignment: Alignment.center,
                child: 
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      //Title
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5), color: Colors.white),
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(15, 5, 5, 5),
                        alignment: Alignment.centerLeft,
                        height: 50,
                        child: Text("Assists", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      ),
                      //Query Players collection for player with most assists
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 5, 5, 5),
                        child: buildLeaderWidgets('assists')
                      ),
                      //See Full List
                      Container(
                        alignment: Alignment.bottomRight,
                        child: FlatButton(
                          child: Text("See full table...", style: TextStyle(color: Colors.grey),),
                          onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => Assisters()));},
                        )
                      )
                    ],
                  )
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[


              //Top Points
              Container(
                width: (MediaQuery.of(context).size.width*0.9)/2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.grey[50]),
                alignment: Alignment.center,
                child: 
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      //Title
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5), color: Colors.white),
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(15, 5, 5, 5),
                        alignment: Alignment.centerLeft,
                        height: 50,
                        child: Text("Total Points", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      ),
                      //Query Players collection for player with most points
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 5, 5, 5),
                        child: buildLeaderWidgets('totalPoints')
                      ),
                      //See Full List
                      Container(
                        alignment: Alignment.bottomRight,
                        child: FlatButton(
                          child: Text("See full table...", style: TextStyle(color: Colors.grey),),
                          onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => TotalPoints()));},
                        )
                      )
                    ],
                  )
              ),


              //Best GW
              Container(
                width: (MediaQuery.of(context).size.width*0.9)/2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.grey[50]),
                alignment: Alignment.center,
                child: 
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      //Title
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5), color: Colors.white),
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(15, 5, 5, 5),
                        alignment: Alignment.centerLeft,
                        height: 50,
                        child: Text("GW", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      ),
                      //Query Players collection for player with most gw points
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 5, 5, 5),
                        child: buildLeaderWidgets('gw')
                      ),
                      //See Full List
                      Container(
                        alignment: Alignment.bottomRight,
                        child: FlatButton(
                          child: Text("See full table...", style: TextStyle(color: Colors.grey),),
                          onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => GameWeek()));},
                        )
                      )
                    ],
                  )
              ),
            ],
          ),
          //Player stats
          Container(
            margin: new EdgeInsets.symmetric(horizontal: 20, vertical: 7),
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width,
              height: 50,
              color: Colors.white,
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => PlayerStats()));                 
              },
              child: Text("Full Player Stats", style: TextStyle(fontSize: 18, fontFamily: 'Titillium')),
            ),
          ),
          
          //Rules
          Container(
            margin: new EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            height: 50,
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width,
              color: Colors.white,
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => RulesPage()));                 
              },
              child: Text("Rules & Scoring", style: TextStyle(fontSize: 18, fontFamily: 'Titillium')),
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