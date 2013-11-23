import 'dart:html';
import 'package:di/di.dart';
import 'package:angular/angular.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:logging_handlers/logging_handlers_shared.dart';
import 'countdown.dart';

void main() {
  Logger.root.level = Level.ALL;
  startQuickLogging();
  
  var module = new Module()
  ..type(PokerController)
  ..type(CountdownController);

  ngBootstrap(module:module);
}


@NgController(
  selector: '[poker-controller]',
  publishAs: 'controller'
)
class PokerController {
  static final Logger log = new Logger("PokerController");
  Scope _scope;
  bool _isRunning = false;
  
  PokerController(Scope this._scope) {
    _scope.$on("timerToggled", onTimerToggled);
  }
  
  String get controlText => _isRunning ? "Pause" : "Play";
  void toggleTimer() {_scope.$broadcast("toggleTimer");}
  void resetRound() {_scope.$broadcast("resetTimer");}

  void onTimerToggled(ScopeEvent scopeEvent, bool toggledOn) {_isRunning = toggledOn;}  
}


