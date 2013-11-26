import 'package:di/di.dart';
import 'package:angular/angular.dart';
import 'package:logging/logging.dart';
import 'package:logging_handlers/logging_handlers_shared.dart';
//import '../lib/blinds/blinds.dart';
//import '../lib/countdown/countdown.dart';
import 'package:pokertimer/blinds/blinds.dart';
import 'package:pokertimer/countdown/countdown.dart';

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
  List<Blind> blinds = new List<Blind>()
      ..add(new Blind.blindsOnly(25, 50))
      ..add(new Blind.blindsOnly(50, 100))
      ..add(new Blind.blindsOnly(75, 150))
      ..add(new Blind.blindsOnly(100, 200))
      ..add(new Blind.blindsOnly(200, 400))
      ..add(new Blind.blindsOnly(500, 1000))
      ..add(new Blind.blindsOnly(1000, 2000));

  PokerController(Scope this._scope) {
    _scope.$on("timerToggled", onTimerToggled);
    _scope.$on("countdownComplete", onLevelComplete);
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
  
  bool shouldStartNextlevel() {
    return currentLevel < blinds.length;
  }
  
  void resetLevel() {_scope.$broadcast("resetCountdown");}

  void onTimerToggled(ScopeEvent scopeEvent, bool toggledOn) {_isRunning = toggledOn;}

  void onLevelComplete() {
    if (notCompleteWithAllLevels()) {
      startNextLevel();
    } else {
      startSuddenDeth();
    }
  }
  
  void startSuddenDeth() {
    //TODO hide countdown
    //TODO replace with text 'Sudden Death'
  }
  
  bool notCompleteWithAllLevels() {
    return currentLevel < blinds.length;
  }
}
