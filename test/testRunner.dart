//import "package:unittest/unittest.dart";
import 'package:unittest/vm_config.dart';
import 'blinds/blind_test.dart' as BlindTest;
import 'chip/chip_test.dart' as ChipTest;


void main() {
  useVMConfiguration();
  BlindTest.main();
  ChipTest.main();
}