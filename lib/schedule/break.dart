library breaks;

class Break{
  int afterLevelNumber;
  int length;
  
  Break(this.afterLevelNumber, this.length);

  Map toMap(){
      return {'afterLevelNumber':afterLevelNumber, 'length':length};
  }
}