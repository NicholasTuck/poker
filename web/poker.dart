import 'dart:html';
import 'package:di/di.dart';
import 'package:angular/angular.dart';

import 'package:web_ui/web_ui.dart';



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


  Stopwatch stopwatch;
  @observable  String timeElapsed = '00:00';
  PokerController(){
    stopwatch = new Stopwatch();

      runInterval();

  }

  void runInterval(){

    stopwatch.start();
    while (stopwatch.elapsedMilliseconds < 2000);
    stopwatch.stop();
    timeElapsed = stopwatch.elapsedMilliseconds.toString();


  }

}


