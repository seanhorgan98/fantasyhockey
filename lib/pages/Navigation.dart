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
  bool _visible = true; //First Load
  

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
          image: DecorationImage(
            image: AssetImage("assets/images/geometry.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: AnimatedOpacity(
          opacity: _visible ? 1.0 : 0.0,
          duration: Duration(milliseconds: 200),
          child:_children[_currentIndex],
        ),
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
    _visible = false;
    sleepWhileHiding();
   setState(() {
     _currentIndex = index;
   });
   sleepBeforeRedrawing();
  }

  Future sleepWhileHiding() {
    //Adjust milliseconds to taste
    return new Future.delayed(const Duration(milliseconds: 50), () => setState(() {_visible = true;}));
  }

  Future sleepBeforeRedrawing() {
    //Adjust milliseconds to taste
    return new Future.delayed(const Duration(milliseconds: 200), () => setState(() {_visible = true;}));
  }
}