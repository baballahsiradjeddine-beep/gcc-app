import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/debug/app_logger.dart';
import 'package:tayssir/features/exercice/presentation/state/exercice_controller.dart';
import 'package:tayssir/providers/data/models/pair_two_words_exercise.dart';
import 'pair_two_words_state.dart';

enum PairTwoWordsStatus { done, selected, correct, wrong, unselected }

class PairTwoWordsNotifier extends StateNotifier<PairTwoWordsState> {
  final PairTwoWordsExercise exercise;
  final Ref ref;

  PairTwoWordsNotifier(this.ref, this.exercise)
      : super(const PairTwoWordsState());

  void disableClick() {
    if (state.canClick) {
      state = state.disableClick();
    }
  }

  void enableClick() {
    if (!state.canClick) {
      state = state.enableClick();
    }
  }

  void setFirstColumnWord(int index) {
    if (!state.isFirstSelectable(index)) {
      return;
    };
    if (!state.canClick) return;

    state = state.setFirstColumnWord(index);

    if (state.canCheck) {
      checkPair(state.selectedFirstIndex!, state.selectedSecondIndex!);
    }
  }

  void setSecondColumnWord(int index) {
    if (!state.isSecondSelectable(index)) return;
    if (!state.canClick) return;

    state = state.setSecondColumnWord(index);

    if (state.canCheck) {
      checkPair(state.selectedFirstIndex!, state.selectedSecondIndex!);
    }
  }

  bool isAllWordsDone() {
    return state.doneFirstIndices.length == exercise.correctAnswers.length;
  }

  void checkPair(int firstIndex, int secondIndex) async {
    bool isCorrect = exercise.correctAnswers.any((pair) =>
        exercise.firstPairs.indexOf(pair.first) == firstIndex &&
        exercise.secondPairs.indexOf(pair.second) == secondIndex);

    disableClick();

    if (isCorrect) {
      state = state.copyWith(
        correctFirstIndices: {...state.correctFirstIndices, firstIndex},
        correctSecondIndices: {...state.correctSecondIndices, secondIndex},
      );

      await Future.delayed(const Duration(seconds: 1));

      state = state.copyWith(
        doneFirstIndices: {...state.doneFirstIndices, firstIndex},
        doneSecondIndices: {...state.doneSecondIndices, secondIndex},
      );

      if (isAllWordsDone()) {
        state = state.copyWith(isCompleted: true);
      }
    } else {
      state = state.copyWith(
        wrongFirstIndices: {...state.wrongFirstIndices, firstIndex},
        wrongSecondIndices: {...state.wrongSecondIndices, secondIndex},
      );

      await Future.delayed(const Duration(seconds: 1));

      state = state.incrementWrongAnswersCount();
      state = state.clearWrong();
    }

    state = state.clearSelected();
    enableClick();
  }

  void submitAnswer(BuildContext context) {
    final isCorrect = state.wrongAnswersCount < 2;

    AppLogger.logInfo(
      'PairTwoWordsNotifier.submitAnswer: wrongCount: ${state.wrongAnswersCount}',
    );

    ref.read(exercicesProvider.notifier).checkAnswer(
          context,
          isCorrect,
        );
  }
}

final pairTwoWordsProvider = StateNotifierProvider.family
    .autoDispose<PairTwoWordsNotifier, PairTwoWordsState, PairTwoWordsExercise>(
  (ref, exercise) {
    return PairTwoWordsNotifier(ref, exercise);
  },
);
