import 'package:flutter/material.dart';

class TeamNameCreation extends StatefulWidget {
  TeamNameCreation({this.facebookUser});
  final String facebookUser;

  @override
  _TeamNameCreationState createState() => _TeamNameCreationState();
}

class _TeamNameCreationState extends State<TeamNameCreation> {

  final _formKey = GlobalKey<FormState>();
  final int maxTeamNameLength = 75;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                      _createTeam();
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

  _createTeam(){

    //Check team doesn't already exist for this user

    //Add user to firebase

    //Create Team on firebase with user attached and teamname

    //Attach team to user document on firebase

    //onSignedIn() callback to go to navigator AT THE END to continue on to navigator
  }

}

