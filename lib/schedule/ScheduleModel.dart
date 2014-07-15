library poker_timer.schedule.ScheduleModel;

import 'package:angular/angular.dart';
import 'schedule.dart';
import 'blinds/blind.dart';
import 'break.dart';

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
      ..add(new Blind.blindsOnly(25, 50))
      ..add(new Blind.anteOnly(100))
      ..add(new Blind(75, 150, 50))
      ..add(new Blind.blindsOnly(100, 200))
      ..add(new Blind.blindsOnly(200, 400))
      ..add(new Blind.blindsOnly(500, 1000))
      ..add(new Blind.blindsOnly(1000, 2000));

    List<Break> breaks = new List<Break>()
      ..add(new Break(2, 5))
      ..add(new Break(4, 5))
      ..add(new Break(6, 10));

    _schedule = new Schedule(blinds, breaks);

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
