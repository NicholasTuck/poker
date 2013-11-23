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
  
  static final NumberFormat _formatter = new NumberFormat("00", "en_US");
  static final Logger log = new Logger("PokerController");
  
  static const String NORMAL_COLOR_CLASS = "normal";
  static const String WARNING_COLOR_CLASS = "warning";
  static const double WARNING_PERCENTAGE = .7;
  static const String DANGER_COLOR_CLASS = "danger";
  
  Scope _scope;
  String colorClass;
  
  Stopwatch _stopWatch = new Stopwatch();
  int _startTime;
  int _secondsRemaining;
  int _minutesRemaining;
  
  
  CountdownController(Scope this._scope) {
    _minutesRemaining = _startTime;
    new Timer.periodic(new Duration(seconds:1), _updateTimeRemaining);
    
    _scope.$on("toggleTimer", toggleTimer);
    _scope.$on("resetTimer", resetTimer);
  }
  
  set startTime (int time) {
    initiliazeCountdown(time);
  }
  
  void initiliazeCountdown(int startTime) {
    _startTime = startTime;
    _minutesRemaining = _startTime;
    _secondsRemaining = 0;
    colorClass = NORMAL_COLOR_CLASS;
  }
  
  String get timeRemaining => "${_formatter.format(_minutesRemaining)}:${_formatter.format(_secondsRemaining)}";

  void toggleTimer() {
    _stopWatch.isRunning ? _stopWatch.stop() : _stopWatch.start();
    _scope.$emit("timerToggled", new List<bool>()..add(_stopWatch.isRunning));
  }
  
  void resetTimer() {
    if(_stopWatch.isRunning) toggleTimer();
    _stopWatch.reset();
    initiliazeCountdown(_startTime);
    _scope.$emit("timerReset");
  }
  
  void _updateTimeRemaining([Timer timer = null]) {

    if (_stopWatch.isRunning) { 
      if (_stopWatch.elapsed.compareTo(new Duration(minutes: _startTime)) < 0 
          && !(DEBUGGING && _stopWatch.elapsed.compareTo(new Duration(seconds: 5)) > 0)) {    // make rounds only 5 seconds while debugging
        
        _minutesRemaining = _startTime - _stopWatch.elapsed.inMinutes  - 1;
        _secondsRemaining = 60 - _stopWatch.elapsed.inSeconds % 60 - 1;
        
        if (_stopWatch.elapsed.compareTo(new Duration(minutes:_startTime - 1)) > 0) {
          colorClass = DANGER_COLOR_CLASS;
        } else if (_stopWatch.elapsed.compareTo(new Duration(minutes: (_startTime * WARNING_PERCENTAGE).round())) > 0) {
          colorClass = (DEBUGGING ? .1 : WARNING_COLOR_CLASS);
        } 
        
      } else {
        countdownComplete();
      }
    }
  }

  void countdownComplete() {
    toggleTimer();
    _minutesRemaining = 0;
    _secondsRemaining = 0;
    _scope.$emit("countdownComplete");
  }
  
  
}