import 'package:di/di.dart';
import 'package:angular/angular.dart';
import 'package:logging/logging.dart';
import 'package:logging_handlers/logging_handlers_shared.dart';
import 'package:pokertimer/blinds/blind.dart';
import 'package:pokertimer/blinds/blindComponent.dart';
import 'package:pokertimer/countdown/countdown.dart';
import 'package:pokertimer/schedule/schedule.dart';
import 'dart:html';

void main() {
  Logger.root.level = Level.ALL;
  startQuickLogging();

  ngBootstrap(module:  new PokerModule());
}

class PokerModule extends Module {
  PokerModule() {
    type(PokerController);
    type(CountdownController);
    type(BlindController);
  }
}


@NgController(
  selector: '[poker-controller]',
  publishAs: 'controller'
)
class PokerController {
  static final Logger log = new Logger("PokerController");
  static const bool DEBUGGING = true;
  Scope _scope;

  bool isRunning = false;

  int currentLevel;
  int levelLength = 20;
  bool isSuddenDeath = false;
  List<Blind> blinds = new List<Blind>()
      ..add(new Blind.blindsOnly(25, 50))
      ..add(new Blind.anteOnly(100))
      ..add(new Blind(75, 150, 50))
      ..add(new Blind.blindsOnly(100, 200))
      ..add(new Blind.blindsOnly(200, 400))
      ..add(new Blind.blindsOnly(500, 1000))
      ..add(new Blind.blindsOnly(1000, 2000));

  PokerController(Scope this._scope) {
    currentLevel = 0;
    
    if(DEBUGGING) {
      blinds.removeRange(3, blinds.length);
    }
  }

  String get controlText => isRunning ? "Pause" : "Play";
  Blind get currentBlind => blinds[currentLevel];
  Blind get nextBlind => blinds[currentLevel + 1];

  void toggleTimer() {
    isRunning = !isRunning;
  }

  void startNextLevel() {
    currentLevel++;
    _scope.$broadcast("restartCountdown");
  }

  bool shouldStartNextlevel() {
    return currentLevel < blinds.length;
  }

  void resetLevel() {_scope.$broadcast("resetCountdown");}

  void onTimerToggled(ScopeEvent scopeEvent, bool toggledOn) {isRunning = toggledOn;}

  void onLevelComplete() {
    if (notCompleteWithAllLevels()) {
      startNextLevel();
    } else {
      startSuddenDeath();
    }
  }

  void startSuddenDeath() {
    isSuddenDeath = true;
  }

  bool notCompleteWithAllLevels() {
    return currentLevel + 1 < blinds.length;
  }
  
  void resetApp() {
    isRunning = false;
    currentLevel = 0;
    isSuddenDeath = false;
    resetLevel();
  }
  
  
  
  void toggleAdminArea() {
    var adminArea = window.document.querySelector('#adminArea');
    adminArea.hidden = !adminArea.hidden;
  }

  void onFileLoad() {

    var uploadInput = window.document.querySelector('#upload'); //todo refactor to see if we can do this angular like
    List files = uploadInput.files;
    if (files.length == 1) {
      File file = files[0];
      final reader = new FileReader();
      reader.onLoadEnd.listen((value) => parseData(reader.result));
      reader.readAsText(file);
    }
    uploadInput.value = null;
  }

  void parseData(var result) {
    blinds = new Schedule.fromJson(result).levels;
    resetApp();
  }
}
