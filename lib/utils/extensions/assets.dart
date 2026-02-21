import 'package:flutter/material.dart';

extension Assets on String {
  Image image({double? width, double? height}) => Image.asset(
        "assets/images/$this.png",
        width: width,
        height: height,
      );

  AssetImage get assetImage => AssetImage(
        "assets/images/$this.png",
      );

  String get svg => "assets/svg/$this.svg";

  Image get icon => Image.asset(
        "assets/icons/$this.png",
      );

  String get audioPath => "assets/sounds/$this.mp3";
}
