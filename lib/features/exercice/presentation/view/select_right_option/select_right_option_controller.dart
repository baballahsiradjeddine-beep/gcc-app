import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/debug/app_logger.dart';
import 'package:tayssir/features/exercice/presentation/state/exercice_controller.dart';
import 'package:tayssir/providers/data/models/select_multiple_option_exercise.dart';

import 'select_right_option_state.dart';

final selectRightOptionNotifierProvider = StateNotifierProvider.family
    .autoDispose<SelectRightOptionNotifier, SelectRightOptionState,
        SelectMultipleOptionExercise>((ref, exercise) {
  return SelectRightOptionNotifier(ref, exercise);
});

class SelectRightOptionNotifier extends StateNotifier<SelectRightOptionState> {
  SelectRightOptionNotifier(this.ref, this.exercise)
      : super(SelectRightOptionState.initial());

  final Ref ref;
  final SelectMultipleOptionExercise exercise;
  void selectAnswer(String answer) {
    if (state.selectedAnswers.contains(answer)) {
      state = state.copyWith(selectedAnswer: [
        ...state.selectedAnswers.where((element) => element != answer),
      ]);
      return;
    }
    state = state.copyWith(selectedAnswer: [
      ...state.selectedAnswers,
      answer,
    ]);
  }

  void clearSelectedAnswer() {
    state = state.clearSelectedAnswer();
  }

  void submitAnswer(BuildContext context) {
    final resultIds = state.selectedAnswers.map((e) {
      final optionsString = exercise.options.map((e) => e.text).toList();
      return optionsString.indexOf(e);
    }).toList();
    final isCorrect = exercise.checkAnswer(resultIds);
    AppLogger.logInfo('isCorrect: $isCorrect');
    ref.read(exercicesProvider.notifier).checkAnswer(
      context,
      isCorrect,
      // onSuccess: () {
      //   // clearSelectedAnswer();
      // },
      // onError: () {
      //   // clearSelectedAnswer();
      // },
    );
  }
}
