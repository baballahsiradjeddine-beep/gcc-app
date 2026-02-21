import 'package:tayssir/environment_config.dart';
import 'package:tayssir/resources/resources.dart';

extension Strings on String {
  String get capitalize => "${this[0].toUpperCase()}${substring(1)}";

// remove the first spaces and the last spaces in sentence
  String removeSpaces() {
    return trim();
  }

  String get toModuleName => "مادة $this";

  // convert #33affff to  0xff33affff
  int get toHexColor {
    return int.parse("0xff${substring(1)}");
  }

  // convert to base url
  String get toBaseUrl {
    return "$EnvironmentConfig$this";
  }
}

extension doubleX on double {
  String resultText() {
    if (this < 0.5) {
      return "نتيجة ضعيفة، اعد المحاولة";
    } else if (this < 0.7) {
      return "نتيجة مقبولة";
    } else if (this < 0.9) {
      return "نتيجة جيدة";
    } else {
      return "نتيجة ممتازة";
    }
  }

  String resultIcon() {
    if (this < 0.5) {
      return SVGs.titoAngry;
    } else if (this < 0.7) {
      return SVGs.titoAngry;
    } else if (this < 0.9) {
      return SVGs.titoGood;
    } else {
      return SVGs.titoPerfect;
    }
  }

  String toPercentage() {
    return "${(this * 100).toStringAsFixed(0)}%";
  }
}

extension DurationX on Duration {
  String get toTime {
    final minutes = inMinutes;
    final seconds = inSeconds.remainder(60);
    // show as this 02:06 , even minutes add 0 at the beginning
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
