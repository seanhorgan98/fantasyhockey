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
Color facebookColor = Color(0xff4267B2);

  Widget customFacebookButton(){
    return Container(
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: Row(
          children: <Widget>[
            //Image.asset('assets/images/facebook.jpg'),
            FlatButton(
            onPressed: () => startFacebookLogin(widget.auth, widget.onSignedIn),
            child: Text("Sign in with Facebook", style: TextStyle(color: Colors.white),),
            color: facebookColor,
            ),
          ],
        )
          
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Log In"),
        ),
        body: Center(
          //Facebook Button
          child: customFacebookButton()
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


