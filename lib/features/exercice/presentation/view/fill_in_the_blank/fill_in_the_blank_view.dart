import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tayssir/features/exercice/presentation/view/fill_in_the_blank/fill_in_the_blank_provider.dart';
import 'package:tayssir/providers/data/models/fill_in_the_blank_exercise.dart';
import 'package:tayssir/resources/colors/app_colors.dart';
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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    List<InlineSpan> getSentence() {
      List<InlineSpan> spans = [];
      final parts = state.exercise.sentence.split('_____');
      int blankIndex = 0;

      for (int i = 0; i < parts.length; i++) {
        spans.add(TextSpan(
          text: parts[i],
          style: TextStyle(
            color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
            fontSize: 17.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'SomarSans',
            height: 2.2, // Match HTML line-height
          ),
        ));

        if (i < state.exercise.blanks.length) {
          final currentBlankIndex = blankIndex;
          final answer = state.getBlankAnswer(currentBlankIndex);
          final isFilled = answer.isNotEmpty;

          spans.add(
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: GestureDetector(
                onTap: isFilled 
                    ? () => ref.read(fillInTheBlankProvider(exercise).notifier).unselectWord(currentBlankIndex)
                    : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 6.w),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                  constraints: BoxConstraints(minWidth: 70.w, minHeight: 36.h),
                  decoration: BoxDecoration(
                    gradient: isFilled ? AppColors.primaryGradient : null,
                    color: isFilled 
                        ? null 
                        : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
                    borderRadius: BorderRadius.circular(99.r), // Capsule shape
                    border: isFilled 
                        ? null 
                        : Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                    boxShadow: isFilled ? [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.12),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      )
                    ] : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: Text(
                    isFilled ? answer : "",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'SomarSans',
                    ),
                  ),
                ),
              ),
            ),
          );
          blankIndex++;
        }
      }
      return spans;
    }

    return ExerciseTemplate(
      questionType: 'أكمل الفراغ',
      remark: exercise.remark,
      imageUrl: exercise.image,
      remarkImage: exercise.hintImage,
      useSpacerAfterQuestion: false,
      questionWidget: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24.r),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B).withOpacity(0.5) : Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: RichText(
          textAlign: TextAlign.center,
          textDirection: exercise.currentDirection,
          text: TextSpan(children: getSentence()),
        ),
      ).animate().fadeIn(delay: 200.ms).scale(curve: Curves.easeOutBack),
      choices: [
        32.verticalSpace,
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12.w,
          runSpacing: 12.h,
          children: state.exercise.suggestions.asMap().entries.map((entry) {
            final index = entry.key;
            final word = entry.value;
            final isSelected = state.isWordSelected(index);

            return GestureDetector(
              onTap: isSelected 
                  ? null 
                  : () => ref.read(fillInTheBlankProvider(exercise).notifier).selectWord(index),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: isSelected ? 0.3 : 1.0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(99.r),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Text(
                    word,
                    style: TextStyle(
                      color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SomarSans',
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ).animate().fadeIn(delay: 400.ms),
      ],
      onButtonPressed: state.canSubmit
          ? () => ref.read(fillInTheBlankProvider(exercise).notifier).checkAnswer(context)
          : null,
      buttonText: "تحقق",
    );
  }
}
