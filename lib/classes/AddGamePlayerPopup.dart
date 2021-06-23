import 'package:fantasy_hockey/classes/PlayerData.dart';
import 'package:flutter/material.dart';

class AddPlayerPopup extends StatefulWidget {
  AddPlayerPopup({this.playerData});

  final PlayerData playerData;

  @override
  _AddPlayerPopupState createState() => _AddPlayerPopupState();
}

class _AddPlayerPopupState extends State<AddPlayerPopup> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: <Widget>[
          MaterialButton(
            color: Colors.green,
            onPressed: () {
              Navigator.pop(context, widget.playerData);
            },
            child: Text("Return"),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.8,
            child: ListView.builder(
              itemCount: widget.playerData.toList().length,
              itemBuilder: (context, index) {
                return playerPopupRow(widget.playerData, index);
              },
            ),
          ),
        ],
      ),
    ));
  }

  Widget playerPopupRow(PlayerData player, int index) {
    //appearences, goals, gw, price, totalPoints
    List<int> badIndex = [0, 14, 15, 20, 23];
    //Remove position fields
    // 12 is forward goal
    // 5, 6 are def concede, 7 is clean, 8 is goal
    // 16 is mid cleen, 17 is goal
    switch (player.getPosition()) {
      case 0:
        badIndex.addAll([16, 17]);
        badIndex.add(12);
        break;
      case 1:
        badIndex.add(12);
        badIndex.addAll([5, 6, 7, 8]);
        break;
      case 2:
        badIndex.addAll([16, 17]);
        badIndex.addAll([5, 6, 7, 8]);
        break;
    }

    if (badIndex.contains(index)) {
      return Container();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        //Field Name
        Flexible(
          flex: 2,
          child: Text(player.fieldListFancy()[index]),
          fit: FlexFit.tight,
        ),
        Flexible(
          flex: 1,
          child: Text(player.toList()[index].toString()),
          fit: FlexFit.loose,
        ),

        //Down
        RaisedButton(
          child: Text("-"),
          onPressed: () {
            increment(-1, index, player);
          },
        ),
        //Up
        RaisedButton(
            child: Text("+"),
            onPressed: () {
              increment(1, index, player);
            }),
      ],
    );
  }

  // changes state based on +/- click
  void increment(int change, int index, PlayerData player) {
    List temp = player.toList();
    temp[index] += change;
    setState(() {
      widget.playerData.setData(temp);
    });
  }
}
