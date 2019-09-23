import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasy_hockey/pages/auth.dart';
import 'package:fantasy_hockey/pages/teamCreation.dart';
import 'package:flutter/material.dart';

class LogInPage extends StatefulWidget {
  LogInPage({this.auth, this.onSignedIn});
  final BaseAuth auth;
  final VoidCallback onSignedIn;



  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  Color facebookColor = Color(0xff4267B2);
  bool isLoading = false;

  _onSignUp(){
    //Navigate to team creation page
    Navigator.push(context, MaterialPageRoute(builder: (context) => TeamCreation(auth: widget.auth, onSignedIn: widget.onSignedIn)));
  }

  Widget customSignUpButton(){
    return Container(
      width: MediaQuery.of(context).size.width*0.65,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5), color: Colors.white,
        border: new Border.all(color: Colors.black)
      ),
      
      child: MaterialButton(
        onPressed: () => _onSignUp(),
        child: Text("Sign Up", style: TextStyle(fontSize: 20, fontFamily: 'Titillium'),),
      ),
    );
  }

  Widget customFacebookButton(){
    return Container(
      child: 
        Container(
          height: MediaQuery.of(context).size.height*0.13,
          child: InkWell(
            onTap: () => startFacebookLogin(widget.auth, widget.onSignedIn),
            child: Image.asset('assets/images/facebook.png',),
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("Loading...", style: TextStyle(fontFamily: "Titillium", fontSize: 25),),
              CircularProgressIndicator(),
            ],
          ),
        )
    ) : 
    SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              //Header Image
              child: Image.asset("assets/images/wallpaper.jpg"),
            ),
            Divider(color: Colors.white,),
            //Title
            Text("Fantasy Hockey", style: TextStyle(fontFamily: 'Titillium', fontSize: 35, fontWeight: FontWeight.bold)),

            //Spacer
            Divider(color: Colors.white, height: MediaQuery.of(context).size.height/4,),

            //Login Button
            customFacebookButton(),

            Divider(color: Colors.white,),

            //Sign Up button
            customSignUpButton(),
          ],
        )
      )
    );
  }

  //Async Facebook Login
  void startFacebookLogin(BaseAuth auth, VoidCallback onSignedIn) async {
    
    setState(() {
      isLoading = true;
    });

    await auth.signInWithFacebook();

    

    //Get UID
    auth.currentUser().then((user){
      //Check if document in Users Collection exists with id user
      
      DocumentReference docRef = Firestore.instance.collection("Users").document(user);
      //No User signed in check
      if(user == "false"){
        setState(() {
          isLoading = false;
        });
        return;
      }

      docRef.snapshots().listen((onData) async {
        if(onData.exists == false){
          //Document does not exist
          Navigator.push(context, MaterialPageRoute(builder: (context) => TeamCreation(auth: widget.auth, onSignedIn: signMeInHamachi)));
        }else{
          await Future.delayed(Duration(milliseconds: 50));
          onSignedIn();
        }
      });

    });
  }

  signMeInHamachi(){
    widget.onSignedIn();
  }


}

