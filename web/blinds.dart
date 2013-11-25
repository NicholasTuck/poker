library blinds;

import 'package:angular/angular.dart';
import 'package:logging/logging.dart';
import 'dart:core';
import 'package:PokerTimer/blinds/blind.dart';


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
  
  int currentLevel;

  List<Blind> blinds = new List<Blind>()
      ..add(new Blind.blindsOnly(25, 50))
      ..add(new Blind.blindsOnly(50, 100))
      ..add(new Blind.blindsOnly(75, 150))
      ..add(new Blind.blindsOnly(100, 200))
      ..add(new Blind.blindsOnly(200, 400))
      ..add(new Blind.blindsOnly(500, 1000))
      ..add(new Blind.blindsOnly(1000, 2000));
  
  BlindsController(Scope this._scope) {
    
  }
  
  Blind get currentBlind => blinds[currentLevel];
  Blind get nextBlind => blinds[currentLevel + 1];
  
  String get currentBlinds => "${currentBlind.smallBlind} - ${currentBlind.bigBlind}";
  String get nextLevelBlinds =>  "${nextBlind.smallBlind} - ${nextBlind.bigBlind}";

//  void startNextLevel() {


//    List<int> blinds = new List();
//    blinds.add(_smallBlind);
//    blinds.add(_bigBlind);
//    _scope.$emit("blindsUpdated", blinds);

//    log.fine("New Blinds: " + currentBlinds);
//  }
}
