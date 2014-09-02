library schedule;

import 'package:pokertimer/schedule/blinds/blind.dart';
import 'break/break.dart';
import '../chip/chip.dart';

class Schedule{

  int levelLength = 20;
  List<Blind> blinds;
  int currentBlindNumber = 0;
  
  List<Break> breaks;
  int currentBreakNumber = -1;

  List<Chip> chips;

  bool onBreak = false;
  
  Schedule(this.blinds, this.breaks, this.chips);
  Schedule.blindsOnly(this.blinds): this.breaks = new List<Break>();

  Schedule.fromMap(Map scheduleMap){


    levelLength = scheduleMap['levelLength'];

    blinds = new List<Blind>();
    List allBlinds = scheduleMap['blinds'];
    allBlinds.forEach((Map blindMap) => this.blinds.add(new Blind.fromMap(blindMap)));

    breaks = new List<Break>();
    List allBreaks = scheduleMap['breaks'];
    if(allBreaks != null) {
      allBreaks.forEach((Map breakMap) => breaks.add(new Break.fromMap(breakMap)));
    }

    chips = new List<Chip>();
    List allChips = scheduleMap['chips'];
    if(allChips != null) {
      allChips.forEach((Map chipMap) => chips.add(new Chip.fromMap(chipMap)));
    } else {
      chips = createDefaultChips();
    }
  }

  Map toMap(){
    List<Map> blindMapList = [];
    blinds.forEach((Blind blind) => blindMapList.add(blind.toMap()));

    List<Map> breakMapList = [];
    breaks.forEach((Break currentBreak) => breakMapList.add(currentBreak.toMap()));

    List<Map> chipMapList = [];
    chips.forEach((Chip currentChip) => chipMapList.add(currentChip.toMap()));

    return {'levelLength': levelLength,
            'blinds': blindMapList,
            'breaks': breakMapList,
            'chips': chipMapList
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

  static List<Chip> createDefaultChips() {
    List<Chip> chips = new List<Chip>()
      ..add(new Chip(value: 5, color: "red"))
      ..add(new Chip(value: 10, color: "white"))
      ..add(new Chip(value: 25, color: "green"))
      ..add(new Chip(value: 100, color: "black"))
      ..add(new Chip(value: 500, color: "purple"));
    return chips;
  }


}