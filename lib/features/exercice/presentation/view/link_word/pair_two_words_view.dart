import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      questionType: "اربط الكلمات المتشابهة",
      useSpacerAfterQuestion: false,
      useSpacerBeforeButton: false,
      remark: exercise.remark,
      imageUrl: exercise.image,
      remarkImage: exercise.hintImage,

      choices: [
        Expanded(
          child: SingleChildScrollView(
            child: Row(
              children: [
                Expanded(
                    child: PairWordsColumn(
                  words: firstColumnWords,
                  state: state,
                  isFirst: true,
                  onWordPressed: (word) {
                    ref
                        .read(pairTwoWordsProvider(exercise).notifier)
                        .setFirstColumnWord(word);
                  },
                )),
                10.horizontalSpace,
                Expanded(
                    child: PairWordsColumn(
                  words: secondColumnWords,
                  state: state,
                  isFirst: false,
                  onWordPressed: (word) {
                    ref
                        .read(pairTwoWordsProvider(exercise).notifier)
                        .setSecondColumnWord(word);
                  
                  },
                )),
              ],
            ),
          ),
        ),
      ],
      // onButtonPressed: () {
      // ref.read(pairTwoWordsProvider(exercise).notifier).submitAnswer(context);
      // },

      onButtonPressed: state.isCompleted
          ? () {
              ref
                  .read(pairTwoWordsProvider(exercise).notifier)
                  .submitAnswer(context);
            }
          : null,
      buttonText: AppStrings.continueText,
    );
  }
}



// return ExerciseViewScaffold(
    //   body: Column(
    //     children: [
    //       const QuestionTypeWidget(
    //         question: 'ربط الكلمات المتشابهة',
    //       ),
    //       10.verticalSpace,
    //       CheckButton(
    //         text: AppStrings.continueText,
    //         onPressed: state.isCompleted
    //             ? () {
    //                 ref
    //                     .read(pairTwoWordsProvider(exercise).notifier)
    //                     .submitAnswer(context);
    //               }
    //             : null,
    //       )
    //     ],
    //   ),
    // );