import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

abstract class BaseAuth{
  Future<String> signInWithFacebook();
  Future<String> currentUser();
  Future<void> signOut();
}

class Auth implements BaseAuth{
  Future<String> signInWithFacebook() async{
    var facebookLogin = FacebookLogin();
    var result = await facebookLogin.logInWithReadPermissions(['email', 'public_profile']);

    switch (result.status){
      case FacebookLoginStatus.loggedIn:
        FacebookAccessToken myToken = result.accessToken;
        AuthCredential credential = FacebookAuthProvider.getCredential(accessToken: myToken.token);

        FirebaseUser user = await FirebaseAuth.instance.signInWithCredential(credential);
        return user.uid;
      case FacebookLoginStatus.cancelledByUser:
        print("Facebook sign in cancelled by user");
        break;
      case FacebookLoginStatus.error:
      //Need to add on screen error
        print("Facebook sign in failed");
        break;
    }
    return null;
  }

  Future<String> currentUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user.uid;
  }

  Future<void> signOut() async{
    return await FirebaseAuth.instance.signOut();
  }
}