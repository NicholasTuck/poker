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
  static final NumberFormat _formatter = new NumberFormat("00", "en_US");
  static final Logger log = new Logger("PokerController");
  
  Stopwatch _stopWatch = new Stopwatch();
  int _startTime;
  int _secondsRemaining = 00;
  int _minutesRemaining;
  Scope _scope;
  
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
      if (_stopWatch.elapsed.compareTo(new Duration(minutes: _startTime)) < 0) {
        
        _minutesRemaining = _startTime - _stopWatch.elapsed.inMinutes - 1;
        _secondsRemaining = 60 - _stopWatch.elapsed.inSeconds % 60 - 1;
        
      } else {
        
        _stopWatch.stop();
        _minutesRemaining = 0;
        _secondsRemaining = 0;
        
      }
    }
  }
  
  
}