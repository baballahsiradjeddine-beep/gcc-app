import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tayssir/resources/resources.dart';

void main() {
  test('images assets test', () {
    expect(File(Images.failureBg).existsSync(), isTrue);
    expect(File(Images.flashCardsGBg).existsSync(), isTrue);
    expect(File(Images.flashCardsLBg).existsSync(), isTrue);
    expect(File(Images.gradeCalcGrid).existsSync(), isTrue);
    expect(File(Images.gradeCalcList).existsSync(), isTrue);
    expect(File(Images.pomodoroBg).existsSync(), isTrue);
    expect(File(Images.pomodoroBgList).existsSync(), isTrue);
    expect(File(Images.reolveGridBg).existsSync(), isTrue);
    expect(File(Images.resolveListBg).existsSync(), isTrue);
    expect(File(Images.resumesGBg).existsSync(), isTrue);
    expect(File(Images.resumsLBg).existsSync(), isTrue);
    expect(File(Images.subBg).existsSync(), isTrue);
    expect(File(Images.successBg).existsSync(), isTrue);
  });
}
