library countdown;

import 'package:angular/angular.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'dart:core';

@NgComponent(
    selector: 'countdown',
    templateUrl: 'countdown.html',
    cssUrl: 'countdown.css',
    publishAs: 'controller',
    map: const {
      'start-time' : '=>startTime'
    })
class CountdownController {
  static const DEBUGGING = true;
  static const DEBUGGING_WARNING_SECONDS = 5;
  static const DEBUGGING_DANGER_SECONDS = 10;
  static const DEBUGGING_EXPIRED_SECONDS = 15;
  
  static final Logger log = new Logger("CountdownController");

  static final DateFormat _formatter = new DateFormat.ms();
  static final DateTime TIME_ZERO = new DateTime.fromMillisecondsSinceEpoch(0);

  static const String NORMAL_COLOR_CLASS = "normal";
  static const String WARNING_COLOR_CLASS = "warning";
  static const double WARNING_PERCENTAGE = 0.7;
  static const String DANGER_COLOR_CLASS = "danger";

  Scope _scope;
  String colorClass;

  Stopwatch _stopWatch = new Stopwatch();
  Duration _levelDuration;
  Duration _timeRemaining;

  CountdownController(Scope this._scope) {
    new Timer.periodic(new Duration(seconds:1), _updateTimeRemaining);

    _scope.$on("toggleTimer", toggleTimer);
    _scope.$on("resetTimer", resetTimer);
  }

  set startTime (int time) {
    initiliazeCountdown(time);
  }

  void initiliazeCountdown(int startTime) {
    _levelDuration = new Duration(minutes:startTime);
    _timeRemaining = new Duration(seconds:_levelDuration.inSeconds);
    colorClass = NORMAL_COLOR_CLASS;
  }

  String get timeRemainingText => _formatter.format(TIME_ZERO.add(_timeRemaining));

  void toggleTimer() {
    _stopWatch.isRunning ? _stopWatch.stop() : _stopWatch.start();
    _scope.$emit("timerToggled", new List<bool>()..add(_stopWatch.isRunning));
  }

  void resetTimer() {
    if(_stopWatch.isRunning) toggleTimer();
    _stopWatch.reset();
    initiliazeCountdown(_levelDuration.inMinutes);
    _scope.$emit("timerReset");
  }

  void _updateTimeRemaining([Timer timer = null]) {
    if (_stopWatch.isRunning) {
      bool isTimeExpired = _timeRemaining.inSeconds <= 0;
      bool isExpiredForDebugging = DEBUGGING && _stopWatch.elapsed.inSeconds >= DEBUGGING_EXPIRED_SECONDS;

      if (isTimeExpired || isExpiredForDebugging) {
        countdownComplete();
      } else {
        _timeRemaining = _levelDuration - _stopWatch.elapsed;
        _updateColorClass();
      }
    }
  }

  void _updateColorClass() {
    int warningMinutes = (_levelDuration.inMinutes * WARNING_PERCENTAGE).round();
    int warningDebugMinutes = (_levelDuration.inMinutes * .1).round();
    bool isDangerForDebugging = DEBUGGING && _stopWatch.elapsed.inSeconds >= DEBUGGING_DANGER_SECONDS;
    bool isWarningForDebugging = DEBUGGING && _stopWatch.elapsed.inSeconds >= DEBUGGING_WARNING_SECONDS;

    if (_timeRemaining.inMinutes <= 0 || isDangerForDebugging) {
      colorClass = DANGER_COLOR_CLASS;
    } else if (_timeRemaining.inMinutes <= warningMinutes || isWarningForDebugging) {
      colorClass = WARNING_COLOR_CLASS;
    } else {
      colorClass = NORMAL_COLOR_CLASS;
    }
  }

  void countdownComplete() {
    _stopWatch.stop();
    _scope.$emit("countdownComplete");
  }
}
