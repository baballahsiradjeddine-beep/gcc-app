import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tayssir/resources/resources.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      SVGs.logo,
      width: width,
      height: height,
    );
  }
}
