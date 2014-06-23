library blind;

class Blind {
  int smallBlind;
  int bigBlind;
  int ante;
  
  Blind.blindsOnly(this.smallBlind, this.bigBlind): ante = 0;

  Blind.anteOnly(this.ante): smallBlind = 0, bigBlind = 0;

  Blind(this.smallBlind, this.bigBlind, this.ante);

  Map toMap(){
    return {'small-blind':smallBlind, 'big-blind':bigBlind, 'ante':ante};
  }
}
