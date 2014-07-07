library schedule;

import 'dart:convert';
import 'package:pokertimer/schedule/blinds/blind.dart';
import 'break.dart';

class Schedule{

  int levelLength = 20;
  List<Blind> blinds;
  int currentBlindNumber = 0;
  
  List<Break> breaks;
  int currentBreakNumber = -1;

  bool onBreak = false;
  
  Schedule(this.blinds, this.breaks);
  Schedule.blindsOnly(this.blinds): this.breaks = new List<Break>();

  //todo add breaks and level length
  Schedule.fromJson(String jsonScheduleString){
    Map map = JSON.decode(jsonScheduleString);
    List allLevels = map['levels'];

    blinds = new List<Blind>();
    for (var i = 0; i < allLevels.length; i++) {
      this.blinds.add(new Blind(allLevels[i]['small-blind'],allLevels[i]['big-blind'], allLevels[i]['ante']));
    }
  }

  //todo add breaks and level length
  Map toMap(){
    List<Map> blindMapList = [];
    for(Blind blind in blinds){
      blindMapList.add(blind.toMap());
    }

    return {'levels':blindMapList};
  }

  Blind get currentBlind => blinds[currentBlindNumber];
  //TODO need to return something better.
  Blind get nextBlind => currentBlindNumber + 1 < blinds.length ? blinds[currentBlindNumber + 1] : 9999;

  Break get currentBreak => (onBreak ? breaks[currentBreakNumber] : null);
  Break get nextBreak => (currentBreakNumber + 1 < breaks.length ? breaks[currentBreakNumber + 1] : null);

  bool get breakIsNext => (nextBreak != null && nextBreak.afterLevelNumber == (currentBlindNumber + 1));

  void reset() {
    currentBlindNumber = 0;
    currentBreakNumber = -1;
  }

  void startNextEvent() {
    if (!breakIsNext) {
      currentBlindNumber++;
      onBreak = false;
    } else {
      currentBreakNumber++;
      onBreak = true;
    }

  }
  
}