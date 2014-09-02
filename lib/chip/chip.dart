library chip;

class Chip {
  int value;
  String color;
  bool hide = false;
  bool colorUp = false;
  
  Chip({this.value, this.color});

  Chip.fromMap(Map chipMap) {
    value = chipMap['value'];
    color = chipMap['color'];
  }

  Map toMap() {
    return {'value': value, 'color': color};
  }
}