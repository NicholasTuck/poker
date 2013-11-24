library blinds;

import 'package:angular/angular.dart';
import 'package:logging/logging.dart';
import 'dart:core';

@NgComponent(
    selector: 'blinds',
    templateUrl: 'blinds.html',
    cssUrl: 'blinds.css',
    publishAs: 'controller')

class BlindsController {
  static final Logger log = new Logger("BlindsController");

  Scope _scope;

  int _smallBlind = 25;
  int _bigBlind = 50;

  BlindsController(Scope this._scope) {

    _scope.$on("levelChanged", changeLevel);
  }

  set smallBlind(int smallBlind) {
    _smallBlind = smallBlind;
  }

  set bigBlind(int bigBlind) {
    _bigBlind = bigBlind;
  }

  String get currentBlinds => _smallBlind.toString() + " - " + _bigBlind.toString();
  String get nextLevelBlinds => (_smallBlind * 2).toString() + " - " + (_bigBlind * 2).toString();

  void changeLevel() {

    _smallBlind *= 2;
    _bigBlind *= 2;
//
//
//    List<int> blinds = new List();
//    blinds.add(_smallBlind);
//    blinds.add(_bigBlind);
//    _scope.$emit("blindsUpdated", blinds);

    log.fine("New Blinds: " + currentBlinds);
  }
}
