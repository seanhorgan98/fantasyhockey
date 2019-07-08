import 'package:flutter/material.dart';

class StatsPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
          children: <Widget>[
            //Top Scorer and Assister new
            Container(
            margin: EdgeInsets.symmetric(vertical: 20.0),
            height: 200.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                //Top Scorer
                Container(
                  width: 160.0,
                  color: Colors.red,
                  child: Text("Top Scorer")
                ),
                //Top Assister
                Container(
                  width: 160.0,
                  color: Colors.blue,
                  child: Text("Top Assister"),
                ),
                //Top Points
                Container(
                  width: 160.0,
                  color: Colors.green,
                  child: Text("Top Total Points"),
                ),
                //Best GW
                Container(
                  width: 160.0,
                  color: Colors.yellow,
                  child: Text("Top GW"),
                ),
              ],
            ),
          ),
            //Player stats
            Container(
              margin: new EdgeInsets.symmetric(horizontal: 50),
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                color: Theme.of(context).accentColor,
                onPressed: (){},
                child: Text("Player Stats", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal),),
              ),
            ),
            
            //Fixtures & Results
            Container(
              margin: new EdgeInsets.symmetric(horizontal: 50),
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                color: Theme.of(context).accentColor,
                onPressed: (){},
                child: Text("Fixtures & Results", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal),),
              ),
            ),
            
            //Rules
            Container(
              margin: new EdgeInsets.symmetric(horizontal: 50),
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                color: Theme.of(context).accentColor,
                onPressed: (){},
                child: Text("Rules", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal),),
              ),
            ),
          ],
        )
      );
  }
  
}