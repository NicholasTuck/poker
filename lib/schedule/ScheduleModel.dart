library poker_timer.schedule.ScheduleModel;

import 'package:angular/angular.dart';
import 'schedule.dart';
import 'blinds/blind.dart';
import 'break/break.dart';
import '../chip/chip.dart';

const String NEW_SCHEDULE_LOADED_EVENT = 'ScheduleModel:NEW_SCHEDULE_LOADED';
const String NEXT_EVENT_STARTED = 'ScheduleModel:NEXT_EVENT_STARTED';
const String ALL_EVENTS_COMPLETED = 'ScheduleModel:ALL_EVENTS_COMPLETED';
const String LEVEL_COMPLETED_EVENT = 'ScheduleModel:LEVEL_COMPLETED_EVENT';


@Injectable()
class ScheduleModel {
  RootScope _rootScope;

  Schedule _schedule;

  ScheduleModel(RootScope this._rootScope) {

    List<Blind> blinds = new List<Blind>()
      ..add(new Blind.blindsOnly(10, 20))
      ..add(new Blind.blindsOnly(15, 30))
      ..add(new Blind.blindsOnly(20, 40))
      ..add(new Blind.blindsOnly(25, 50))
      ..add(new Blind.blindsOnly(50, 100))
      ..add(new Blind.blindsOnly(75, 150))
      ..add(new Blind.blindsOnly(100, 200))
      ..add(new Blind.blindsOnly(150, 300))
      ..add(new Blind.blindsOnly(200, 400))
      ..add(new Blind.blindsOnly(300, 600))
      ..add(new Blind.blindsOnly(400, 800))
      ..add(new Blind.blindsOnly(500, 1000))
      ..add(new Blind.blindsOnly(600, 1200))
      ..add(new Blind.blindsOnly(800, 1600))
      ..add(new Blind.blindsOnly(1000, 2000));

    List<Break> breaks = new List<Break>()
      ..add(new Break(3, 10))
      ..add(new Break(6, 10))
      ..add(new Break(9, 10))
      ..add(new Break(12, 10));

    _schedule = new Schedule(blinds, breaks, Schedule.createDefaultChips());

  }

  Schedule get schedule => _schedule;
  set schedule(Schedule newSchedule) {
    _schedule = newSchedule;
    _rootScope.emit(NEW_SCHEDULE_LOADED_EVENT, _schedule);
  }

  completeCurrentLevel() {
    _rootScope.emit(LEVEL_COMPLETED_EVENT);
    if(_notCompleteWithAllLevels()) {
      _schedule.startNextEvent();
      _rootScope.emit(NEXT_EVENT_STARTED);
    } else {
      _rootScope.emit(ALL_EVENTS_COMPLETED);
    }

  }

  bool _notCompleteWithAllLevels() {
    return _schedule.currentBlindNumber + 1 < _schedule.blinds.length;
  }
}
