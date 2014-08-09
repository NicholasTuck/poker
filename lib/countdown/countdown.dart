library countdown;

import 'package:angular/angular.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:pokertimer/session/SessionModel.dart';

@Component(
    selector: 'countdown',
    templateUrl: 'packages/pokertimer/countdown/countdown.html',
    cssUrl: 'packages/pokertimer/countdown/countdown.css',
    publishAs: 'controller',
    map: const {
      'start-time' : '=>startTime',
      'is-running' : '<=>isRunning',
      'on-countdown-complete' : '&countdownCompleteCallback'
    })
class CountdownController {
  static const DEBUGGING = false;
  static const DEBUGGING_WARNING_SECONDS = 1;
  static const DEBUGGING_DANGER_SECONDS = 3;
  static const DEBUGGING_EXPIRED_SECONDS = 5;

  static final Logger log = new Logger("CountdownController");

  static final DateFormat _formatter = new DateFormat.ms();
  static final DateTime TIME_ZERO = new DateTime.fromMillisecondsSinceEpoch(0);

  static const String NORMAL_COLOR_CLASS = "normal";
  static const String WARNING_COLOR_CLASS = "warning";
  static const String DANGER_COLOR_CLASS = "danger";
  static const double WARNING_PERCENTAGE = 0.3;
  static const double DANGER_PERCENTAGE = 0.1;

  Scope _scope;
  SessionModel _sessionModel;
  Stopwatch _stopWatch = new Stopwatch();
  Duration _startingDuration;

  String colorClass;
  Function countdownCompleteCallback;

  CountdownController(Scope this._scope, SessionModel this._sessionModel) {
    new Timer.periodic(new Duration(seconds:1), _updateTimeRemaining);

    _scope.on("resetCountdown").listen((_) => resetCountdown());
    _scope.on("restartCountdown").listen((_) => restartCountdown());
  }

  set startTime (int time) {
    initializeCountdown(time);
  }

  Duration get _timeRemaining => _sessionModel.timeRemainingInCurrentLevel;
  set _timeRemaining(Duration duration) { _sessionModel.timeRemainingInCurrentLevel = duration; }

  void initializeCountdown(int startTime) {
    _startingDuration = new Duration(minutes:startTime);
    _timeRemaining = new Duration(seconds:_startingDuration.inSeconds);
    colorClass = NORMAL_COLOR_CLASS;
  }

  String get timeRemainingText => _formatter.format(TIME_ZERO.add(_timeRemaining));

  void stopTimer() {_stopWatch.stop();}
  void startTimer() {_stopWatch.start();}

  bool get isRunning => _stopWatch.isRunning;

  set isRunning(bool running) {
    running ? _stopWatch.start() : _stopWatch.stop();
  }

  void resetCountdown() {
    _stopWatch.reset();
    initializeCountdown(_startingDuration.inMinutes);
    stopTimer();
    _scope.emit("countdownReset");
    log.fine("Countdown reset");
  }

  void restartCountdown() {
    _stopWatch.reset();
    initializeCountdown(_startingDuration.inMinutes);
    startTimer();
    _scope.emit("countdownRestarted");
    log.fine("Countdown restarted");
  }

  void _updateTimeRemaining([Timer timer = null]) {
    if (_stopWatch.isRunning) {
      bool isTimeExpired = _timeRemaining.inSeconds <= 0;
      bool isExpiredForDebugging = DEBUGGING && _stopWatch.elapsed.inSeconds >= DEBUGGING_EXPIRED_SECONDS;

      if (isTimeExpired || isExpiredForDebugging) {
        _countdownComplete();
      } else {
        _timeRemaining = _startingDuration - _stopWatch.elapsed;
        _updateColorClass();
      }
    }
  }

  void _updateColorClass() {
    int dangerMinutes = (_startingDuration.inMinutes * DANGER_PERCENTAGE).round();
    int warningMinutes = (_startingDuration.inMinutes * WARNING_PERCENTAGE).round();
    bool isDangerForDebugging = DEBUGGING && _stopWatch.elapsed.inSeconds >= DEBUGGING_DANGER_SECONDS;
    bool isWarningForDebugging = DEBUGGING && _stopWatch.elapsed.inSeconds >= DEBUGGING_WARNING_SECONDS;

    if (_timeRemaining.inMinutes <= dangerMinutes || isDangerForDebugging) {
      colorClass = DANGER_COLOR_CLASS;
    } else if (_timeRemaining.inMinutes <= warningMinutes || isWarningForDebugging) {
      colorClass = WARNING_COLOR_CLASS;
    } else {
      colorClass = NORMAL_COLOR_CLASS;
    }
  }

  void _countdownComplete() {
    log.fine("Countdown complete");
    stopTimer();
    _timeRemaining = Duration.ZERO;
    countdownCompleteCallback();
  }
}
