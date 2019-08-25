import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeamPointData {

  int gw;
  int total;
  List gwPoints;
  List names;
  int captain;

  void updateGW(){
    this.gw = this.gwPoints.reduce((a, b) => a + b);
  }

  void doubleCap(){
    this.gwPoints[captain] *= 2;
  }

  TeamPointData(DocumentSnapshot snapshot){
    if(snapshot == null){
      throw IOException;
    }
    this.gw = snapshot['totals'][0];
    this.total = snapshot['totals'][1];
    this.gwPoints = snapshot['points'];
    this.names = snapshot['players'];
    this.captain = snapshot['captain'];
  }

  void setPoints(int i, int value){
    if( i == null || value == null){
      throw IOException;
    }
    this.gwPoints[i] = value;
  }
}

class NamePoints {
  String name;
  int gwPoints;

  NamePoints(DocumentSnapshot snapshot){
    if(snapshot == null){
      throw IOException;
    }
    this.name = snapshot.documentID;
    this.gwPoints = snapshot['gw'];
  }

  int getPoints(){
    return this.gwPoints;
  }

  String getName(){
    return this.name;
  }
}

class PlayerList {
  List<NamePoints> players = new List<NamePoints>();

  PlayerList(QuerySnapshot query){
    if(query == null) {
      throw IOException;
    }
    for (DocumentSnapshot player in query.documents){
      this.players.add(new NamePoints(player));
    }
  }

  int getPlayerPoints(String name){
    for(NamePoints data in players){
      if(data.getName() == name){
        return data.getPoints();
      }
    }
    return 0;
  }

}