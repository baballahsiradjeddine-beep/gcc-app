import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/features/exercice/presentation/state/exercice_controller.dart';
import 'package:tayssir/providers/data/models/anomaly_word_exercise.dart';
import 'anomally_word_state.dart';

// final anomallyWordNotifierProvider =
//     StateNotifierProvider.autoDispose<AnomallyWordNotifier, AnomallyWordState>(
//         (ref) {

//     final currentExercice =
//       ref.watch(exercicesProvider.select((value) => value.currentExercise));
//   return AnomallyWordNotifier(ref,
//       currentExercice as AnomalyWordExercise
//   );
// });

// use the family
final anomallyWordNotifierProvider = StateNotifierProvider.family
    .autoDispose<AnomallyWordNotifier, AnomallyWordState, AnomalyWordExercise>(
  (ref, exercise) {
    return AnomallyWordNotifier(ref, exercise);
  },
);

class AnomallyWordNotifier extends StateNotifier<AnomallyWordState> {
  AnomallyWordNotifier(
    this.ref,
    this.exercise,
  ) : super(AnomallyWordState.initial());

  final Ref ref;
  final AnomalyWordExercise exercise;
  void selectAnswer(int answer) {
    if (state.isAnswerSelected(answer)) {
      state = state.copyWith(
          selectedAnswers: [...state.selectedAnswers]..remove(answer));
      return;
    }
    state = state.copyWith(selectedAnswers: [...state.selectedAnswers, answer]);
  }

  void clearSelectedAnswer() {
    state = state.clearSelectedAnswer();
  }

  bool _checkAnswer() {
    return exercise.checkAnswer(state.selectedAnswers);
  }

  void submitAnswer(BuildContext context) {
    final isCorrect = _checkAnswer();
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
