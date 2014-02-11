import 'package:di/di.dart';
import 'package:angular/angular.dart';
import 'package:logging/logging.dart';
import 'package:logging_handlers/logging_handlers_shared.dart';
import 'package:pokertimer/blinds/blind.dart';
import 'package:pokertimer/blinds/blindComponent.dart';
import 'package:pokertimer/chip/chip.dart';
import 'package:pokertimer/chip/chipComponent.dart';
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
    type(ChipController);
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

  int levelLength = 20;
  bool isSuddenDeath = false;
  Schedule schedule;
  
  List<Chip> chips = new List<Chip>()
      ..add(new Chip(value: 5, color: "Red"))
      ..add(new Chip(value: 25, color: "Green"))
      ..add(new Chip(value: 100, color: "Black"));

  
  PokerController(Scope this._scope) {
    List<Blind> blinds = new List<Blind>()
        ..add(new Blind.blindsOnly(25, 50))
        ..add(new Blind.anteOnly(100))
        ..add(new Blind(75, 150, 50))
        ..add(new Blind.blindsOnly(100, 200))
        ..add(new Blind.blindsOnly(200, 400))
        ..add(new Blind.blindsOnly(500, 1000))
        ..add(new Blind.blindsOnly(1000, 2000));
    
    schedule = new Schedule(blinds);
    schedule.currentBlindNumber = 0;
    
    if(DEBUGGING) {
      blinds.removeRange(3, blinds.length);
    }
  }

  String get controlText => isRunning ? "Pause" : "Play";
  Blind get currentBlind => schedule.currentBlind;
  Blind get nextBlind => schedule.nextBlind;
  int get currentLevel => schedule.currentBlindNumber;

  void toggleTimer() {
    isRunning = !isRunning;
  }

  void startNextLevel() {
    schedule.currentBlindNumber++;
    _scope.$broadcast("restartCountdown");
  }

  bool get isLastLevel => schedule.currentBlindNumber == (schedule.blinds.length - 1);
  

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
    return schedule.currentBlindNumber + 1 < schedule.blinds.length;
  }
  
  void resetApp() {
    isRunning = false;
    schedule.reset();
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
    schedule = new Schedule.fromJson(result);
    resetApp();
  }
}
