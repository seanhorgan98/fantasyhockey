// main.dart

import 'package:flutter/material.dart';


import 'pages/HomePage.dart';

void main(){
  runApp(MaterialApp(
    home: MyApp(),
    theme: ThemeData(fontFamily: 'Raleway'),
  ));
}


//Main Page Class
class MyApp extends StatelessWidget {
  final String title = "Log In";
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.amberAccent,
      ),
      home: new HomePage(title),
    );
  }
}

