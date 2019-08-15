import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

// Player data classs
class PlayerData {
  //every field in player document
  String name;
  int goals;
  int appearances;
  int assistFlicks;
  int assists;
  int boatRaceLoss;
  int boatRaceWin;
  int defender2Conceeded;
  int defender5Conceeded;
  int defenderCleanSheets;
  int defenderGoals;
  int donkeys;
  int motms;
  int flickGoals;
  int forwardGoals;
  int greenCards;
  int gw;
  int midfieldCleenSheets;
  int midfielderGoals;
  int missedFlicks;
  int ownGoals;
  int price;
  int redCards;
  int shortGoals;
  int totalPoints;
  int yellowCards;
  int position;
  String team; 


  //Constructor for player with given name
  PlayerData(String name){
    if(name == null) {
      return;
    }
    this.name = name;
    this.goals = 0;
    this.appearances = 0;
    this.assistFlicks = 0;
    this.assists = 0;
    this.boatRaceLoss = 0;
    this.boatRaceWin = 0;
    this.defender2Conceeded = 0;
    this.defender5Conceeded = 0;
    this.defenderCleanSheets = 0;
    this.defenderGoals = 0;
    this.donkeys = 0;
    this.motms = 0;
    this.flickGoals = 0;
    this.forwardGoals = 0;
    this.greenCards = 0;
    this.gw = 0;
    this.midfieldCleenSheets = 0;
    this.midfielderGoals = 0;
    this.missedFlicks = 0;
    this.ownGoals = 0;
    this.price = 0;
    this.redCards = 0;
    this.shortGoals = 0;
    this.totalPoints = 0;
    this.yellowCards = 0;
  }

  //get Deta from a Firebase document
  void loadData(DocumentSnapshot player){
    this.name = player.documentID;
    this.goals = player['defenderGoals'] + player['midfielderGoals'] + 
        player['forwardGoals'] + player['shortGoals'] + player['flickGoals'];
    this.appearances = player['appearances'];
    this.assistFlicks = player['assistFlicks'];
    this.assists = player['assists'];
    this.boatRaceLoss = player['boatRaceLoss'];
    this.boatRaceWin = player['boatRaceWin'];
    this.defender2Conceeded = player['defender2Conceeded'];
    this.defender5Conceeded = player['defender5Conceeded'];
    this.defenderCleanSheets = player['defenderCleanSheets'];
    this.defenderGoals = player['defenderGoals'];
    this.donkeys = player['donkeys'];
    this.motms = player['motms'];
    this.flickGoals = player['flickGoals'];
    this.forwardGoals = player['forwardGoals'];
    this.greenCards = player['greenCards'];
    this.gw = player['gw'];
    this.midfieldCleenSheets = player['midfieldCleenSheets'];
    this.midfielderGoals = player['midfielderGoals'];
    this.missedFlicks = player['missedFlicks'];
    this.ownGoals = player['ownGoals'];
    this.price = player['price'];
    this.redCards = player['redCards'];
    this.shortGoals = player['shortGoals'];
    this.totalPoints = player['totalPoints'];
    this.yellowCards = player['yellowCards'];
    this.position = player['position'];
    this.team = player['team'];
  }

  //getter for name
  String getName(){
    return name;
  }
  
  //getter for all object data
  List toList() {
    return [this.appearances, this.assistFlicks, this.assists, this.boatRaceLoss,
      this.boatRaceWin, this.defender2Conceeded, this.defender5Conceeded,
      this.defenderCleanSheets, this.defenderGoals, this.donkeys, this.motms,
      this.flickGoals, this.forwardGoals, this.greenCards, this.goals, this.gw,
      this.midfieldCleenSheets, this.midfielderGoals, this.missedFlicks,
      this.ownGoals, this.price, this.redCards, this.shortGoals, this.totalPoints,
      this.yellowCards, this.position, this.team];
  }

  @override //This is useless atm
  String toString(){
    return toList().toString();
  }

  //Used to merge firestore and local
  void add(PlayerData newdata){
    if(newdata.getName() != this.name){
      throw IOException;
    }
    //Increase all fields in this object by new object
    List i = newdata.toList();
    this.appearances += i[0];
    this.assistFlicks += i[1];
    this.assists += i[2];
    this.boatRaceLoss += i[3];
    this.boatRaceWin += i[4];
    this.defender2Conceeded += i[5];
    this.defender5Conceeded += i[6];
    this.defenderCleanSheets += i[7];
    this.defenderGoals += i[8];
    this.donkeys += i[9];
    this.motms += i[10];
    this.flickGoals += i[11];
    this.forwardGoals += i[12];
    this.greenCards += i[13];
    this.goals += i[14];
    this.gw += i[15];
    this.midfieldCleenSheets += i[16];
    this.midfielderGoals += i[17];
    this.missedFlicks += i[18];
    this.ownGoals += i[19];
    this.price += i[20];
    this.redCards += i[21];
    this.shortGoals += i[22];
    this.totalPoints += i[23];
    this.yellowCards += i[24];
    this.position = i[25];
    this.team = i[26];
  }

  //used to parse data to write
  Map toMap(){
    return {
      'appearences': this.appearances,
      'assistFlicks': this.assistFlicks,
      'assists': this.assists,
      'boatRaceLoss': this.boatRaceLoss,
      'boatRaceWin': this.boatRaceWin,
      'defender2Conceeded': this.defender2Conceeded,
      'defender5Conceeded': this.defender5Conceeded,
      'defenderCleanSheets': this.defenderCleanSheets,
      'defenderGoals': this.defenderGoals,
      'donkeys': this.donkeys,
      'motms': this.motms,
      'flickGoals': this.flickGoals,
      'forwardGoals': this.forwardGoals,
      'greenCards': this.greenCards,
      'goals': this.goals,
      'gw': this.gw,
      'midfieldCleenSheets': this.midfieldCleenSheets,
      'midfielderGoals': this.midfielderGoals,
      'missedFlicks': this.missedFlicks,
      'ownGoals': this.ownGoals,
      'price': this.price,
      'redCards': this.redCards,
      'shortGoals': this.shortGoals,
      'totalPoints': this.totalPoints,
      'yellowCards': this.yellowCards,
      'position': this.position,
      'team': this.team,
    };
  }

  //used to get field names, could maybe format them better
  List fieldList() {
    return ['appearances', 'assistFlicks', 'assists', 'boatRaceLoss', 'boatRaceWin', 'defender2Conceeded',
    'defender5Conceeded', 'defenderCleanSheets', 'defenderGoals', 'donkeys', 'motms', 'flickGoals',
    'forwardGoals', 'greenCards', 'goals', 'gw', 'midfieldCleenSheets', 'midfielderGoals', 'missedFlicks',
    'ownGoals', 'price', 'redCards', 'shortGoals', 'totalPoints', 'yellowCards', 'position', 'team'];
  }
}
