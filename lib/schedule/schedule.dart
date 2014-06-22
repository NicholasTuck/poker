library schedule;

import 'dart:convert';
import 'package:pokertimer/blinds/blind.dart';
import 'break.dart';

class Schedule{

  List<Blind> blinds;
  int currentBlindNumber = 0;
  
  List<Break> breaks;
  int currentBreakNumber = 0;
  
  Schedule(this.blinds, this.breaks);
  Schedule.blindsOnly(this.blinds): this.breaks = new List<Break>();

  Schedule.fromJson(String jsonScheduleString){
    Map map = JSON.decode(jsonScheduleString);
    List theLevels = map['levels'];

    blinds = new List<Blind>();
    for (var i = 0; i < theLevels.length; i++) {
      this.blinds.add(new Blind(theLevels[i]['small-blind'],theLevels[i]['big-blind'], theLevels[i]['ante']));
    }
  }

  Map toMap(){

    List<Map> blindMapList = [];
    for(Blind blind in blinds){
      blindMapList.add(blind.toMap());
    }

    return {'blinds':blindMapList};
  }

  Blind get currentBlind => blinds[currentBlindNumber];
  //TODO need to return something better.
  Blind get nextBlind => currentBlindNumber + 1 < blinds.length ? blinds[currentBlindNumber + 1] : 9999;
  
  void reset() {
    currentBlindNumber = 0;
    currentBreakNumber = 0;
  }
  
}