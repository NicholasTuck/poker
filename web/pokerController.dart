import 'package:angular/angular.dart';
import 'package:pokertimer/chip/chip.dart';
import 'package:pokertimer/schedule/blinds/blind.dart';
import 'package:pokertimer/schedule/break.dart';
import 'package:pokertimer/schedule/schedule.dart';
import 'package:pokertimer/schedule/saved/scheduleService.dart';
import 'package:logging/logging.dart';
//import 'package:paper_elements/paper_button.dart';

import 'dart:html';

@Controller(
    selector: '[poker-controller]',
    publishAs: 'controller'
)
class PokerController {
  Scope _scope;
  static final Logger log = new Logger("PokerController");
  static const bool DEBUGGING = true;
  ScheduleService _scheduleService;

  bool isRunning = false;

  bool isSuddenDeath = false;
  Schedule _schedule;


  String selectedServerSchedule;
  String nameToSaveScheduleAs;
  List<String> savedScheduleNames = [];

  List<Chip> chips = new List<Chip>()
    ..add(new Chip(value: 5, color: "Red"))
    ..add(new Chip(value: 25, color: "Green"))
    ..add(new Chip(value: 100, color: "Black"));

  PokerController(Scope this._scope, this._scheduleService) {
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

    if (DEBUGGING) {
      blinds.removeRange(5, blinds.length);
    }

    savedScheduleNames = _scheduleService.retrieveSavedScheduleNames();
    selectedServerSchedule = noAvailableSchedules() ? "" : savedScheduleNames.first;

  }

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
    _schedule.startNextEvent();
    _scope.broadcast("restartCountdown");
  }

  bool get isLastLevel => _schedule.currentBlindNumber == (_schedule.blinds.length - 1);

  void resetLevel() {_scope.broadcast("resetCountdown");}

  void onTimerToggled(ScopeEvent scopeEvent, bool toggledOn) {isRunning = toggledOn;}

  void onLevelComplete() {
    AudioElement audioElement = (querySelector("#timer-alert") as AudioElement);
//    audioElement.currentTime = 0;     // current time is not being set properly here in dartium
    audioElement.src = "audio/Alarm-Positive.wav";    // workaround for dartium
    audioElement.play();

    if (notCompleteWithAllLevels()) {
      startNextLevel();
    } else {
      startSuddenDeath();
    }
  }

  void startSuddenDeath() {
    isSuddenDeath = true;
  }

  bool notCompleteWithAllLevels() {
    return _schedule.currentBlindNumber + 1 < _schedule.blinds.length;
  }

  void resetApp() {
    isRunning = false;
    _schedule.reset();
    isSuddenDeath = false;
    resetLevel();
  }

  void toggleAdminArea() {
    var adminArea = window.document.querySelector('#adminArea');
    adminArea.hidden = !adminArea.hidden;
  }

  void onFileLoad() {

    var uploadInput = window.document.querySelector('#upload'); //todo refactor to see if we can do this angular like
    List files = uploadInput.files;
    if (files.length == 1) {
      File file = files[0];
      final reader = new FileReader();
      reader.onLoadEnd.listen((value) => parseData(reader.result));
      reader.readAsText(file);
    }
    uploadInput.value = null;
  }

  void parseData(var result) {
    _schedule = new Schedule.fromMap(result);
    resetApp();
  }

  bool noAvailableSchedules() {
    return savedScheduleNames == null || savedScheduleNames.isEmpty;
  }

  bool disableSaveToServerButton() {
    return nameToSaveScheduleAs == null || nameToSaveScheduleAs == "" || _schedule == null;
  }

  void saveScheduleToServer() {
    _scheduleService.saveSchedule(nameToSaveScheduleAs, _schedule);
  }

  void loadScheduleFromServer() {
    Schedule scheduleFromServer = _scheduleService.retrieveSchedule(selectedServerSchedule);
    if(scheduleFromServer != null){
      _schedule = scheduleFromServer;
      resetApp();
    }
  }
}