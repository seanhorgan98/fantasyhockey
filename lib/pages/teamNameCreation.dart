import 'package:flutter/material.dart';

class TeamNameCreation extends StatefulWidget {
  TeamNameCreation({this.facebookUser});
  final String facebookUser;

  @override
  _TeamNameCreationState createState() => _TeamNameCreationState();
}

class _TeamNameCreationState extends State<TeamNameCreation> {

  final _formKey = GlobalKey<FormState>();
  final int maxTeamNameLength = 20;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
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
                    obscureText: false,
                    validator: (value){
                      if(value.isEmpty){
                        return "You must have a team name.";
                      }
                      if(value.length> maxTeamNameLength){
                        return "You must choose a team name less than 20 characters";
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
                      print("Creating Team...");
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
}


//Create Team

//onSignedIn() callback to go to navigator