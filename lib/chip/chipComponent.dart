library chips;

import 'package:angular/angular.dart';
import 'package:logging/logging.dart';
import 'dart:core';
import 'chip.dart';

@Component(
    selector: 'chip',
    templateUrl: 'packages/pokertimer/chip/chipComponent.html',
    cssUrl: 'packages/pokertimer/chip/chipComponent.css',
    publishAs: 'controller',
    map: const {
        'chip' : '=>chip'
      })

class ChipController {
  static final Logger log = new Logger("ChipController");
  Chip chip;

  ChipController() { }

}
