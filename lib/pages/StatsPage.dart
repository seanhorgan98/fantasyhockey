import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasy_hockey/pages/Rules/RulesPage.dart';
import 'package:fantasy_hockey/pages/Rankings/PlayerStats.dart';
import 'package:fantasy_hockey/pages/Mod/Mod.dart';
import 'package:fantasy_hockey/pages/Rankings/assisters.dart';
import 'package:fantasy_hockey/pages/auth.dart';
import 'package:fantasy_hockey/pages/Rankings/gameWeek.dart';
import 'package:fantasy_hockey/pages/Rankings/goalScorers.dart';
import 'package:fantasy_hockey/pages/Rankings/totalPoints.dart';
import 'package:flutter/material.dart';

class StatsPage extends StatelessWidget{
  //Constructor
  StatsPage({this.auth, this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  var userID = "";


  void _signOut() async{
    try{
      await auth.signOut();
      onSignedOut();
    } catch (e){
      print(e);
    }
  }

  Widget buildLeaderWidgets(BuildContext context, String queryString){
    double leaderFontSize = 20;
    if(MediaQuery.of(context).size.height < 600){
      leaderFontSize = 14;
    }
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Players').orderBy(queryString, descending: true).limit(1).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(!snapshot.hasData) {return const Text('Loading...');}
        return Text(
          //Returning the player name + ": " + number of stat
          "${snapshot.data.documents[0].documentID}\t${snapshot.data.documents[0]['team']}\n${snapshot.data.documents[0][queryString].toString()}",
          style: TextStyle(fontSize: leaderFontSize, fontFamily: 'Titillium'));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double titleFontSize = 30;
    double buttonFontSize = 18;
    double leaderFontSize = 20;
    double buttonHeight = 50;
    if(MediaQuery.of(context).size.height < 600){
      titleFontSize = 18;
      buttonFontSize = 12;
      leaderFontSize = 14;
      buttonHeight = 32;
    }
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          //Title
          Container(
            padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: Align(
              alignment: Alignment.center,
              child: Text("Statistics", style: TextStyle(fontSize: titleFontSize, fontFamily: 'Titillium', color: Colors.white)),
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
                        height: buttonHeight,
                        child: Text("Goals", style: TextStyle(fontSize: leaderFontSize, fontWeight: FontWeight.bold),),
                      ),
                      //Query Players collection for player with most goals
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 5, 5, 5),
                        child: buildLeaderWidgets(context, 'goals')
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
                        height: buttonHeight,
                        child: Text("Assists", style: TextStyle(fontSize: buttonFontSize, fontWeight: FontWeight.bold),),
                      ),
                      //Query Players collection for player with most assists
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 5, 5, 5),
                        child: buildLeaderWidgets(context, 'assists')
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
                        height: buttonHeight,                        child: Text("Total Points", style: TextStyle(fontSize: leaderFontSize, fontWeight: FontWeight.bold),),
                      ),
                      //Query Players collection for player with most points
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 5, 5, 5),
                        child: buildLeaderWidgets(context, 'totalPoints')
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
                        height: buttonHeight,
                        child: Text("GW", style: TextStyle(fontSize: leaderFontSize, fontWeight: FontWeight.bold),),
                      ),
                      //Query Players collection for player with most gw points
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 5, 5, 5),
                        child: buildLeaderWidgets(context, 'gw')
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
            margin: new EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width,
              height: buttonHeight,
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
            height: buttonHeight,
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width,
              color: Colors.white,
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => RulesPage()));                 
              },
              child: Text("Rules & Scoring", style: TextStyle(fontSize: 18, fontFamily: 'Titillium')),
            ),
          ),
        //Mod button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FutureBuilder(
              future: _getCurrentUser(context),
              builder: (context, snapshot){
                if(snapshot.connectionState == ConnectionState.done){
                  return _buildModButton(context);
                }else{
                  return Container();
                }
              },

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

  Future<String> _getCurrentUser(BuildContext context) async{
    userID = await auth.currentUser();
    return userID;
  }

  Container _buildModButton(BuildContext context){
    if (userID == '5Qn4VZcgUCTQIjetjopiA7TIOFD2' || userID == 'ma4IlNLh5SNwhMG0CpmdPpv1kj33'){
      return Container(
        padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
        child: FlatButton(
          color: Colors.grey[400],
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => Mod()));                 
          },
          child: Text("MOD"),
        ),
      );
    }else{
      return Container();
    }
    
  }
}