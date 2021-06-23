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
  int price;
  int total;
  int position;
  int apps;

  NamePoints(DocumentSnapshot snapshot){
    if(snapshot == null){
      throw IOException;
    }
    this.name = snapshot.documentID;
    this.gwPoints = snapshot['gw'];
    this.price = snapshot['price'];
    this.total = snapshot['totalPoints'];
    this.position = snapshot['position'];
    this.apps = snapshot['appearances'];
  }

  int getGWPoints(){
    return this.gwPoints;
  }

  int getApps(){
    return this.apps;
  }

  int getPrice(){
    return this.price;
  }

  int getTotal(){
    return this.total;
  }

  String getName(){
    return this.name;
  }

  int getPosition(){
    return this.position;
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
        return data.getGWPoints();
      }
    }
    return 0;
  }

  PlayerList filterPos(int pos){
    if(pos == 3){
      return this;
    }

    List toRemove = [];
    this.players.forEach( (i) {
      if(i.getPosition() != pos){
        toRemove.add(i);
      }
    } );

    this.players.removeWhere( (i) => toRemove.contains(i));
    return this;
  }

  PlayerList sort(String field){
    switch(field){
      case "apps":
        this.players.sort((a,b) => b.getApps().compareTo(a.getApps()));
        break;
      case "totalPoints":
        this.players.sort((a,b) => b.getTotal().compareTo(a.getTotal()));
        break;
      case "price":
        this.players.sort((a,b) => b.getPrice().compareTo(a.getPrice()));
        break;
    }
    return this;
  }

  int getLength(){
    return this.players.length;
  }

  NamePoints getPlayer(int index){
    return this.players[index];
  }
}