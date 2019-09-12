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


  void sortTeams(AsyncSnapshot snapshot) {
    teams = new List<Team>();

    //Loop through all firebase teams and create a team object
    for(var i = 1;i<snapshot.data.documents.length;i++){
      Team team = new Team(teamName: snapshot.data.documents[i]['teamName'],
                            gw: snapshot.data.documents[i]['totals'][0],
                            total: snapshot.data.documents[i]['totals'][1]);
      teams.add(team);
    }
    teams.sort((a,b) => b.total.compareTo(a.total));
  }

  @override
  Widget build(BuildContext context) {
    double height;
    if(MediaQuery.of(context).size.height < 540){
      height = 420;
    } else {
      height = MediaQuery.of(context).size.height * 0.84;
    }
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            //Surrounding White box for table
            Container(
              constraints: BoxConstraints(
                maxHeight: height,
                maxWidth: MediaQuery.of(context).size.width*0.9
              ),

              //Rounded edges
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.white),
              
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //Title
                    Text(
                      "League Table",
                      style: TextStyle(fontSize: 24, fontFamily: 'Titillium'),
                    ),

                    //Divider
                    Divider(height: 20,),

                    //Column Headings
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text("Pos.", style: TextStyle(fontWeight: FontWeight.bold),),
                          flex: 1,
                        ),
                        Expanded(
                          child: Text(" Team Name", style: TextStyle(fontWeight: FontWeight.bold),),
                          flex: 4,
                        ),
                        Expanded(
                          child: Text("GW", style: TextStyle(fontWeight: FontWeight.bold),),
                          flex: 1,
                        ),
                        Expanded(
                          child: Text("Total", style: TextStyle(fontWeight: FontWeight.bold),),
                          flex: 1,
                        ),
                      ],
                    ),

                    //Divider
                    Divider(color: Colors.white,),

                    //League Table Data
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
                            itemCount: snapshot.data.documents.length-1,
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
              //Very unsure why this needs to be here but it does (Alignment purposes probably)
            )
          ],
        )
      ),
    );
  }
}

Widget _buildListItem(BuildContext context, int index, List<Team> teams){
  return Row(
    children: <Widget>[
      Expanded(flex: 1,child: Text((index+1).toString())),
      Expanded(flex: 4,child: Text(teams[index].teamName)),
      Expanded(flex: 1,child: Text(teams[index].gw.toString())),
      Expanded(flex: 1,child: Text(teams[index].total.toString()))
    ],
  );
}





class Team{
  String teamName;
  int total;
  int gw;

  Team({this.teamName, this.total, this.gw});
}
