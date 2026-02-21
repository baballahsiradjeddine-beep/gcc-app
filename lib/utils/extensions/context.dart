import 'package:flutter/material.dart';

extension ContextX on BuildContext {
  //TODO: NEED to optimize this even more for real sizes
  bool get isSmallDevice => MediaQuery.of(this).size.height < 800;
  bool get isMediumDevice =>
      MediaQuery.of(this).size.height >= 800 &&
      MediaQuery.of(this).size.height < 1000;
  bool get isLargeDevice => MediaQuery.of(this).size.height >= 1000;
}
