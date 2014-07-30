library schedule.breaks.breaks;

class Break{
  int afterLevelNumber;
  int length;
  
  Break(this.afterLevelNumber, this.length);

  Break.initial(){
    afterLevelNumber = 0;
    length = 5;
  }

  Break.fromMap(Map breakMap) {
    afterLevelNumber = breakMap['afterLevelNumber'];
    length = breakMap['length'];
  }

  Map toMap(){
      return {'afterLevelNumber':afterLevelNumber, 'length':length};
  }
}