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
  static const String DANGER_COLOR_CLASS = "danger";
  static const double WARNING_PERCENTAGE = 0.7;
  static const double DANGER_PERCENTAGE = 0.9;

  Scope _scope;
  Stopwatch _stopWatch = new Stopwatch();
  Duration _startingDuration;
  Duration _timeRemaining;
  
  String colorClass;

  CountdownController(Scope this._scope) {
    new Timer.periodic(new Duration(seconds:1), _updateTimeRemaining);

    _scope.$on("startTimer", startTimer);
    _scope.$on("stopTimer", stopTimer);
    _scope.$on("toggleTimer", toggleTimer);
    _scope.$on("resetCountdown", resetCountdown);
    _scope.$on("restartCountdown", restartCountdown);
  }

  set startTime (int time) {
    initiliazeCountdown(time);
  }

  void initiliazeCountdown(int startTime) {
    _startingDuration = new Duration(minutes:startTime);
    _timeRemaining = new Duration(seconds:_startingDuration.inSeconds);
    colorClass = NORMAL_COLOR_CLASS;
  }

  String get timeRemainingText => _formatter.format(TIME_ZERO.add(_timeRemaining));

  void toggleTimer() {
    _stopWatch.isRunning ? _stopWatch.stop() : _stopWatch.start();
    _scope.$emit("timerToggled", new List<bool>()..add(_stopWatch.isRunning));
    log.fine("Timer toggled - isRunning is now ${_stopWatch.isRunning}");
  }
  
  void stopTimer() {
    if(_stopWatch.isRunning) toggleTimer();
  }
  
  void startTimer() {
    if(!_stopWatch.isRunning) toggleTimer();
  }

  void resetCountdown() { 
    _stopWatch.reset();
    initiliazeCountdown(_startingDuration.inMinutes);
    _scope.$emit("countdownReset");
    log.fine("Countdown reset");
  }
  
  void restartCountdown() {
    _stopWatch.reset();
    initiliazeCountdown(_startingDuration.inMinutes);
    startTimer();
    _scope.$emit("countdownRestarted");
    log.fine("Countdown restarted");
  }

  void _updateTimeRemaining([Timer timer = null]) {
    if (_stopWatch.isRunning) {
      bool isTimeExpired = _timeRemaining.inSeconds <= 0;
      bool isExpiredForDebugging = DEBUGGING && _stopWatch.elapsed.inSeconds >= DEBUGGING_EXPIRED_SECONDS;

      if (isTimeExpired || isExpiredForDebugging) {
        _countdownComplete();
      } else {
        _timeRemaining = _startingDuration - _stopWatch.elapsed;
        _updateColorClass();
      }
    }
  }

  void _updateColorClass() {
    int dangerMinutes = (_startingDuration.inMinutes * DANGER_PERCENTAGE).round();
    int warningMinutes = (_startingDuration.inMinutes * WARNING_PERCENTAGE).round();
    bool isDangerForDebugging = DEBUGGING && _stopWatch.elapsed.inSeconds >= DEBUGGING_DANGER_SECONDS;
    bool isWarningForDebugging = DEBUGGING && _stopWatch.elapsed.inSeconds >= DEBUGGING_WARNING_SECONDS;

    if (_timeRemaining.inMinutes <= dangerMinutes || isDangerForDebugging) {
      colorClass = DANGER_COLOR_CLASS;
    } else if (_timeRemaining.inMinutes <= warningMinutes || isWarningForDebugging) {
      colorClass = WARNING_COLOR_CLASS;
    } else {
      colorClass = NORMAL_COLOR_CLASS;
    }
  }

  void _countdownComplete() {
    log.fine("Countdown complete");
    _stopWatch.reset();
    _timeRemaining = Duration.ZERO;
    _scope.$emit("countdownComplete");
  }
}
