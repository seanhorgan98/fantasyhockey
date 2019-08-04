import 'package:cloud_firestore/cloud_firestore.dart';

class PlayerData {
  String name;
  int price;
  int totalPoint;
  int appearances;
  int goal;
  int penalty;
  int assists;
  int sheet;
  double ppg;
  int boatRace;
  int motm;
  int donkey;
  int cards;

  PlayerData(DocumentSnapshot player){
    this.name = player.documentID;
    this.price = player['price'];
    this.totalPoint = player['totalPoints'];
    this.appearances = player['appearances'];
    this.goal = player['defenderGoals'] + player['midfielderGoals'] + player['forwardGoals'];
    this.penalty = player['flickGoals'] + player['shortGoals'] - player['missedFlicks'];
    this.assists = player['assists'] + player['assistFlicks'];
    this.sheet = player['defenderCleanSheets'] + player['midfieldCleanSheets'];
    this.ppg = player['totalPoints'] / player['appearances'];
    this.boatRace = player['boatRaceWin'] - player['boatRaceLoss'];
    this.motm = player['motms'];
    this.donkey = player['donkeys'];
    this.cards = player['greenCards'] + player['yellowCards'] * 2 + player['redCards'] * 5;
  }

  List toList() {
    return [name, price, totalPoint, appearances, ppg, goal, penalty, assists, sheet, boatRace, motm, donkey, cards];
  }

  List transferList(){
    return [name, price, totalPoint, appearances];
  }

  String transferListString(){
    return transferList().toString();
  }

  @override
  String toString(){
    return toList().toString();
  }
}
