library blinds;

import 'package:angular/angular.dart';
import 'package:logging/logging.dart';
import 'dart:core';

@NgComponent(
    selector: 'blinds',
    templateUrl: 'blinds.html',
    cssUrl: 'blinds.css',
    publishAs: 'controller',
    map: const {
        'current-level' : '=>currentLevel'
      })

class BlindsController {
  static final Logger log = new Logger("BlindsController");
  Scope _scope;

  int _smallBlind = 25;
  int _bigBlind = 50;
  
  int currentLevel;

  BlindsController(Scope this._scope) {
//    _scope.$on("startNextLevel", startNextLevel);
  }

  String get currentBlinds => "${_smallBlind * currentLevel} - ${_bigBlind * currentLevel}";
  String get nextLevelBlinds =>  "${_smallBlind * currentLevel * 2} - ${_bigBlind * currentLevel * 2}";

//  void startNextLevel() {


//    List<int> blinds = new List();
//    blinds.add(_smallBlind);
//    blinds.add(_bigBlind);
//    _scope.$emit("blindsUpdated", blinds);

//    log.fine("New Blinds: " + currentBlinds);
//  }
}
