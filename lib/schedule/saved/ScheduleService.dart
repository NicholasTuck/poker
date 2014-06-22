library scheduleService;

import 'dart:async';
import 'dart:html' hide Event;
import 'dart:convert';
import 'package:firebase/firebase.dart' ;
import 'package:pokertimer/schedule/schedule.dart';

class ScheduleService {

  final String _firebaseUrl = 'https://blindsupervision.firebaseio.com';
  List<String> savedSchedules = [];

  ScheduleService() {

  }

  Future authenticateFirebase(Firebase firebase) {
    return firebase.auth('Hd8qtu2V439X1CflnWxUso0zyziwB5NxeD9XFkkJ');
  }

  List<String> savedScheduleNames() {
    Firebase savedSchedulesReference = new Firebase("$_firebaseUrl/savedSchedules");
    authenticateFirebase(savedSchedulesReference).then((_) => findSavedScheduleNames(savedSchedulesReference));

    return savedSchedules;
  }

  void findSavedScheduleNames(Firebase firebase){

    firebase.onValue.forEach((Event event) {

      savedSchedules.clear();

      event.snapshot.val().forEach((key, value) {
        savedSchedules.add(key);
      });
    });
  }

  void saveSchedule(String scheduleName, Schedule schedule){
    Firebase savedSchedulesReference = new Firebase("$_firebaseUrl/savedSchedules");
    authenticateFirebase(savedSchedulesReference);

    Map scheduleMap = schedule.toMap();
    String jsonString = JSON.encode(scheduleMap);

    savedSchedulesReference.update({scheduleName: schedule.toMap()});
  }
}
