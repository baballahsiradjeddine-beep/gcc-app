import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/features/exercice/presentation/state/exercice_controller.dart';
import 'package:tayssir/features/exercice/presentation/view/question_widget.dart';
import 'package:tayssir/services/actions/dialog_service.dart';

class QuestionTypeWidget extends ConsumerWidget {
  const QuestionTypeWidget({
    super.key,
    required this.question,
  });

  final String question;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final exercisesState = ref.watch(exercicesProvider);
    final currentExerciseIndex = exercisesState.currentExerciceIndex + 1;
    final exercise = exercisesState.currentExercise;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Title Section (Question Index + Title)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text("✨", style: TextStyle(fontSize: 14)),
                  4.horizontalSpace,
                  Text(
                    "سؤال $currentExerciseIndex",
                    style: TextStyle(
                      color: const Color(0xFF00B4D8),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SomarSans',
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              4.verticalSpace,
              Text(
                question,
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'SomarSans',
                ),
              ),
            ],
          ),
        ),
        
        // Character Icon (Dolphin with Glow)
        Row(
          children: [
            if (exercise.shouldShowHint)
              Padding(
                padding: EdgeInsets.only(left: 12.w),
                child: QuestionWidget(onTap: () {
                  DialogService.showHintDialog(
                    context,
                    exercise.hints,
                    exercise.hintImage,
                  );
                }),
              ),
            Container(
              padding: EdgeInsets.only(bottom: 2.h),
              child: const Text("🐬", style: TextStyle(fontSize: 40)),
            ),
          ],
        ),
      ],
    );
  }
}
