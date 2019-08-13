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


  PlayerData(String name, String team, int position){
    if(name == null || team == null || position == null){
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
    this.position = position;
    this.team = team;
  }

  getFullData(DocumentSnapshot player){
    this.name = player.documentID;
    this.goals = player['defenderGoals'] + player['midfielderGoals'] + player['forwardGoals'];
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
    this.midfieldCleenSheets = player['midfieldCleanSheets'];
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

  String getName(){
    return name;
  }
  
  List toList() {
    return [name, price, totalPoints, appearances,goals, assists, boatRaceWin, motms, donkeys];
  }

  @override
  String toString(){
    return toList().toString();
  }
}
