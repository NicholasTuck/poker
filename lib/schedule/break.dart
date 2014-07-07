library breaks;

class Break{
  int afterLevelNumber;
  int length;
  
  Break(this.afterLevelNumber, this.length);

  Break.fromMap(Map breakMap) {
    afterLevelNumber = breakMap['afterLevelNumber'];
    length = breakMap['length'];
  }

  Map toMap(){
      return {'afterLevelNumber':afterLevelNumber, 'length':length};
  }
}