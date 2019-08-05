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
      height: 50,
      child: 
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Colors.white,
            border: new Border.all(color: Colors.black)
          ),
          child: InkWell(
            onTap: () => startFacebookLogin(widget.auth, widget.onSignedIn),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
          ],
        )
      )
    );
  }
}

//Async Facebook Login
void startFacebookLogin(BaseAuth auth, VoidCallback onSignedIn) async {
  String userID = await auth.signInWithFacebook();
  print(userID);
  onSignedIn();
}


