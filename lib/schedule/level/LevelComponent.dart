library pokertimer.schedule.level.levelComponent;

import 'package:angular/angular.dart';
import 'package:logging/logging.dart';
import 'package:pokertimer/schedule/blinds/blind.dart';


@Component(
    selector: 'level',
    templateUrl: 'packages/pokertimer/schedule/level/levelComponent.html',
    cssUrl: 'packages/pokertimer/schedule/level/levelComponent.css',
    publishAs: 'cmp')
class LevelComponent {

  @NgOneWay('is-current-level') bool isCurrentLevel;
  @NgOneWay('identifier') String identifier;
  @NgOneWay('blind') Blind blind;
  @NgCallback('on-countdown-complete')Function countdownCompleteCallback;
  @NgOneWay('start-time')int startTime;
  @NgOneWay('is-sudden-death')bool isSuddenDeath;
  @NgTwoWay('is-running')bool isRunning;
  @NgOneWay('on-break')bool onBreak;


  LevelComponent() {

  }


}
