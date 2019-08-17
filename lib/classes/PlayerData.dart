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
  int position; //pos, team, name are exluded from other methods
  String team; 


  //Constructor for player with given name
  PlayerData(String name, int position){
    if(name == null || position == null) {
      return;
    }
    this.name = name;
    this.position = position;
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

  //get data from a List length 35
  void setData(List data){
    this.appearances = data[0];
    this.assistFlicks = data[1];
    this.assists = data[2];
    this.boatRaceLoss = data[3];
    this.boatRaceWin = data[4];
    this.defender2Conceeded = data[5];
    this.defender5Conceeded = data[6];
    this.defenderCleanSheets = data[7];
    this.defenderGoals = data[8];
    this.donkeys = data[9];
    this.motms = data[10];
    this.flickGoals = data[11];
    this.forwardGoals = data[12];
    this.greenCards = data[13];
    this.goals = data[14];
    this.gw = data[15];
    this.midfieldCleenSheets = data[16];
    this.midfielderGoals = data[17];
    this.missedFlicks = data[18];
    this.ownGoals = data[19];
    this.price = data[20];
    this.redCards = data[21];
    this.shortGoals = data[22];
    this.totalPoints = data[23];
    this.yellowCards = data[24];
  }

  //getter for name
  String getName(){
    return name;
  }
  
  int getPosition(){
    return this.position;
  }

  //getter for all object data
  List toList() {
    return [this.appearances, this.assistFlicks, this.assists, this.boatRaceLoss,
      this.boatRaceWin, this.defender2Conceeded, this.defender5Conceeded,
      this.defenderCleanSheets, this.defenderGoals, this.donkeys, this.motms,
      this.flickGoals, this.forwardGoals, this.greenCards, this.goals, this.gw,
      this.midfieldCleenSheets, this.midfielderGoals, this.missedFlicks,
      this.ownGoals, this.price, this.redCards, this.shortGoals, this.totalPoints,
      this.yellowCards];
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
    this.gw = i[15];
    this.midfieldCleenSheets += i[16];
    this.midfielderGoals += i[17];
    this.missedFlicks += i[18];
    this.ownGoals += i[19];
    this.price += i[20];
    this.redCards += i[21];
    this.shortGoals += i[22];
    this.totalPoints += i[23];
    this.yellowCards += i[24];
  }

  int cleanSheetPoints(){
    switch (position){
      case 0:
        return 5;
        break;
      case 1:
        return 1;
        break;
    }
    return 0;
  }

  int concededPoints(){
    if(this.position == 0){
      return ((this.defender2Conceeded * -1) + (this.defender5Conceeded * -2));
    }
    return 0;
  }

  void calcPoints(){
    this.goals = ( this.defenderGoals + this.midfielderGoals + this.forwardGoals
     + this.shortGoals + this.flickGoals );
      
    this.gw = (
      ( (this.defenderGoals + this.midfielderGoals + this.forwardGoals) *(6-this.position) ) +
          ( (this.shortGoals + this.flickGoals) * 3) +
      (this.appearances * 1) +
      (this.missedFlicks * -3) +
      (this.assistFlicks + this.assists * 3) +
      (this.ownGoals * -4) +
      (this.defenderCleanSheets + this.midfieldCleenSheets * (cleanSheetPoints()) ) +
      ( concededPoints() ) +
      (this.greenCards * -2 + this.yellowCards * -5 + this.redCards * -20 ) +
      (this.motms * 5 + this.donkeys * -3) +
      (this.boatRaceLoss * -3 + this.boatRaceWin * 5) 
    );

    this.totalPoints += this.gw;

  }

  //used to parse data to write
  Map toMap(){
    return {
      'appearances': this.appearances,
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
    };
  }

  //used to get formatted field names
  // only fields in List
  List fieldListFancy() {
    return ['Appearances',
      'Assist Flicks',
      'Assists',
      'BoatRace Loss',
      'BoatRace Win',
      'Def 2 Against',
      'Def 5 Against',
      'Def Clean',
      'Def Goals',
      'Donkey',
      'MotM',
      'Flick',
      'Forward Goals',
      'Green',
      'Goal',
      'GW',
      'Mid Cleen',
      'Mid Goals',
      'Missed Flicks',
      'Own Goals',
      'Price',
      'Red Cards',
      'Short Goals',
      'Total Points',
      'Yellow Cards',
    ];
  }

  //used for field names to write to db
  List fieldList(){
    return [
      'appearences',
      'assistFlicks',
      'assists',
      'boatRaceLoss',
      'boatRaceWin',
      'defender2Conceeded',
      'defender5Conceeded',
      'defenderCleanSheets',
      'defenderGoals',
      'donkeys',
      'motms',
      'flickGoals',
      'forwardGoals',
      'greenCards',
      'goals',
      'gw',
      'midfieldCleenSheets',
      'midfielderGoals',
      'missedFlicks',
      'ownGoals',
      'price',
      'redCards',
      'shortGoals',
      'totalPoints',
      'yellowCards',
    ];
  }
}
