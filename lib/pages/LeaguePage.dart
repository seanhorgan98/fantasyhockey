import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LeaguePage extends StatefulWidget{
  @override
  LeaguePageState createState(){
    return new LeaguePageState();
  }
}

class LeaguePageState extends State<LeaguePage>{
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
                    Colors.black
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
                    //DataTable
                    DataTable(
                      sortAscending: false,
                      columns: <DataColumn>[
                        DataColumn(
                          label: Text("Rank"),
                          numeric: true,
                          onSort: (i,b){
                            setState((){
                              teams.sort((a,b)=>b.rank.compareTo(a.rank));
                              
                            });
                            
                          },
                        ),
                        DataColumn(
                          label: Text("Team"),
                          numeric: false,
                          onSort: (i,b){
                            setState(() {
                              teams.sort((a,b)=>b.teamName.compareTo(a.teamName));
                            });
                          },
                        ),
                        DataColumn(
                          label: Text("Points"),
                          numeric: true,
                          onSort: (i,b){
                            setState(() {
                              teams.sort((a,b)=>b.total.compareTo(a.total));
                            });
                          },
                        ),
                        DataColumn(
                          label: Text("GW"),
                          numeric: true,
                          onSort: (i,b){
                            setState(() {
                              teams.sort((a,b)=>b.gw.compareTo(a.gw));
                            });
                          },
                        ),
                      ],
                      rows: teams.map((team)=>DataRow(
                        cells: [
                          //Team Rank
                          DataCell(
                            Text(team.rank.toString())
                          ),
                          //Team Name
                          DataCell(
                            Text(team.teamName)
                          ),
                          //Total Points
                          DataCell(
                            Text(team.total.toString())
                          ),
                          //GW Points
                          DataCell(
                            Text(team.gw.toString())
                          ),
                        ]
                      )).toList()
                    ),
                  ],
                ),
              ),
            ),
            Container(

            )
          ],
        )
      ),
    );
  }
}

class Entry{
  int rank;
  String teamName;
  int total;
  int gw;

  Entry({this.rank, this.teamName, this.total, this.gw});
}

/* Process
1. Get Data from Firebase
2. Assign data in descending order of total points into each row
  This means using some sort of a for loop and using i to determine the rank
3. The DataTable will then take and display this info automatically.
*/
var teams = <Entry>[
  Entry(rank: 1, teamName: "Horgan Donors", total: 459, gw: 24),
  Entry(rank: 2, teamName: "Gluten Town F.C.", total: 372, gw: 32),
  Entry(rank: 3, teamName: "The Name's Bond. Grog Bond.", total: 330, gw: 15),
  Entry(rank: 4, teamName: "Sam's Team", total: 6, gw: 1),
  Entry(rank: 5, teamName: "Test", total: 21, gw: 12)
];