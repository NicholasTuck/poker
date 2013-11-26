library blinds;

import 'package:angular/angular.dart';
import 'package:logging/logging.dart';
import 'dart:core';

part 'blind.dart';


@NgComponent(
    selector: 'blinds',
    templateUrl: 'packages/pokertimer/blinds/blinds.html',
    cssUrl: 'packages/pokertime/blinds/blinds.css',
    publishAs: 'controller',
    map: const {
        'current-level' : '=>currentLevel'
      })

class BlindsController {
  static final Logger log = new Logger("BlindsController");
  Scope _scope;
  
  int currentLevel;
  List<Blind> blinds;
  
  BlindsController(Scope this._scope) { }
  
  Blind get currentBlind => blinds[currentLevel];
  Blind get nextBlind => blinds[currentLevel + 1];
  
  String get currentBlinds => "${currentBlind.smallBlind} - ${currentBlind.bigBlind}";
  String get nextLevelBlinds =>  "${nextBlind.smallBlind} - ${nextBlind.bigBlind}";

}
