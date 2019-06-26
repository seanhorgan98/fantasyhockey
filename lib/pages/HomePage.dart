// pages/home_page.dart
import 'package:fantasy_hockey/pages/Navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Auth.dart';

class HomePage extends StatelessWidget{

  final String title;
  HomePage(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
        backgroundColor: Colors.blue[700],
      ),


      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              LoginButton(),
              UserProfile(),
              FacebookLoginButton(),
              MainNavigate(),
            ],
          ),
        )
      ),
    );
  }
  
}

class MainNavigate extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: (){
        Navigator.of(context).push(MaterialPageRoute<Null>(builder: (BuildContext context) {
          return new Navigation();
        }));
      },
      color: Colors.blue[700],
      textColor: Colors.white,
      child: Text('Go to App'),
    );
  }
   
}



//Authentication for Google
class UserProfile extends StatefulWidget {
  @override
  UserProfileState createState() => UserProfileState();
}

//User profile text after login
class UserProfileState extends State<UserProfile> {
  Map<String, dynamic> _profile;
  bool _loading = false;

  @override
  initState() {
    super.initState();

    // Subscriptions are created here
    authService.profile.listen((state) => setState(() => _profile = state));

    authService.loading.listen((state) => setState(() => _loading = state));
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(padding: EdgeInsets.all(20), child: Text(_profile.toString())),
      Text(_loading.toString())
    ]);
  }
}

//Google Login Button Implementation
class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: authService.user,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MaterialButton(
              onPressed: () => authService.signOut(),
              color: Colors.red,
              textColor: Colors.white,
              child: Text('Signout'),
            );
          } else {
            return MaterialButton(
              onPressed: () => authService.googleSignIn(),
              color: Colors.white,
              textColor: Colors.black,
              child: Text('Login with Google'),
            );
          }
        });
  }
}

//Facebook Button Implementation
class FacebookLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () => startFacebookLogin(),
      child: Text("Sign in with Facebook"),
      color: Colors.blue,

    );
  }
}

void startFacebookLogin() async {
  var facebookLogin = FacebookLogin();
  var result = await facebookLogin.logInWithReadPermissions(['email', 'public_profile']);

  switch (result.status){
    case FacebookLoginStatus.loggedIn:
      FacebookAccessToken myToken = result.accessToken;
      AuthCredential credential = FacebookAuthProvider.getCredential(accessToken: myToken.token);

      FirebaseUser firebaseUser = await FirebaseAuth.instance.signInWithCredential(credential);
      print(firebaseUser.displayName); /***/
      break;
    case FacebookLoginStatus.cancelledByUser:
      print("Facebook sign in cancelled by user");
      break;
    case FacebookLoginStatus.error:
      print("Facebook sign in failed");
      break;
  }
}
