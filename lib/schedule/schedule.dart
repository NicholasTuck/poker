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

  Schedule.fromMap(Map scheduleMap){

    blinds = new List<Blind>();
    breaks = new List<Break>();
    levelLength = scheduleMap['levelLength'];

    List allBlinds = scheduleMap['blinds'];
    allBlinds.forEach((Map blindMap) => this.blinds.add(new Blind.fromMap(blindMap)));

    List allBreaks = scheduleMap['breaks'];
    allBreaks.forEach((Map breakMap) => this.breaks.add(new Break.fromMap(breakMap)));
  }

  Map toMap(){
    List<Map> blindMapList = [];
    blinds.forEach((Blind blind) => blindMapList.add(blind.toMap()));

    List<Map> breakMapList = [];
    breaks.forEach((Break currentBreak) => breakMapList.add(currentBreak.toMap()));

    return {'levelLength': levelLength,
            'blinds':blindMapList,
            'breaks':breakMapList
          };
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