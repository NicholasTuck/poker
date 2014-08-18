library schedule.breaks.NextBreakComponent;

import "package:angular/angular.dart";
import 'package:intl/intl.dart';

import "../../session/SessionModel.dart";
import "../../schedule/ScheduleModel.dart";
import "../../schedule/break/break.dart";
import "../../schedule/schedule.dart";

@Component(
    selector: 'next-break',
    templateUrl: 'packages/pokertimer/schedule/break/nextBreakComponent.html',
    cssUrl: 'packages/pokertimer/schedule/break/nextBreakComponent.css',
    publishAs: 'cmp')
class NextBreakComponent {
  SessionModel _sessionModel;
  ScheduleModel _scheduleModel;

  NextBreakComponent(SessionModel this._sessionModel, ScheduleModel this._scheduleModel);

  Schedule get _schedule => _scheduleModel.schedule;

  String get timeUntilNextBreakText {
    if (_schedule.nextBreak == null) return "Never... Hold It!";

    int levelsRemaining = findNumberOfLevelsUntilNextBreak();
    Duration durationUntilNextBreak = new Duration(minutes: _schedule.levelLength * levelsRemaining) + _sessionModel.timeRemainingInCurrentLevel;
    return formatDuration(durationUntilNextBreak);
  }

  int findNumberOfLevelsUntilNextBreak() {
    Break nextBreak = _schedule.nextBreak;
    if (nextBreak != null) {
      return (nextBreak.afterLevelNumber - _schedule.currentBlindNumber - 1);
    } else {
      return 0;
    }
  }

  String formatDuration(Duration duration) {
    String durationOutputString = duration.toString();
    int beginningSubString = (duration.inHours > 0) ? 0 : 2;
    int endingSubString = durationOutputString.length - 7;
    return durationOutputString.substring(beginningSubString, endingSubString);
  }
}
