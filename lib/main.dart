// main.dart
import 'package:fantasy_hockey/pages/RootPage.dart';
import 'package:fantasy_hockey/pages/auth.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(
    home: MainApp(),
    theme: ThemeData(fontFamily: 'Titillium Web'),
  ));
}

//Main Page Class
class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Log In",
      home: new RootPage(auth: new Auth()),
    );
  }
}