import 'package:tayssir/constants/strings.dart';
import 'package:tayssir/features/tools/pomodoro/state/pomodoro_status.dart';
import 'package:tayssir/resources/resources.dart';

extension PomodorStatusX on PomodoroStatus {
  String get buttonText // in arabic
  {
    switch (this) {
      case PomodoroStatus.initial:
        return 'بدء';
      case PomodoroStatus.running:
        return 'إيقاف';
      case PomodoroStatus.paused:
        return 'استئناف';
      case PomodoroStatus.stopped:
        return 'إعادة';
    }
  }

  String get statusSvg {
    switch (this) {
      case PomodoroStatus.initial:
        return SVGs.titoPomodoroFirst;
      case PomodoroStatus.running:
        return SVGs.titoPomodoroFirst;
      case PomodoroStatus.paused:
        return SVGs.titoPomodoroStop;
      case PomodoroStatus.stopped:
        return SVGs.titoPomodoroStop;
    }
  }

  String get statusAssetKey {
    switch (this) {
      case PomodoroStatus.initial:
        return 'tito_pomodoro_first';
      case PomodoroStatus.running:
        return 'tito_pomodoro_first';
      case PomodoroStatus.paused:
        return 'tito_pomodoro_stop';
      case PomodoroStatus.stopped:
        return 'tito_pomodoro_stop';
    }
  }

  String get adviceText {
    switch (this) {
      case PomodoroStatus.initial:
        return AppStrings.pomodoroAdvice;
      case PomodoroStatus.running:
        return AppStrings.pomodoroRunning;
      case PomodoroStatus.paused:
        return AppStrings.pomodoroPause;
      case PomodoroStatus.stopped:
        return AppStrings.pomodoroPause;
    }
  }
}
