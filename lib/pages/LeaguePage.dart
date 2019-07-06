import 'package:flutter/material.dart';

class LeaguePage extends StatefulWidget{
  @override
  LeaguePageState createState(){
    return new LeaguePageState();
  }
}

class LeaguePageState extends State<LeaguePage>{

    Widget bodyData()=>DataTable(
    sortAscending: false,
    sortColumnIndex: 2,
    columns: <DataColumn>[
      DataColumn(
        label: Text("Rank"),
        numeric: true,
        onSort: (i,b){
          setState((){
            teams.sort((a,b)=>a.rank.compareTo(b.rank));
          });
          
        },
      ),
      DataColumn(
        label: Text("Team Name"),
        numeric: false,
        onSort: (i,b){
          setState(() {
            teams.sort((a,b)=>a.teamName.compareTo(b.teamName));
          });
        },
      ),
      DataColumn(
        label: Text("Total Points"),
        numeric: true,
        onSort: (i,b){
          setState(() {
            teams.sort((a,b)=>a.total.compareTo(b.total));
          });
        },
      ),
      DataColumn(
        label: Text("GW"),
        numeric: true,
        onSort: (i,b){
          setState(() {
            teams.sort((a,b)=>a.gw.compareTo(b.gw));
          });
        },
      ),
    ],
    rows: teams.map((team)=>DataRow(
      cells: [
        //Team Rank
        DataCell(
          Text(team.rank)
        ),
        //Team Name
        DataCell(
          Text(team.teamName)
        ),
        //Total Points
        DataCell(
          Text(team.total)
        ),
        //GW Points
        DataCell(
          Text(team.gw)
        ),
      ]
    )).toList()
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: Text("League Table"),
      ),
      body: Container(
        child: bodyData(),
      )
    );
  }
}

class Entry{
  String rank;
  String teamName;
  String total;
  String gw;

  Entry({this.rank, this.teamName, this.total, this.gw});
}

/* Process
1. Get Data from Firebase
2. Assign data in descending order of total points into each row
  This means using some sort of a for loop and using i to determine the rank
3. The DataTable will then take and display this info automatically.
*/
var teams = <Entry>[
  Entry(rank: "1", teamName: "Horgan Donors", total: "459", gw: "24"),
  Entry(rank: "2", teamName: "Gluten Town F.C.", total: "372", gw: "32"),
  Entry(rank: "3", teamName: "The Name's Bond. Grog Bond.", total: "330", gw: "15"),
  Entry(rank: "4", teamName: "Sam's Team", total: "6", gw: "1")
];