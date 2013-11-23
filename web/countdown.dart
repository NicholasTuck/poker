import 'package:di/di.dart';
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
  static const DEBUGGING = false;
  static final Logger log = new Logger("PokerController");

  static final DateFormat _formatter = new DateFormat.ms();
  static final DateTime TIME_ZERO = new DateTime.fromMillisecondsSinceEpoch(0);
  
  static const String NORMAL_COLOR_CLASS = "normal";
  static const String WARNING_COLOR_CLASS = "warning";
  static const double WARNING_PERCENTAGE = 0.7;
  static const String DANGER_COLOR_CLASS = "danger";
  
  Scope _scope;
  String colorClass;
  
  Stopwatch _stopWatch = new Stopwatch();
  Duration _startingDuration;
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
    _startingDuration = new Duration(minutes:startTime);
    _timeRemaining = new Duration(minutes:startTime);
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
    initiliazeCountdown(_startingDuration.inMinutes);
    _scope.$emit("timerReset");
  }
  
  void _updateTimeRemaining([Timer timer = null]) {
    if (_stopWatch.isRunning) { 
      bool isTimeExpired = _timeRemaining.inSeconds <= 0;
      bool isExpiredForDebugging = DEBUGGING && _stopWatch.elapsed.inSeconds > 5; // make rounds only 5 seconds while debugging
      
      if (isTimeExpired || isExpiredForDebugging) {
        countdownComplete();
      } else {
        _timeRemaining = _startingDuration - _stopWatch.elapsed;
        _updateColorClass();
      }
    }
  }

  void _updateColorClass() {
    int warningMinutes = (_startingDuration.inMinutes * WARNING_PERCENTAGE).round();
    
    if (_timeRemaining.inMinutes <= 1) {
      colorClass = DANGER_COLOR_CLASS;
    } else if (_timeRemaining.inMinutes <= warningMinutes) {
      colorClass = (DEBUGGING ? .1 : WARNING_COLOR_CLASS);
    }
  }

  void countdownComplete() {
    toggleTimer();
    _timeRemaining = Duration.ZERO;
    _scope.$emit("countdownComplete");
  }
}
