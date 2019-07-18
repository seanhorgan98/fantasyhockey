import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LeaguePage extends StatefulWidget{
  @override
  LeaguePageState createState(){
    return new LeaguePageState();
  }
}

class LeaguePageState extends State<LeaguePage>{
  List<Team> teams;
  Future<Team> sortTeams(AsyncSnapshot snapshot) async {
    teams = new List<Team>();

    //Loop through firebase teams and add them to list of teams
    for(var i = 0;i<snapshot.data.documents.length;i++){
      Team team = new Team(teamName: snapshot.data.documents[i]['teamName'],
                            gw: snapshot.data.documents[i]['gw'],
                            total: snapshot.data.documents[i]['points']);
      teams.add(team);
    }
    teams.sort((a,b) => b.total.compareTo(a.total));
    //Use list.sort
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //Top Bar
            Container(
              width: MediaQuery.of(context).size.width*0.8,
              height: 5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0,1],
                  colors: [
                    Colors.white,
                    Colors.red,
                  ]
                )
              ),
            ),
            //Container for League Table white box
            Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width*0.9,
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "League Table",
                      style: TextStyle(fontSize: 24, fontFamily: 'Titillium'),
                    ),
                    Divider(height: 20,),
                    //Headings
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Text("Pos."),
                        ),
                        Container(
                          child: Text("Team Name"),
                        ),
                        Container(
                          child: Text("GW"),
                        ),
                        Container(
                          child: Text("Total"),
                        ),
                      ],
                    ),
                    //DataTable || ACTUAL LEAGUE TABLE
                    Flexible(
                      child: StreamBuilder(
                        stream: Firestore.instance.collection('Teams').snapshots(),
                        builder: (context, snapshot){
                          if(!snapshot.hasData) {return const Text('Loading...');}

                          //Create Firestore list of all teams
                          sortTeams(snapshot);

                          return ListView.separated(
                            shrinkWrap: true,
                              padding: const EdgeInsets.all(8.0),
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (context, index) => 
                                _buildListItem(context, index, teams),  
                              separatorBuilder: (BuildContext context, int index) => const Divider(height: 30,),
                          );
                        }
                      ),
                    )
                  ]
                )
              ),
            ),
            Container(
              //Very unsure why this needs to be here but it does
            )
          ],
        )
      ),
    );
  }
}

Widget _buildListItem(BuildContext context, int index, List<Team> teams){
  return Row(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.spaceBetween, //Changes horizontal spacing
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      //Might need to switch from flexible to something else to sort out alignment issues
      Flexible(flex: 2,child: Text((index+1).toString())),
      Flexible(flex: 5,child: Text(teams[index].teamName)),
      Flexible(flex: 2,child: Text(teams[index].gw.toString())),
      Flexible(flex: 2,child: Text(teams[index].total.toString()))
    ],
  );
}





class Team{
  String teamName;
  int total;
  int gw;

  Team({this.teamName, this.total, this.gw});
}

/* Process
1. Get Data from Firebase
2. Loop through and assign each firebase team to a team object
3. Add these objects to an array
4. Sort the array 
*/
//Entry(rank: 5, teamName: "Test", total: 21, gw: 12)
