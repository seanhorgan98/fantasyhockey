import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as prefix0;
import 'package:flutter/material.dart';

class TeamNameCreation extends StatefulWidget {
  TeamNameCreation({this.facebookUser});
  final String facebookUser;

  @override
  _TeamNameCreationState createState() => _TeamNameCreationState();
}

class _TeamNameCreationState extends State<TeamNameCreation> {

  final _formKey = GlobalKey<FormState>();
  final int maxTeamNameLength = 30;
  final textController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final snackBar = SnackBar(content: Text("Team Created!"));

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //Team Name title
              Container(
                child: Text("Team Name:", style: TextStyle(fontSize: 20, fontFamily: 'Titillium'))
              ),
              
              //Team Name input
              Container(
                width: MediaQuery.of(context).size.width*0.7,
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: textController,
                    obscureText: false,
                    validator: (value){
                      if(value.isEmpty){
                        return "You must have a team name.";
                      }
                      if(value.length> maxTeamNameLength){
                        return "You must choose a team name less than 75 characters";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      hintText: "Team Name",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))
                    ),
                  )
                )
              ),

              //Submit Button
              Container(
                child: RaisedButton(
                  color: Colors.green[300],
                  onPressed: (){
                    if(_formKey.currentState.validate()){
                      //Create Team
                      _createTeam(widget.facebookUser, textController.text);
                    }
                  },
                  child: Text("Create team"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _createTeam(String userID, String teamName) async {

    var teamBatch = Firestore.instance.batch();
    DocumentReference teamDoc = Firestore.instance.collection("Teams").document();

    teamBatch.setData(teamDoc, {
        //Add Players etc
        'captain': 0,
        'teamName': teamName,
        'total': 0,
        'gw': 0,
        'prices':[
          0,0,0,0,0,0,0
        ],
        'points':[
          0,0,0,0,0,0,0
        ],
        'players':[
          "No Player", "No Player", "No Player", "No Player", "No Player", "No Player", "No Player"
        ],
        'sub': 1,
        'totals':[
          0,0
        ],
        'transferSetting': 2,
        'transfers':[
          0,100
        ]
    });

    teamBatch.commit();

    DocumentReference userDoc = Firestore.instance.collection("Users").document(userID);

    WriteBatch userBatch = Firestore.instance.batch();
    userBatch.setData(userDoc, {'team': teamDoc.documentID});
    userBatch.commit();


    //Display snackbar
    _scaffoldKey.currentState.showSnackBar(snackBar);
    //Delay 2 seconds while snackbar is displayed
    await Future.delayed(Duration(seconds: 2));
    //Navigate back
    Navigator.of(context).pop();
          
  }

}

