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
  static final DateTime TIME_ZERO = new DateTime.fromMillisecondsSinceEpoch(0);
  static final DateFormat _formatter = new DateFormat.ms();

  SessionModel _sessionModel;
  ScheduleModel _scheduleModel;

  NextBreakComponent(SessionModel this._sessionModel, ScheduleModel this._scheduleModel);

  Schedule get _schedule => _scheduleModel.schedule;

  String get timeUntilNextBreakText {
    if (_schedule.nextBreak == null) return "Never... Hold It!";

    int levelsRemaining = findNumberOfLevelsUntilNextBreak();
    DateTime dateTimeUntilNextBreak = TIME_ZERO.add(new Duration(minutes: _schedule.levelLength * levelsRemaining));
    dateTimeUntilNextBreak = dateTimeUntilNextBreak.add(_sessionModel.timeRemainingInCurrentLevel);

    return _formatter.format(dateTimeUntilNextBreak);
  }

  int findNumberOfLevelsUntilNextBreak() {
    Break nextBreak = _schedule.nextBreak;
    if (nextBreak != null) {
      return (nextBreak.afterLevelNumber - _schedule.currentBlindNumber - 1);
    } else {
      return 0;
    }
  }
}
