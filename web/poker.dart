import 'package:di/di.dart';
import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';
import 'package:logging/logging.dart';
import 'package:pokertimer/schedule/blinds/blindComponent.dart';
import 'package:pokertimer/chip/chipComponent.dart';
import 'package:pokertimer/countdown/countdown.dart';
import 'package:pokertimer/schedule/saved/scheduleService.dart';
import 'package:pokertimer/schedule/ScheduleModel.dart';
import 'package:pokertimer/schedule/level/LevelComponent.dart';
import 'package:pokertimer/admin/AdminComponent.dart';
import 'package:pokertimer/session/SessionModel.dart';
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
    bind(PokerController);
    bind(CountdownController);
    bind(BlindController);
    bind(ChipController);
    bind(ScheduleService);
    bind(LevelComponent);
    bind(AdminComponent);
    bind(SessionModel);

    bind(ScheduleModel);
  }
}


