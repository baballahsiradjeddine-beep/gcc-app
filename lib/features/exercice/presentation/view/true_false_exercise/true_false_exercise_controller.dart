// state notifier for the true false exercise

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/features/exercice/presentation/state/exercice_controller.dart';
import 'package:tayssir/providers/data/models/true_false_exercise.dart';

import 'true_false_state.dart';

// final trueFalseNotifierProvider =
//     StateNotifierProvider.autoDispose<TrueFalseNotifier, TrueFalseState>((ref) {
//   // final currentExercice =
//   //     ref.watch(exercicesProvider.select((value) => value.currentExercise));
//   return TrueFalseNotifier(ref ,
//     currentExercice as TrueFalseExercise
//   );
// });

final trueFalseNotifierProvider = StateNotifierProvider.family
    .autoDispose<TrueFalseNotifier, TrueFalseState, TrueFalseExercise>(
        (ref, exercise) {
  return TrueFalseNotifier(ref, exercise);
});

class TrueFalseNotifier extends StateNotifier<TrueFalseState> {
  TrueFalseNotifier(this.ref, this.exercise) : super(TrueFalseState.initial());

  final Ref ref;
  final TrueFalseExercise exercise;
  void selectAnswer(bool answer) {
    state = state.copyWith(selectedAnswer: answer);
  }

  void clearSelectedAnswer() {
    state = state.clearSelectedAnswer();
  }

  bool _isCorrectAnswer() {
    return exercise.correctAnswer == state.selectedAnswer;
  }

  void submitAnswer(BuildContext context) {
    final isCorrect = _isCorrectAnswer();

    ref.read(exercicesProvider.notifier).checkAnswer(
          context,
          isCorrect,
          // onSuccess: () {
          //   clearSelectedAnswer();
          // },
          // onError: () {
          //   clearSelectedAnswer();
          // },
        );
  }
}
