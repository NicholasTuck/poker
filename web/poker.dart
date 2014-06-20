import 'package:di/di.dart';
import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';
import 'package:logging/logging.dart';
import 'package:logging_handlers/logging_handlers_shared.dart';
import 'package:pokertimer/blinds/blindComponent.dart';
import 'package:pokertimer/chip/chipComponent.dart';
import 'package:pokertimer/countdown/countdown.dart';
import 'package:pokertimer/schedule/saved/scheduleService.dart';
import 'dart:html';

import 'PokerController.dart';

void main() {
  Logger.root.level = Level.ALL;
  applicationFactory()
    .addModule(new PokerModule())
    .run();
  startQuickLogging();

}

class PokerModule extends Module {
  PokerModule() {
    type(PokerController);
    type(CountdownController);
    type(BlindController);
    type(ChipController);
    type(ScheduleService);
  }
}


