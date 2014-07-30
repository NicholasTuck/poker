library admin.AdminComponent;

import "../session/SessionModel.dart";
import "../schedule/blinds/blind.dart";
import "../schedule/break.dart";
import "../schedule/schedule.dart";
import "../schedule/ScheduleModel.dart";
import "../schedule/saved/scheduleService.dart";
import "package:logging/logging.dart";
import "package:angular/angular.dart";
import "dart:html";
import "dart:convert";

@Component(
selector: 'poker-admin',
templateUrl: 'packages/pokertimer/admin/adminComponent.html',
useShadowDom: false,
publishAs: 'cmp')
class AdminComponent {
  static final Logger log = new Logger("AdminComponent");

  static const String _DEFAULT_SCHEDULE_NAME = 'Default Schedule';


  ScheduleModel _scheduleModel;
  SessionModel _sessionModel;
  ScheduleService _scheduleService;

  String _loadedScheduleName = _DEFAULT_SCHEDULE_NAME;
  String get loadedScheduleName => _loadedScheduleName;

  String selectedServerSchedule;
  String nameToSaveScheduleAs = '';
  List<String> savedScheduleNames = [];

  bool showAdminArea = false;


  AdminComponent(ScheduleModel this._scheduleModel, SessionModel this._sessionModel, ScheduleService this._scheduleService) {
    savedScheduleNames = _scheduleService.retrieveSavedScheduleNames();
    selectedServerSchedule = noAvailableSchedules() ? "" : savedScheduleNames.first;
  }


  Schedule get _schedule => _scheduleModel.schedule;
  List<Break> get breaks => _schedule.breaks;
  List<Blind> get blinds => _schedule.blinds;

  bool get editMode => _sessionModel.editMode;

  void toggleAdminArea() { showAdminArea = !showAdminArea; }

  void onFileLoad() {

    var uploadInput = window.document.querySelector('#upload'); //todo refactor to see if we can do this angular like
    List files = uploadInput.files;
    if (files.length == 1) {
      File file = files[0];
      final reader = new FileReader();
      //todo this needs some work, firebase doesn't allow certain characters. Just stripping extension right now.
      String scheduleName = file.name.substring(0,file.name.lastIndexOf('.'));
      reader.onLoadEnd.listen((value) => parseData(reader.result, scheduleName));
      reader.readAsText(file);
    }
    uploadInput.value = null;
  }

  void parseData(String scheduleJson, String scheduleName) {
    Map scheduleMap = JSON.decode(scheduleJson);
    _scheduleModel.schedule = new Schedule.fromMap(scheduleMap);
    _loadedScheduleName = scheduleName;
  }


  bool noAvailableSchedules() {
    return savedScheduleNames == null || savedScheduleNames.isEmpty;
  }

  bool disableSaveToServerButton() {
    return nameToSaveScheduleAs == "" || nameToSaveScheduleAs == _DEFAULT_SCHEDULE_NAME;
  }

  void saveScheduleToServer(String scheduleName) {
    _scheduleService.saveSchedule(scheduleName, _schedule);
  }

  void loadScheduleFromServer() {
    Schedule scheduleFromServer = _scheduleService.retrieveSchedule(selectedServerSchedule);
    if(scheduleFromServer != null){
      _scheduleModel.schedule = scheduleFromServer;
      _loadedScheduleName = selectedServerSchedule;
    }
  }

  bool scheduleIsNotEditable() {
    return _loadedScheduleName == _DEFAULT_SCHEDULE_NAME;
  }

  void editSchedule(){
    log.fine("Editing schedule: [$_loadedScheduleName]");
    _sessionModel.editMode = true;
  }

  void cancelEdit(){
    log.fine("Edit of [$_loadedScheduleName] cancelled.");
    _sessionModel.editMode = false;
  }

  void saveSchedule(){
    if(_loadedScheduleName != _DEFAULT_SCHEDULE_NAME){
      log.fine('Saving schedule: [$_loadedScheduleName]');
      saveScheduleToServer(_loadedScheduleName);
      _sessionModel.editMode = false;

    } else {
      log.warning('Cannot overwrite $_DEFAULT_SCHEDULE_NAME');
      cancelEdit();
    }
  }

  void addBlind(int index){
    _schedule.blinds.insert(index, new Blind.blindsOnly(0,0));
  }

  void removeBlind(int index){
    _schedule.blinds.removeAt(index);
  }

  void addBreak(int index){
    _schedule.breaks.insert(index, new Break.initial());
  }

  void removeBreak(int index) {
    _schedule.breaks.removeAt(index);
  }


}
