import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/features/exercice/presentation/view/question_content_widget.dart';
import 'package:tayssir/features/exercice/presentation/view/select_right_option/latext_text_widget.dart';
import 'package:tayssir/features/exercice/presentation/view/select_right_option/select_right_option_controller.dart';
import 'package:tayssir/providers/data/models/select_multiple_option_exercise.dart';
import 'package:tayssir/resources/colors/app_colors.dart';
import '../fill_in_the_blank/exercise_template.dart';

class SelectRightOptionExerciseView extends HookConsumerWidget {
  const SelectRightOptionExerciseView({
    super.key,
    required this.exercise,
  });

  final SelectMultipleOptionExercise exercise;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(selectRightOptionNotifierProvider(exercise));
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    void onSelectionChange(String option) {
      ref
          .read(selectRightOptionNotifierProvider(exercise).notifier)
          .selectAnswer(option);
    }

    return ExerciseTemplate(
      questionType: 'اختر الإجابة الصحيحة',
      remark: exercise.remark,
      imageUrl: exercise.image,
      remarkImage: exercise.hintImage,
      questionWidget: QuestionContentWidget(question: exercise.question),
      choices: exercise.options.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;
        final isSelected = state.selectedAnswers.contains(option.text);

        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: GestureDetector(
            onTap: () => onSelectionChange(option.text),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: isDark 
                          ? [const Color(0xFF0C4A6E).withOpacity(0.4), const Color(0xFF1E293B)] 
                          : [const Color(0xFFF0F9FF), Colors.white],
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                      )
                    : null,
                color: isSelected ? null : (isDark ? const Color(0xFF1E293B) : Colors.white),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryColor
                      : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primaryColor.withOpacity(0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: LatextTextWidget(
                      text: option.cleanText,
                      isLatex: option.isLatex,
                      onLatexTap: (text) => onSelectionChange(option.text),
                      textAlign: TextAlign.right,
                      textStyle: TextStyle(
                        color: isSelected
                            ? (isDark ? AppColors.primaryColor : const Color(0xFF0077B6))
                            : (isDark ? Colors.blueGrey.shade200 : const Color(0xFF334155)),
                        fontSize: 16.sp,
                        fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
                        fontFamily: 'SomarSans',
                      ),
                    ),
                  ),
                  12.horizontalSpace,
                  // Custom Choice Indicator (Radio like circle)
                  Container(
                    width: 20.sp,
                    height: 20.sp,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? AppColors.primaryColor : (isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1)),
                        width: 2,
                      ),
                      color: isSelected ? AppColors.primaryColor : Colors.transparent,
                    ),
                    child: isSelected
                        ? Center(
                            child: Container(
                              width: 8.sp,
                              height: 8.sp,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ).animate(target: isSelected ? 1 : 0).scale(begin: const Offset(1, 1), end: const Offset(1.02, 1.02), duration: 200.ms),
        ).animate().fadeIn(delay: (300 + index * 100).ms).slideX(begin: 0.1, end: 0);
      }).toList(),
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
