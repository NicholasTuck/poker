import 'package:angular/angular.dart';
import 'package:pokertimer/chip/chip.dart';
import 'package:pokertimer/schedule/blinds/blind.dart';
import 'package:pokertimer/schedule/break/break.dart';
import 'package:pokertimer/schedule/schedule.dart';
import 'package:pokertimer/schedule/ScheduleModel.dart';
import 'package:pokertimer/session/SessionModel.dart';
import 'package:logging/logging.dart';
import 'dart:html';
//import 'package:paper_elements/paper_button.dart';

@Controller(
    selector: '[poker-controller]',
    publishAs: 'controller'
)
class PokerController {
  Scope _scope;
  RootScope _rootScope;

  static final Logger log = new Logger("PokerController");
  static const bool DEBUGGING = true;
  static const String _DEFAULT_SCHEDULE_NAME = 'Default Schedule';
  ScheduleModel _scheduleModel;
  SessionModel _sessionModel;

  bool isRunning = false;
  bool isSuddenDeath = false;

  Schedule _schedule;

  List<Chip> chips = new List<Chip>()
    ..add(new Chip(value: 5, color: "Red"))
    ..add(new Chip(value: 25, color: "Green"))
    ..add(new Chip(value: 100, color: "Black"));

  PokerController(Scope this._scope, this._rootScope, ScheduleModel this._scheduleModel, SessionModel this._sessionModel) {
    _rootScope.on(NEW_SCHEDULE_LOADED_EVENT).listen((ScopeEvent event) => loadSchedule(event.data as Schedule));
    _rootScope.on(LEVEL_COMPLETED_EVENT).listen((_) => playAudio());
    _rootScope.on(NEXT_EVENT_STARTED).listen((_) => startNextLevel());
    _rootScope.on(ALL_EVENTS_COMPLETED).listen((_) => startSuddenDeath());

    loadSchedule(_scheduleModel.schedule);
  }

  void loadSchedule(Schedule newSchedule) {
    _schedule = newSchedule;
    resetApp();
  }

  bool get editMode => _sessionModel.editMode;

  List<Blind> get blinds => _schedule.blinds;
  List<Break> get breaks => _schedule.breaks;

  String get controlText => isRunning ? "Pause" : "Play";
  Blind get currentBlind => _schedule.currentBlind;
  Blind get nextBlind => _schedule.nextBlind;
  int get currentLevel => _schedule.currentBlindNumber;
  get levelLength => _schedule.levelLength;

  Break get currentBreak => _schedule.currentBreak;
  Break get nextBreak => _schedule.nextBreak;
  bool get breakIsNext => _schedule.breakIsNext;
  bool get onBreak => _schedule.onBreak;

  int get currentCountdownLength {
    if (_schedule.onBreak) {
      return currentBreak.length;
    } else {
      return _schedule.levelLength;
    }
  }

  int get nextCountdownLength {
    if (_schedule.breakIsNext) {
      return nextBreak.length;
    } else {
      return _schedule.levelLength;
    }
  }

  String get currentLevelIdentifier => (_schedule.onBreak ? "b" : currentLevel + 1);
  String get nextLevelIdentifier => (breakIsNext ? "b" : currentLevel + 2);

  void toggleTimer() {
    isRunning = !isRunning;
  }

  void startNextLevel() {
    _scope.broadcast("restartCountdown");
  }

  bool get isLastLevel => _schedule.currentBlindNumber == (_schedule.blinds.length - 1);

  void resetLevel() {_scope.broadcast("resetCountdown");}

  void onTimerToggled(ScopeEvent scopeEvent, bool toggledOn) {isRunning = toggledOn;}

  void playAudio() {
    AudioElement audioElement = (querySelector("#timer-alert") as AudioElement);
//    audioElement.currentTime = 0;     // current time is not being set properly here in dartium
    audioElement.src = "audio/Alarm-Positive.wav";    // workaround for dartium
    audioElement.play();
  }

  void startSuddenDeath() {
    isSuddenDeath = true;
  }

  void resetApp() {
    isRunning = false;
    _schedule.reset();
    isSuddenDeath = false;
    resetLevel();
  }

}