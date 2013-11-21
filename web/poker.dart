import 'dart:html';
import 'package:di/di.dart';
import 'package:angular/angular.dart';
import 'dart:async';

void main() {
  var module = new Module()
  ..type(PokerController);

  ngBootstrap(module:module);

  new PokerController();
}


@NgController(
  selector: '[poker-controller]',
  publishAs: 'controller'
)
class PokerController {
  static const int NUMBER_OF_MINUTES = 1;  //TODO change back to 15
  
  Stopwatch _timeElapsed = new Stopwatch();
  int secondsRemaining = 00;
  int minutesRemaining = NUMBER_OF_MINUTES;
  
  PokerController() {
    _timeElapsed.start();
    
    
    new Timer.periodic(new Duration(seconds:1), _updateTimeRemaining);
    
  }
  
  void _updateTimeRemaining(Timer timer) {
    minutesRemaining = NUMBER_OF_MINUTES - _timeElapsed.elapsed.inMinutes - 1;
    secondsRemaining = 60 - _timeElapsed.elapsed.inSeconds % 60;

    if (_timeElapsed.elapsed.compareTo(new Duration(minutes: NUMBER_OF_MINUTES)) >= 0) {
      _timeElapsed.stop();
      _timeElapsed.reset();
      minutesRemaining = 0;
      secondsRemaining = 0;
    }
  }
  
}


