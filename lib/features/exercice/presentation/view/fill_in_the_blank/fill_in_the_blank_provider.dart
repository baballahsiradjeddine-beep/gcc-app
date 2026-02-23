import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/providers/data/models/fill_in_the_blank_exercise.dart';

import '../../state/exercice_controller.dart';
import 'fill_in_the_blank_state.dart';

class FillInTheBlankNotifier extends StateNotifier<FillInTheBlankState> {
  FillInTheBlankNotifier(this.ref, FillInTheBlankExercise exercise)
      : super(FillInTheBlankState(
          exercise: exercise,
          filledBlanks: List.filled(exercise.blanks.length, null),
          wordSelectionState: List.filled(exercise.suggestions.length, false),
        ));

  final Ref ref;
  void selectWord(int wordIndex) {
    final currentFilledBlanks = List<String?>.from(state.filledBlanks);
    final currentWordSelectionState = List<bool>.from(state.wordSelectionState);

    final blankIndex = state.getFirstUnfilledBlankIndex();

    if (blankIndex != -1 && !state.isWordSelected(wordIndex)) {
      //todo FITB
      currentFilledBlanks[blankIndex] =
          state.exercise.suggestions[wordIndex];
      currentWordSelectionState[wordIndex] = true;
      state = state.copyWith(
        filledBlanks: currentFilledBlanks,
        wordSelectionState: currentWordSelectionState,
        // isChecked: false,
      );
    }
  }

  void unselectWord(int blankIndex) {
    final currentFilledBlanks = List<String?>.from(state.filledBlanks);
    final currentWordSelectionState = List<bool>.from(state.wordSelectionState);

    if (currentFilledBlanks[blankIndex] != null) {
      //todo FITB
      final wordIndex = state.exercise.suggestions
          .map((e) => e)
          .toList()
          .indexOf(currentFilledBlanks[blankIndex]!);
      currentWordSelectionState[wordIndex] = false;
      currentFilledBlanks[blankIndex] = null;

      state = state.copyWith(
        filledBlanks: currentFilledBlanks,
        wordSelectionState: currentWordSelectionState,
        // isChecked: false,
      );
    }
  }

  //* can use ref.listen in view to listen to the state changes
  void checkAnswer(BuildContext context) {
    // final isCorrect = state.exercise.checkAnswer(state.filledBlanks);
    final isCorrect = state.checkAnswer();
    state = state.copyWith(
      isChecked: true,
      isCorrect: isCorrect,
    );

    ref.read(exercicesProvider.notifier).checkAnswer(
          context,
          state.isCorrect,
          // onSuccess: () {
          //   AppLogger.logInfo('Correct Answer');
          // },
          // onError: () {
          //   AppLogger.logInfo('Wrong Answer');
          // },
        );
  }

  void reset() {
    state = FillInTheBlankState(
      exercise: state.exercise,
      filledBlanks: List.filled(state.exercise.blanks.length, null),
      wordSelectionState: List.filled(state.exercise.suggestions.length, false),
    );
  }
}

// final fillInTheBlankProvider = StateNotifierProvider.autoDispose<
//     FillInTheBlankNotifier, FillInTheBlankState>(
//   (ref) {
//     final exercise =
//         ref.watch(exercicesProvider.select((value) => value.currentExercise))
//             as FillInTheBlankExercise;
//     return FillInTheBlankNotifier(ref, exercise);
//   },
// );

// use family
final fillInTheBlankProvider = StateNotifierProvider.family.autoDispose<
    FillInTheBlankNotifier, FillInTheBlankState, FillInTheBlankExercise>(
  (ref, exercise) {
    return FillInTheBlankNotifier(ref, exercise);
  },
);
