// pages/home_page.dart
import 'package:fantasy_hockey/main.dart';
import 'package:flutter/material.dart';

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
              FacebookLoginButton()
            ],
          ),
        )
      ),
    );
  }
  
}
