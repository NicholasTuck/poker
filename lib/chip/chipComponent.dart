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
    _rootScope.on(NEXT_EVENT_STARTED).listen((_) => checkToColorUp());

  }

  Schedule get _schedule => _scheduleModel.schedule;

  void checkToColorUp() {
    final int blindToStartFrom = (_schedule.onBreak) ? _schedule.currentBlindNumber + 1 : _schedule.currentBlindNumber;

    for (int chipIndex = chips.length - 1; chipIndex >= 0; chipIndex--) {
      Chip currentChip = chips[chipIndex];
      bool allBlindsDivisibleByChip = true;

      for (int blindIndex = blindToStartFrom; blindIndex < _schedule.blinds.length; blindIndex++) {
        Blind currentBlind = _schedule.blinds[blindIndex];

        if (currentBlind.smallBlind % currentChip.value != 0) {
          allBlindsDivisibleByChip = false;
          break;
        }
      }

      if (allBlindsDivisibleByChip) {
        colorUpChips(chips.getRange(0, chipIndex));
        break;
      }
    }

  }

  void colorUpChips(List<Chip> chips) {
    chips.forEach((Chip chipToColorUp) {
      if (chipToColorUp.colorUp) {
        chipToColorUp.hide = true;
      }
      chipToColorUp.colorUp = true;
    });
  }

  List<Chip> get filteredChipList {
    return chips.where((Chip chip) => chip.hide == false);
  }

}
