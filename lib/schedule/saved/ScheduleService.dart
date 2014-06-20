library scheduleService;

import 'dart:async';
import 'dart:html';
import 'package:firebase/firebase.dart';

class ScheduleService {

  final String _firebaseUrl = 'https://blindsupervision.firebaseio.com';
  List<String> savedSchedules = [];

  ScheduleService() {

  }

  Future authenticateFirebase(Firebase firebase) {
    return firebase.auth('');
  }

  List<String> savedScheduleNames() {
    Firebase savedSchedulesReference = new Firebase("$_firebaseUrl/savedSchedules");
    authenticateFirebase(savedSchedulesReference).then((_) => findSavedScheduleNames(savedSchedulesReference));

    return savedSchedules;
  }

  void findSavedScheduleNames(Firebase f){

    f.onValue.listen((Event e) {
      for(var savedSchedule in e.snapshot.val()){
        savedSchedules.add(savedSchedule['name']);
      }
    });
  }

  void testChild(Firebase f) {

    var setChild = f.child('savedSchedules').set([{'name':'Halloween'},{'name':'Birthday'}]);
    setChild.then((result) {
      print('set savedSchedules');
    });
  }
}
