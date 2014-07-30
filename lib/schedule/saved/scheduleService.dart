library scheduleService;

import 'dart:async';
import 'package:firebase/firebase.dart' ;
import 'package:pokertimer/schedule/schedule.dart';
import 'package:di/annotations.dart';
import 'package:logging/logging.dart';

@Injectable()
class ScheduleService {

  static final Logger log = new Logger("ScheduleService");

  final String _firebaseUrl = 'https://blindsupervision.firebaseio.com';
  List<String> savedScheduleNames = [];
  Schedule newSchedule;

  ScheduleService() {

  }

  Future authenticateFirebase(Firebase firebase) {
    return firebase.auth('Hd8qtu2V439X1CflnWxUso0zyziwB5NxeD9XFkkJ');
  }

  List<String> retrieveSavedScheduleNames() {
    Firebase savedSchedulesReference = new Firebase("$_firebaseUrl/savedSchedules");
    authenticateFirebase(savedSchedulesReference).then((_) => findSavedScheduleNames(savedSchedulesReference));

    return savedScheduleNames;
  }

  void findSavedScheduleNames(Firebase firebase){

    firebase.onValue.forEach((Event event) {

      savedScheduleNames.clear();

      event.snapshot.val().forEach((key, value) {
        savedScheduleNames.add(key);
      });
    });
  }

  void saveSchedule(String scheduleName, Schedule schedule){
    Firebase savedSchedulesReference = new Firebase("$_firebaseUrl/savedSchedules");
    authenticateFirebase(savedSchedulesReference);

    Map scheduleMap = schedule.toMap();
    log.fine("Adding [${scheduleName}]");

    savedSchedulesReference.update({scheduleName: schedule.toMap()});
  }

  Schedule retrieveSchedule(String scheduleName) {
    Firebase savedSchedulesReference = new Firebase("$_firebaseUrl/savedSchedules");
    authenticateFirebase(savedSchedulesReference);

    var child = savedSchedulesReference.child(scheduleName);

    log.fine("Retrieving [${child.name()}] from ${savedSchedulesReference.name()}");

    child.onValue.forEach((Event event) {
      var scheduleMap = event.snapshot.val();
      newSchedule = new Schedule.fromMap(scheduleMap);
    });

    return newSchedule;
  }
}
