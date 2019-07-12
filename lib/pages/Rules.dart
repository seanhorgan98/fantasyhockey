import 'package:flutter/material.dart';

class Rules extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Rules", style: TextStyle(fontFamily: 'Titillium')),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Text(
            "Feel free to fill this in them Sam as you are obviously the best at fantasy.",
            style: TextStyle(fontFamily: 'Titillium')
            ),
        ),
        
      ),
    );
  }
}