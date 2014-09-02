library chips;

import '../schedule/schedule.dart';
import '../schedule/blinds/blind.dart';
import '../schedule/ScheduleModel.dart';
import 'package:angular/angular.dart';
import 'package:logging/logging.dart';
import 'dart:core';
import 'chip.dart';

@Component(
    selector: 'chip',
    templateUrl: 'packages/pokertimer/chip/chipComponent.html',
    cssUrl: 'packages/pokertimer/chip/chipComponent.css',
    publishAs: 'cmp')

class ChipComponent {
  static final Logger log = new Logger("ChipComponent");
  @NgOneWay('chips') List<Chip> chips;
  ScheduleModel _scheduleModel;
  RootScope _rootScope;

  ChipComponent(RootScope this._rootScope, ScheduleModel this._scheduleModel) {
    _rootScope.on(NEXT_EVENT_STARTED).listen((_) => nextLevelStarted());

  }

  Schedule get _schedule => _scheduleModel.schedule;

  void nextLevelStarted() {
    final int blindToStartFrom = (_schedule.onBreak) ? _schedule.currentBlindNumber + 1 : _schedule.currentBlindNumber;

    for (int i = chips.length - 1; i >= 0; i--) {
      Chip currentChip = chips[i];
      bool allBlindsDivisibleByChip = true;

      for (int j = blindToStartFrom; j < _schedule.blinds.length; j++) {
        Blind currentBlind = _schedule.blinds[j];

        if (currentBlind.smallBlind % currentChip.value != 0) {
          allBlindsDivisibleByChip = false;
          break;
        }
      }

      if (allBlindsDivisibleByChip) {
        for (int k = i - 1; k >= 0; k--) {
          Chip chipToEliminate = chips[k];
          if (chipToEliminate.colorUp) {
            chipToEliminate.hide = true;
          }
          chipToEliminate.colorUp = true;
        }
        break;
      }

    }

  }

  List<Chip> get filteredChipList {
    return chips.where((Chip chip) => chip.hide == false);
  }

}
