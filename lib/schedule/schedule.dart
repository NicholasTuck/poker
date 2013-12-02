library schedule;

import 'dart:convert';
import 'package:pokertimer/blinds/blind.dart';

class Schedule{
  List levels;

  Schedule(String jsonScheduleString){

    Map map = JSON.decode(jsonScheduleString);

    List theLevels = map['levels'];

    levels = new List<Blind>();
    for (var i = 0; i < theLevels.length; i++) {
      this.levels.add(new Blind(theLevels[i]['small-blind'],theLevels[i]['big-blind'], theLevels[i]['ante']));
    }
  }
}