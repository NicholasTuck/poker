library BlindTest;

import "package:unittest/unittest.dart";
import "package:pokertimer/schedule/blinds/blind.dart";

main() {
  test("Blinds Only Constructor should have ante of 0", () {
    Blind blind = new Blind.blindsOnly(5, 6);
    expect(blind.ante, equals(0));
  });
  
  test("Ante Only Constructor should have blinds of 0", () {
    Blind blind = new Blind.anteOnly(5);
    expect(blind.smallBlind, equals(0));
    expect(blind.bigBlind, equals(0));
  });

  test("Full constructor should set all values correctly", () {
    Blind blind = new Blind(3, 6, 1);
    expect(blind.smallBlind, equals(3));
    expect(blind.bigBlind, equals(6));
    expect(blind.ante, equals(1));
  });
}