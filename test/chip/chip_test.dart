import "package:unittest/unittest.dart";
import "package:pokertimer/chip/chip.dart";

main() {  
  test("Chip object should be able to be constructed", () {
    Chip chip = new Chip(value: 5, color: "Red");
    expect(chip.value, equals(5));
    expect(chip.color, equals("Red"));
    expect(chip.image, isNull);
  });
  
}