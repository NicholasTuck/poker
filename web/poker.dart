import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';
import 'package:angular/animate/module.dart';

import 'package:logging/logging.dart';
import 'package:pokertimer/schedule/blinds/blindComponent.dart';
import 'package:pokertimer/chip/chipComponent.dart';
import 'package:pokertimer/countdown/countdown.dart';
import 'package:pokertimer/schedule/saved/scheduleService.dart';
import 'package:pokertimer/schedule/ScheduleModel.dart';
import 'package:pokertimer/schedule/level/LevelComponent.dart';
import 'package:pokertimer/admin/AdminComponent.dart';
import 'package:pokertimer/session/SessionModel.dart';
import 'package:pokertimer/schedule/break/NextBreakComponent.dart';
import 'pokerController.dart';

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord record) => print(record.message));

  applicationFactory()
    .addModule(new PokerModule())
    .run();
}

class PokerModule extends Module {
  PokerModule() {
    install(new AnimationModule());
    bind(PokerController);
    bind(CountdownController);
    bind(BlindController);
    bind(ChipComponent);
    bind(ScheduleService);
    bind(LevelComponent);
    bind(AdminComponent);
    bind(SessionModel);
    bind(NextBreakComponent);
    bind(ScheduleModel);
  }
}


