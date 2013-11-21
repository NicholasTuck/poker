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
  
  Stopwatch _timeElapsed = new Stopwatch();
  int _secondsRemaining = 00;
  int _minutesRemaining = NUMBER_OF_MINUTES;
  
  PokerController() {
    Logger.root.level = Level.ALL;
    startQuickLogging();
    _timeElapsed.start();
    
    
    new Timer.periodic(new Duration(seconds:1), _updateTimeRemaining);
    
  }
  
  void _updateTimeRemaining(Timer timer) {

    if (_timeElapsed.elapsed.compareTo(new Duration(minutes: NUMBER_OF_MINUTES)) < 0) {
      
      _minutesRemaining = NUMBER_OF_MINUTES - _timeElapsed.elapsed.inMinutes - 1;
      _secondsRemaining = 60 - _timeElapsed.elapsed.inSeconds % 60;
      
      log.finest(_timeElapsed.elapsed.inSeconds.toString());
    } else {
      
      _timeElapsed.stop();
      _minutesRemaining = 0;
      _secondsRemaining = 0;
      
    }
  }
  
  String get secondsRemaining => _formatter.format(_secondsRemaining);
  String get minutesRemaining => _formatter.format(_minutesRemaining);
  
}


