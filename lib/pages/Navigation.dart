import 'package:fantasy_hockey/pages/auth.dart';
import 'package:flutter/material.dart';
import 'LeaguePage.dart';
import 'MyTeamPage.dart';
import 'StatsPage.dart';

class Navigation extends StatefulWidget{
  Navigation({this.auth, this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;


  @override
  State<StatefulWidget> createState() {
    return _NavigationState();
  }
}


class _NavigationState extends State<Navigation> {
  int _currentIndex = 0;  

  @override
  Widget build(BuildContext context) {

    //Pages in the navigation bar
    final List<Widget> _children = [
      LeaguePage(),
      MyTeamPage(auth: widget.auth),
      StatsPage(auth: widget.auth, onSignedOut: widget.onSignedOut,)
    ];
    return Scaffold(
      body: Container(
        //Draw background
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1,0.4,0.7,0.9],
            colors: [
              Color(0xFF3594DD),
              Color(0xFF4563DB),
              Color(0xFF5036D5),
              Color(0xFF5036D5)
            ]
          )
        ),
        child: _children[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
       onTap: onTabTapped,
       currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.list),
            title: new Text('League'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.perm_identity),
            title: new Text('My Team'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.equalizer),
            title: Text('Stats')
          )
        ],
      ),
    );
  }

  void onTabTapped(int index) {
   setState(() {
     _currentIndex = index;
   });
  }
}