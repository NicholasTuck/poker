library schedule;

import 'dart:convert';
import 'package:pokertimer/blinds/blind.dart';
import 'break.dart';

class Schedule{
  List<Blind> blinds;
  int currentBlindNumber = 0;
  
  List<Break> breaks;
  int currentBreakNumber = 0;
  
  Schedule(this.blinds);

  Schedule.fromJson(String jsonScheduleString){

    Map map = JSON.decode(jsonScheduleString);

    List theLevels = map['levels'];

    blinds = new List<Blind>();
    for (var i = 0; i < theLevels.length; i++) {
      this.blinds.add(new Blind(theLevels[i]['small-blind'],theLevels[i]['big-blind'], theLevels[i]['ante']));
    }
  }

  Blind get currentBlind => blinds[currentBlindNumber];
  Blind get nextBlind => blinds[currentBlindNumber + 1];
  
  void reset() {
    currentBlindNumber = 0;
    currentBreakNumber = 0;
  }
  
}