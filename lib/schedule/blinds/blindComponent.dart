library blinds;

import 'package:angular/angular.dart';
import 'package:logging/logging.dart';
import 'dart:core';
import 'blind.dart';


@Component(
    selector: 'blind',
    templateUrl: 'packages/pokertimer/schedule/blinds/blindComponent.html',
    cssUrl: 'packages/pokertimer/schedule/blinds/blindComponent.css',
    publishAs: 'controller',
    map: const {
        'blind' : '=>blind'
      })

class BlindController {
  static final Logger log = new Logger("BlindController");
  Blind blind;

  BlindController() { }

}
