import 'package:flutter/material.dart';

class StatsPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
          children: <Widget>[
            //Title
            Container(
              padding: EdgeInsets.fromLTRB(15, 25, 0, 0),
              child: Align(
                alignment: Alignment.center,
                child: Text("Statistics", style: TextStyle(fontSize: 30, fontFamily: 'Titillium', color: Colors.white)),
              )
            ),
            //Top Scorer and Assister new
            Container(
            margin: EdgeInsets.fromLTRB(15, 15, 0, 15),
            height: 200.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                //Top Scorer
                Container(
                  width: 170.0,
                  color: Colors.yellow[800],
                  alignment: Alignment.center,
                  child: Text("Top Scorer", style: TextStyle(fontSize: 24, fontFamily: 'Titillium'))
                ),
                //Top Assister
                Container(
                  width: 170.0,
                  color: Colors.grey[500],
                  alignment: Alignment.center,
                  child: Text("Top Assister", style: TextStyle(fontSize: 24, fontFamily: 'Titillium')),
                ),
                //Top Points
                Container(
                  width: 170.0,
                  color: Colors.yellow[900],
                  alignment: Alignment.center,
                  child: Text("Top Points", style: TextStyle(fontSize: 24, fontFamily: 'Titillium')),
                ),
                //Best GW
                Container(
                  width: 170.0,
                  color: Colors.blue[300],
                  alignment: Alignment.center,
                  child: Text("Top GW", style: TextStyle(fontSize: 24, fontFamily: 'Titillium')),
                ),
              ],
            ),
          ),
            //Player stats
            Container(
              margin: new EdgeInsets.symmetric(horizontal: 30, vertical: 7),
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                height: 50,
                color: Theme.of(context).accentColor,
                onPressed: () => print("Player Stats"),
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
                onPressed: () => print("Fixtures & Results"),
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
                onPressed: () => print("Rules"),
                child: Text("Rules", style: TextStyle(fontSize: 18, fontFamily: 'Titillium')),
              ),
            ),
          ],
        )
      );
  }
  
}