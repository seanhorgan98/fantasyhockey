import 'package:flutter/material.dart';
import 'LeaguePage.dart';
import 'MyTeamPage.dart';
import 'StatsPage.dart';

class Navigation extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _NavigationState();
  }
}


class _NavigationState extends State<Navigation> {
  int _currentIndex = 0;
  //Pages in the navigation bar
  final List<Widget> _children = [
    LeaguePage(),
    MyTeamPage(),
    StatsPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(
       onTap: onTabTapped, // new
       currentIndex: _currentIndex, // new
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