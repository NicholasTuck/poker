library session.SessionModel;

import "package:angular/angular.dart";

@Injectable()
class SessionModel {

  bool editMode = false;
  Duration timeRemainingInCurrentLevel = new Duration(seconds: 0);

  SessionModel() {
  }
}
