import 'package:fantasy_hockey/pages/auth.dart';
import 'package:flutter/material.dart';

class LogInPage extends StatefulWidget {
  LogInPage({this.auth, this.onSignedIn});
  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Log In"),
        ),
        body: Center(
          //Facebook Button
          child: RaisedButton(
            onPressed: () => startFacebookLogin(widget.auth, widget.onSignedIn),
            child: Text("Sign in with Facebook"),
            color: Colors.blue,
          )
        ),
      ),
    );
  }
}

//Async Facebook Login
void startFacebookLogin(BaseAuth auth, VoidCallback onSignedIn) async {
  String userID = await auth.signInWithFacebook();
  print(userID);
  onSignedIn();
}
