import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/features/exercice/presentation/view/question_content_widget.dart';
import 'package:tayssir/features/exercice/presentation/view/select_right_option/latext_text_widget.dart';
import 'package:tayssir/features/exercice/presentation/view/select_right_option/select_right_option_controller.dart';
import 'package:tayssir/providers/data/models/select_multiple_option_exercise.dart';

import '../../../../../common/push_buttons/pushable_button.dart';
import '../../../../../resources/colors/app_colors.dart';
import '../fill_in_the_blank/exercise_template.dart';

// import 'package:flutter_math_fork/flutter_math.dart';

class SelectRightOptionExerciseView extends HookConsumerWidget {
  const SelectRightOptionExerciseView({
    super.key,
    required this.exercise,
  });

  final SelectMultipleOptionExercise exercise;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(selectRightOptionNotifierProvider(exercise));

    void onSelectionChange(String option) {
      ref
          .read(selectRightOptionNotifierProvider(exercise).notifier)
          .selectAnswer(option);
    }

    return ExerciseTemplate(
      questionType: 'اختر الاجابة الصحيحة',
      remark: exercise.remark,
      imageUrl: exercise.image,
      remarkImage: exercise.hintImage,
      questionWidget: QuestionContentWidget(question: exercise.question),
      choices: [
        ...exercise.options.map((option) {
          final isSelected = state.selectedAnswers.contains(option.text);
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: PushableButton(
                height: 40.h,
                elevation: 3,
                hslColor: HSLColor.fromColor(
                    isSelected ? AppColors.primaryColor : Colors.white),
                hslDisabledColor: HSLColor.fromColor(const Color(0xffEEEEEE)),
                onPressed: () {
                  onSelectionChange(option.text);
                },
                borderRadius: 10,
                child: SizedBox(
                  width: 0.8.sw,
                  child: LatextTextWidget(
                    text: option.cleanText,
                    isLatex: option.isLatex,
                    onLatexTap: (text) {
                      onSelectionChange(option.text);
                    },
                    textAlign: TextAlign.center,
                    textStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textBlack,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                    // color:
                    //     //TODO
                    //     isSelected
                    //         ? Colors.white.value
                    //         : AppColors.textBlack.value,
                  ),
                  // child: Text(
                  //   option.text,
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //     color: isSelected ? Colors.white : AppColors.textBlack,
                  //     fontSize: 13.sp,
                  //     fontWeight: FontWeight.w700,
                  //   ),
                  // ),
                )),
          );
        }),
      ],
      buttonText: 'تحقق',
      onButtonPressed: state.canSubmit
          ? () {
              ref
                  .read(selectRightOptionNotifierProvider(exercise).notifier)
                  .submitAnswer(context);
            }
          : null,
    );
  }
}
