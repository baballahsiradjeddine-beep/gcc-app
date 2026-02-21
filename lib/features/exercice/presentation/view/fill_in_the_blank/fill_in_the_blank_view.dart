import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/features/exercice/presentation/view/fill_in_the_blank/fill_in_the_blank_provider.dart';
import 'package:tayssir/providers/data/models/fill_in_the_blank_exercise.dart';

import '../../../../../resources/colors/app_colors.dart';
import 'exercise_template.dart';

class FillInTheBlankExerciseView extends ConsumerWidget {
  const FillInTheBlankExerciseView({
    super.key,
    required this.exercise,
  });

  final FillInTheBlankExercise exercise;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(fillInTheBlankProvider(exercise));

    // final wordPainter = Paint()
    //   ..color = Colors.black
    //   ..style = PaintingStyle.stroke
    //   ..strokeCap = StrokeCap.round
    //   ..strokeJoin = StrokeJoin.round
    //   ..strokeWidth = 1.0;
    getSentence() {
      List<InlineSpan> sentenceWidgets = [];
      final sentenceParts =
          //todo FITB
          state.exercise.sentence.split('_____').map((e) => e.trim()).toList();
      // AppLogger.logInfo(sentenceParts);
      int blankIndex = 0;

      for (int i = 0; i < sentenceParts.length; i++) {
        sentenceWidgets.add(TextSpan(
            text: sentenceParts[i],
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.sp,
            )));
        if (i < state.exercise.blanks.length) {
          final currentBlankIndex = blankIndex;
          // space before
          sentenceWidgets.add(
            TextSpan(
              text: ' ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.sp,
              ),
            ),
          );
          sentenceWidgets.add(
            TextSpan(
              text: state.getBlankAnswer(currentBlankIndex),
              style: TextStyle(
                color: state.isChecked
                    ? (state.isCorrectWord(currentBlankIndex)
                        ? Colors.green
                        : Colors.red)
                    : Colors.black38,
                fontSize: 16.sp,
                height: 1.2,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => ref
                    .read(fillInTheBlankProvider(exercise).notifier)
                    .unselectWord(currentBlankIndex),
            ),

            // WidgetSpan(
            //   alignment: PlaceholderAlignment.baseline,
            //   baseline: TextBaseline.alphabetic,
            //   child: GestureDetector(
            //     onTap: () => ref
            //         .read(fillInTheBlankProvider(exercise).notifier)
            //         .unselectWord(currentBlankIndex),
            //     child: Container(
            //       margin:
            //           const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            //       padding:
            //           const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            //       decoration: BoxDecoration(
            //         border: state.isAnswered(blankIndex)
            //             ? Border.all(color: Colors.grey)
            //             : null,
            //         borderRadius: BorderRadius.circular(14),
            //         color: state.isChecked
            //             ? (state.isCorrectWord(currentBlankIndex)
            //                 ? Colors.green
            //                 : Colors.red)
            //             : Colors.white,
            //       ),
            //       child: Text(
            //         (state.getBlankAnswer(currentBlankIndex) +
            //             currentBlankIndex.toString()),
            //         style: TextStyle(
            //           fontSize: 20.sp,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          );
          sentenceWidgets.add(
            TextSpan(
              text: ' ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.sp,
              ),
            ),
          );

          blankIndex++;
        }
      }

      return sentenceWidgets;
    }

    return ExerciseTemplate(
      questionType: 'اكمل الفراغات',
      remark: exercise.remark,
      imageUrl: exercise.image,
      remarkImage: exercise.hintImage,
      questionWidget: RichText(
        softWrap: true,
        // strutStyle: StrutStyle(fontSize: 20.sp),
        textHeightBehavior: const TextHeightBehavior(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: false,
        ),
        textDirection: exercise.currentDirection,
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: getSentence(),
        ),
      ),
      choices: [
        Wrap(
          spacing: 16,
          runSpacing: 10,
          children: state.exercise.suggestions.asMap().entries.map((entry) {
            final index = entry.key;
            final word = entry.value;
            final fontSize =
                state.exercise.suggestions.length > 5 ? 12.sp : 16.sp;
            if (state.isWordSelected(index)) {
              return Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: AppColors.greyColor,
                ),
                //todo FITB
                child: Text(word,
                    style: TextStyle(
                      color: Colors.transparent,
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    )),
              );
            }
            return GestureDetector(
              onTap: () => ref
                  .read(fillInTheBlankProvider(exercise).notifier)
                  .selectWord(index),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderColor),
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.white,
                ),
                //todo FITB
                child: Text(word,
                    style: TextStyle(
                      color: const Color(0xff3c3c3c),
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            );
          }).toList(),
        ),
      ],
      onButtonPressed: state.canSubmit
          ? () => ref
              .read(fillInTheBlankProvider(exercise).notifier)
              .checkAnswer(context)
          : null,
    );
  }
}
