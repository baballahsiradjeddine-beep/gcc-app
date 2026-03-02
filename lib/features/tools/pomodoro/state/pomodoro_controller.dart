import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/features/tools/pomodoro/state/pomodoro_state.dart';
import 'package:tayssir/features/tools/pomodoro/state/pomodoro_status.dart';
import 'dart:async';

final pomodoroControllerProvider =
    StateNotifierProvider<PomodoroController, PomodoroState>((ref) {
  return PomodoroController();
});

class PomodoroController extends StateNotifier<PomodoroState> {
  Timer? _timer;

  PomodoroController() : super(PomodoroState.initial());

  void start() {
    if (state.status == PomodoroStatus.running) return;
    if (state.status == PomodoroStatus.stopped) {
      reset();
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      tick();
    });

    state = state.copyWith(status: PomodoroStatus.running);
  }

  void stop() {
    _timer?.cancel();
    state = state.copyWith(status: PomodoroStatus.stopped);
  }

  void pause() {
    _timer?.cancel();
    state = state.copyWith(status: PomodoroStatus.paused);
  }

  void reset() {
    _timer?.cancel();
    state = PomodoroState.initial();
  }

  void tick() {
    if (state.remainingTime <= 0) {
      _handlePhaseCompletion();
    } else {
      if (state.status == PomodoroStatus.running) {
        state = state.copyWith(remainingTime: state.remainingTime - 1);
      }
    }
  }

  void _handlePhaseCompletion() {
    // Play notification sound or vibrate here maybe

    if (state.isBreak) {
      int nextCycle = state.currentCycle;
      int completedSessions = state.completedSessions;

      if (state.currentCycle < state.totalCycles) {
        nextCycle = state.currentCycle + 1;
      } else {
        nextCycle = 1;
        completedSessions = state.completedSessions + 1;
      }

      state = state.copyWith(
        isBreak: false,
        currentCycle: nextCycle,
        completedSessions: completedSessions,
        remainingTime: state.workDuration,
        status: PomodoroStatus.paused,
      );
    } else {
      bool isLongBreak = state.currentCycle % state.cyclesBeforeLongBreak == 0;
      int breakDuration =
          isLongBreak ? state.longBreakDuration : state.shortBreakDuration;

      state = state.copyWith(
        isBreak: true,
        remainingTime: breakDuration,
        status: PomodoroStatus.paused, // Optionally auto-pause between phases
      );
    }
  }

  void skipToNextPhase() {
    state = state.copyWith(remainingTime: 0);
    _handlePhaseCompletion();
  }

  void updateSettings({
    int? workDuration,
    int? shortBreakDuration,
    int? longBreakDuration,
    int? totalCycles,
    int? cyclesBeforeLongBreak,
  }) {
    state = state.copyWith(
      workDuration: workDuration,
      shortBreakDuration: shortBreakDuration,
      longBreakDuration: longBreakDuration,
      totalCycles: totalCycles,
      cyclesBeforeLongBreak: cyclesBeforeLongBreak,
    );
  }

  void addTime(int seconds) {
    state = state.copyWith(remainingTime: state.remainingTime + seconds);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
