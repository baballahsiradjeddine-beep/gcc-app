import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

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
        // Dolphin Tooltip (from HTML)
        24.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("🐬", style: TextStyle(fontSize: 55)),
            16.horizontalSpace,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B).withOpacity(0.8) : Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Text(
                    "قم بالتركيز\nقبل الإختيار",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SomarSans',
                    ),
                  ),
                  // Bubble Arrow
                  Positioned(
                    right: -10.w,
                    top: 15.h,
                    child: Transform.rotate(
                      angle: 0.78, // 45 degrees
                      child: Container(
                        width: 12.w,
                        height: 12.h,
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B).withOpacity(0.8) : Colors.white.withOpacity(0.8),
                          border: Border(
                            right: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9)),
                            top: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms).scale(),
          ],
        ),
        
        32.verticalSpace,
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildTrueFalseButton(
              context: context,
              text: 'صحيح',
              isSelected: state.isTruePicked,
              onTap: () => setSelection(true),
              color: const Color(0xFF10B981), // brand.green
              isDark: isDark,
              index: 0,
            ),
            16.horizontalSpace,
            _buildTrueFalseButton(
              context: context,
              text: 'خطأ',
              isSelected: state.isFalsePicked,
              onTap: () => setSelection(false),
              color: const Color(0xFFF43F5E), // brand.red
              isDark: isDark,
              index: 1,
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

  Widget _buildTrueFalseButton({
    required BuildContext context,
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
    required Color color,
    required bool isDark,
    required int index,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          height: 60.h,
          decoration: BoxDecoration(
            color: isSelected 
                ? color.withOpacity(isDark ? 0.2 : 0.1) 
                : (isDark ? const Color(0xFF1E293B) : Colors.white),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isSelected ? color : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
              width: isSelected ? 2.0 : 1.0,
            ),
            boxShadow: isSelected 
                ? [
                    BoxShadow(
                      color: color.withOpacity(0.2),
                      blurRadius: 8,
                    )
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? color : (isDark ? Colors.white70 : const Color(0xFF1E293B)),
                fontSize: 18.sp,
                fontWeight: FontWeight.w900,
                fontFamily: 'SomarSans',
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: (400 + index * 100).ms).scale(begin: isSelected ? const Offset(1, 1) : const Offset(0.95, 0.95), end: isSelected ? const Offset(1.05, 1.05) : const Offset(1, 1));
  }
}
