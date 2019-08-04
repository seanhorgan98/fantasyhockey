import 'package:fantasy_hockey/pages/Navigation.dart';
import 'package:flutter/material.dart';
import 'LogInPage.dart';
import 'auth.dart';


class RootPage extends StatefulWidget {
  RootPage({this.auth});
  final BaseAuth auth;
  

  @override
  _RootPageState createState() => _RootPageState();
}

enum AuthStatus{
  NOT_SIGNED_IN,
  SIGNED_IN
}

class _RootPageState extends State<RootPage> {

  AuthStatus authStatus = AuthStatus.NOT_SIGNED_IN;

  @override
  void initState() {
    super.initState();
    widget.auth.currentUser().then((userId){
      setState(() {
        //Comment this line out if you don't want to have it auto log in
        //authStatus = userId == null ? AuthStatus.NOT_SIGNED_IN : AuthStatus.SIGNED_IN;
      });
    });

  }

  void _signedIn(){
    setState(() {
      authStatus = AuthStatus.SIGNED_IN;
    });
  }

  void _signedOut(){
    setState(() {
      authStatus = AuthStatus.NOT_SIGNED_IN;
      print("Signed Out");
    });
  }

  @override
  Widget build(BuildContext context) {
    if(authStatus == AuthStatus.NOT_SIGNED_IN){
      //When not logged in
      return new LogInPage(auth: widget.auth, onSignedIn: _signedIn);
    }else{
      //When logged in
      return new Navigation(auth:  widget.auth, onSignedOut: _signedOut);
    }
    
  }
}