import 'dart:html';
import 'package:di/di.dart';
import 'package:angular/angular.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:logging_handlers/logging_handlers_shared.dart';

void main() {
  var module = new Module()
  ..type(PokerController);

  ngBootstrap(module:module);
}


@NgController(
  selector: '[poker-controller]',
  publishAs: 'controller'
)
class PokerController {
  static const int NUMBER_OF_MINUTES = 1;  //TODO change back to 15
  static final NumberFormat _formatter = new NumberFormat("00", "en_US");
  static final Logger log = new Logger("PokerController");
  
  Stopwatch _stopWatch = new Stopwatch();
  int _secondsRemaining = 00;
  int _minutesRemaining = NUMBER_OF_MINUTES;
  
  
  PokerController() {
    Logger.root.level = Level.ALL;
    startQuickLogging();
    
    _stopWatch.start();
    new Timer.periodic(new Duration(seconds:1), _updateTimeRemaining);
    
  }
  
  void _updateTimeRemaining(Timer timer) {

    if (_stopWatch.elapsed.compareTo(new Duration(minutes: NUMBER_OF_MINUTES)) < 0) {
      
      _minutesRemaining = NUMBER_OF_MINUTES - _stopWatch.elapsed.inMinutes - 1;
      _secondsRemaining = 60 - _stopWatch.elapsed.inSeconds % 60;
      
      log.finest(_stopWatch.elapsed.inSeconds.toString());
    } else {
      
      _stopWatch.stop();
      _minutesRemaining = 0;
      _secondsRemaining = 0;
      
    }
  }
  
  void toggleTimer() {
    _stopWatch.isRunning ? _stopWatch.stop() : _stopWatch.start();
  }
  
  String get timeRemaining => "${_formatter.format(_minutesRemaining)}:${_formatter.format(_secondsRemaining)}";
  String get controlText => _stopWatch.isRunning ? "Pause" : "Play";
  
}


