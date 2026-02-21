import 'package:tayssir/features/tools/pomodoro/state/pomodoro_status.dart';

class PomodoroState {
  final int remainingTime;
  final PomodoroStatus status;
  final int currentCycle;
  final int totalCycles;
  final int completedSessions;
  final bool isBreak;
  final int workDuration;
  final int shortBreakDuration;
  final int longBreakDuration;
  final int cyclesBeforeLongBreak;

  PomodoroState({
    required this.remainingTime,
    required this.status,
    required this.currentCycle,
    required this.totalCycles,
    required this.completedSessions,
    required this.isBreak,
    required this.workDuration,
    required this.shortBreakDuration,
    required this.longBreakDuration,
    required this.cyclesBeforeLongBreak,
  });

  factory PomodoroState.initial() {
    return PomodoroState(
      remainingTime: 25 * 60, // 25 minutes
      status: PomodoroStatus.initial,
      currentCycle: 1,
      totalCycles: 4,
      completedSessions: 0,
      isBreak: false,
      workDuration: 25 * 60, // 25 minutes
      shortBreakDuration: 5 * 60, // 5 minutes
      longBreakDuration: 15 * 60, // 15 minutes
      cyclesBeforeLongBreak: 4,
    );
  }

  PomodoroState copyWith({
    int? remainingTime,
    PomodoroStatus? status,
    int? currentCycle,
    int? totalCycles,
    int? completedSessions,
    bool? isBreak,
    int? workDuration,
    int? shortBreakDuration,
    int? longBreakDuration,
    int? cyclesBeforeLongBreak,
  }) {
    return PomodoroState(
      remainingTime: remainingTime ?? this.remainingTime,
      status: status ?? this.status,
      currentCycle: currentCycle ?? this.currentCycle,
      totalCycles: totalCycles ?? this.totalCycles,
      completedSessions: completedSessions ?? this.completedSessions,
      isBreak: isBreak ?? this.isBreak,
      workDuration: workDuration ?? this.workDuration,
      shortBreakDuration: shortBreakDuration ?? this.shortBreakDuration,
      longBreakDuration: longBreakDuration ?? this.longBreakDuration,
      cyclesBeforeLongBreak:
          cyclesBeforeLongBreak ?? this.cyclesBeforeLongBreak,
    );
  }

  double get progress {
    int totalDuration = isBreak
        ? (currentCycle % cyclesBeforeLongBreak == 0
            ? longBreakDuration
            : shortBreakDuration)
        : workDuration;
    return remainingTime / totalDuration;
  }

  bool get canReset => status != PomodoroStatus.initial;

  bool get isRunning => status == PomodoroStatus.running;

  String get currentPhaseName => isBreak
      ? (currentCycle % cyclesBeforeLongBreak == 0
          ? 'استراحة طويلة'
          : 'استراحة قصيرة')
      : 'عمل';

  int get sessionsLeft => totalCycles - completedSessions;
}
