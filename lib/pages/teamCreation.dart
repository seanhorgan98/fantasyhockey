import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasy_hockey/pages/auth.dart';
import 'package:fantasy_hockey/pages/teamNameCreation.dart';
import 'package:flutter/material.dart';

class TeamCreation extends StatefulWidget {
  TeamCreation({this.auth, this.onSignedIn});
  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  _TeamCreationState createState() => _TeamCreationState();
}

class _TeamCreationState extends State<TeamCreation> {
  final Color facebookColor = Color(0xff4267B2);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final snackBar = SnackBar(content: Text('You already have a team!'));


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //Title
              Container(
                padding: EdgeInsets.all(15),
                child: Text("Team Creation", style: TextStyle(fontSize: 30, fontFamily: 'Titillium')),
              ),

              //Log In with Facebook
              Container(
                height: 50,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5), color: Colors.white,
                    border: new Border.all(color: Colors.black)
                  ),
                  child: InkWell(
                    onTap: () => _handleLogIn(widget.auth, widget.onSignedIn),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        //Facebook Logo
                        Container(
                          padding: EdgeInsets.fromLTRB(2, 2, 0, 2),
                          child: Image.asset(
                            'assets/images/facebook.jpg', 
                            colorBlendMode: BlendMode.colorDodge, 
                            color: facebookColor,
                          ),
                        ),
                      
                        //Text
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                          child: Text("Log in with Facebook", style: TextStyle(fontSize: 20),),
                        )
                      ],
                    ),
                  )
                )
              ),

            ],
          )


          //Login with facebook [X}]

          //Check if team already exists for this user [ ]

          //Create team name (max name length) [X]
          
          //Create new team on firebase with teamName and firebaseUsername [ ]

        ),
      )
    );
  }

  _handleLogIn(BaseAuth auth, VoidCallback onSignedIn) async{
    //Log in with facebook
    await auth.signInWithFacebook();

    StreamSubscription<DocumentSnapshot> subscription;

    //Get UID
    auth.currentUser().then((user){
      //Check if document in Users Collection exists with id user
      
      DocumentReference docRef = Firestore.instance.document("Users/$user");

      subscription = docRef.snapshots().listen((onData) async {
        if(!onData.exists){
          //Document does not exist
          Navigator.push(context, MaterialPageRoute(builder: (context) => TeamNameCreation(facebookUser: user)));
        }else{
          //Display snackbar
          _scaffoldKey.currentState.showSnackBar(snackBar);
          //Delay 2 seconds while snackbar is displayed
          await Future.delayed(Duration(seconds: 2));
          //Navigate back
          Navigator.of(context).pop();
          

        }
      });
    });    
  }
}