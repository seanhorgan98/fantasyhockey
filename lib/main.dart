// main.dart

import 'package:flutter/material.dart';


import 'pages/HomePage.dart';

void main(){
  runApp(MaterialApp(
    home: MyApp(),
    theme: ThemeData(fontFamily: 'Titillium'),
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
        accentColor: Colors.white,
      ),
      home: new HomePage(title),
    );
  }
}

