import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/common/push_buttons/pushable_button.dart';
import 'package:tayssir/constants/strings.dart';
import 'package:tayssir/features/exercice/presentation/view/question_content_widget.dart';
import 'package:tayssir/providers/data/models/true_false_exercise.dart';
import 'package:tayssir/features/exercice/presentation/view/true_false_exercise/true_false_exercise_controller.dart';
import 'package:tayssir/resources/colors/app_colors.dart';

import '../fill_in_the_blank/exercise_template.dart';

class TrueFalseExerciseView extends ConsumerWidget {
  const TrueFalseExerciseView({
    super.key,
    required this.exercise,
  });

  final TrueFalseExercise exercise;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(trueFalseNotifierProvider(exercise));

    void setSelection(bool value) {
      ref
          .read(trueFalseNotifierProvider(exercise).notifier)
          .selectAnswer(value);
    }

    return ExerciseTemplate(
      questionType: AppStrings.trueOrFalse,
      questionWidget: QuestionContentWidget(question: exercise.question),
      remark: exercise.remark,
      imageUrl: exercise.image,
      remarkImage: exercise.hintImage,

      choices: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: PushableButton(
                  height: 40.h,
                  elevation: 3,
                  hslColor: HSLColor.fromColor(Colors.white),
                  borderColor: state.isTruePicked ? AppColors.greenColor : null,
                  hasBorder: true,
                  hslDisabledColor: HSLColor.fromColor(const Color(0xffEEEEEE)),
                  onPressed: () {
                    setSelection(true);
                  },
                  borderRadius: 10,
                  child: Text(
                    'صحيح',
                    style: TextStyle(
                      color: state.isTruePicked
                          ? AppColors.greenColor
                          : Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ),
            20.horizontalSpace,
            Expanded(
              child: PushableButton(
                  height: 40.h,
                  elevation: 3,
                  hasBorder: true,
                  hslColor: HSLColor.fromColor(Colors.white),
                  borderColor: state.isFalsePicked ? AppColors.redColor : null,
                  hslDisabledColor: HSLColor.fromColor(const Color(0xffEEEEEE)),
                  onPressed: () {
                    setSelection(false);
                  },
                  borderRadius: 10,
                  child: Text(
                    'خطأ',
                    style: TextStyle(
                      color: state.isFalsePicked
                          ? AppColors.redColor
                          : Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ),
          ],
        ),
      ],
      onButtonPressed: state.canSubmit
          ? () {
              ref
                  .read(trueFalseNotifierProvider(exercise).notifier)
                  .submitAnswer(context);
            }
          : null,
      useSpacerAfterQuestion: false,
    );
  }
}
