import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tayssir/constants/strings.dart';
import 'package:tayssir/providers/data/models/pair_two_words_exercise.dart';
import '../fill_in_the_blank/exercise_template.dart';
import 'pair_two_words_provider.dart';
import 'pair_words_column.dart';

class PairTwoWordsView extends ConsumerWidget {
  const PairTwoWordsView({
    super.key,
    required this.exercise,
  });

  final PairTwoWordsExercise exercise;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pairTwoWordsProvider(exercise));
    final firstColumnWords = exercise.firstPairs;
    final secondColumnWords = exercise.secondPairs;

    return ExerciseTemplate(
      questionType: "صِل بين العبارات", // Match the HTML title
      useSpacerAfterQuestion: false,
      useSpacerBeforeButton: true,
      remark: exercise.remark,
      imageUrl: exercise.image,
      remarkImage: exercise.hintImage,
      choices: [
        16.verticalSpace,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: PairWordsColumn(
                words: firstColumnWords,
                state: state,
                isFirst: true,
                onWordPressed: (word) {
                  ref.read(pairTwoWordsProvider(exercise).notifier).setFirstColumnWord(word);
                },
              ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.1, end: 0),
            ),
            12.horizontalSpace,
            Expanded(
              child: PairWordsColumn(
                words: secondColumnWords,
                state: state,
                isFirst: false,
                onWordPressed: (word) {
                  ref.read(pairTwoWordsProvider(exercise).notifier).setSecondColumnWord(word);
                },
              ).animate().fadeIn(delay: 500.ms).slideX(begin: -0.1, end: 0),
            ),
          ],
        ),
      ],
      onButtonPressed: state.isCompleted
          ? () {
              ref.read(pairTwoWordsProvider(exercise).notifier).submitAnswer(context);
            }
          : null,
      buttonText: state.isCompleted ? "تحقق" : "تخطي", // Match HTML skip/check logic
    );
  }
}
