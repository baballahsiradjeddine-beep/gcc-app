import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/providers/data/models/anomaly_word_exercise.dart';
import 'package:tayssir/providers/data/models/exercise_model.dart';
import 'package:tayssir/features/exercice/presentation/view/anomally_word/anomally_word_exercice_view.dart';
import 'package:tayssir/features/exercice/presentation/view/fill_in_the_blank/fill_in_the_blank_view.dart';
import 'package:tayssir/features/exercice/presentation/view/link_word/pair_two_words_view.dart';
import 'package:tayssir/features/exercice/presentation/view/select_right_option/select_right_option_view.dart';
import 'package:tayssir/features/exercice/presentation/view/true_false_exercise/true_false_exercise_view.dart';
import 'package:tayssir/providers/data/models/fill_in_the_blank_exercise.dart';
import 'package:tayssir/providers/data/models/pair_two_words_exercise.dart';
import 'package:tayssir/providers/data/models/select_multiple_option_exercise.dart';
import 'package:tayssir/providers/data/models/true_false_exercise.dart';

class ExerciseView extends HookConsumerWidget {
  const ExerciseView({
    super.key,
    required this.exercise,
  });

  final ExerciseModel exercise;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (exercise.type) {
      case ExerciseType.multipleChoices:
        return SelectRightOptionExerciseView(
          exercise: exercise as SelectMultipleOptionExercise,
        );
      case ExerciseType.fillInTheBlank:
        return FillInTheBlankExerciseView(
          exercise: exercise as FillInTheBlankExercise,
        );

      case ExerciseType.pairTwoWords:
        return PairTwoWordsView(
          exercise: exercise as PairTwoWordsExercise,
        );
      // // anommaly word
      case ExerciseType.anomalyWord:
        return AnomallyWordExerciceView(
          exercise: exercise as AnomalyWordExercise,
        );
      case ExerciseType.trueFalse:
        return TrueFalseExerciseView(
          exercise: exercise as TrueFalseExercise,
        );
    }
  }
}

// Temporary
