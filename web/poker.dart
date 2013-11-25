import 'package:di/di.dart';
import 'package:angular/angular.dart';
import 'package:logging/logging.dart';
import 'package:logging_handlers/logging_handlers_shared.dart';
import 'blinds.dart';
import 'countdown.dart';

void main() {
  Logger.root.level = Level.ALL;
  startQuickLogging();

  var module = new Module()
  ..type(PokerController)
  ..type(CountdownController)
  ..type(BlindsController);

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
  
  int currentLevel = 0;

  PokerController(Scope this._scope) {
    _scope.$on("timerToggled", onTimerToggled);
    _scope.$on("countdownComplete", onCountdownComplete);
  }

  String get controlText => _isRunning ? "Pause" : "Play";

  void toggleTimer() {
    log.fine("Toggle Timer Clicked");
    _scope.$broadcast("toggleTimer");
  }

  void startNextLevel() {
    currentLevel++;
    _scope.$broadcast("restartCountdown");
  }
  
  void resetLevel() {_scope.$broadcast("resetCountdown");}

  void onTimerToggled(ScopeEvent scopeEvent, bool toggledOn) {_isRunning = toggledOn;}

  void onCountdownComplete() {
    startNextLevel();
    // TODO grab attention that level is complete
  }
}
