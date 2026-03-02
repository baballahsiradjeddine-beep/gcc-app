import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/app_buttons/big_button.dart';
import 'package:tayssir/common/custom_cached_image.dart';
import 'package:tayssir/features/exercice/presentation/state/exercice_controller.dart';
import 'package:tayssir/features/exercice/presentation/view/question_type_widget.dart';
import 'package:tayssir/features/exercice/presentation/view/select_right_option/use_remark_dialog.dart';
import 'package:tayssir/providers/data/models/latex_field.dart';
import 'package:tayssir/resources/colors/app_colors.dart';
import 'question_section.dart';

class ExerciseTemplate extends HookConsumerWidget {
  const ExerciseTemplate({
    super.key,
    required this.choices,
    required this.questionType,
    this.questionWidget,
    this.remark,
    this.buttonText = "تحقق من الإجابة",
    this.onButtonPressed,
    this.imageUrl,
    this.useSpacerAfterQuestion = true,
    this.useSpacerBeforeButton = true,
    this.remarkImage,
  });

  final List<Widget> choices;
  final String questionType;
  final Widget? questionWidget;
  final String buttonText;
  final VoidCallback? onButtonPressed;
  final bool useSpacerAfterQuestion;
  final bool useSpacerBeforeButton;
  final List<LatexField<String>>? remark;
  final String? imageUrl;
  final String? remarkImage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shouldDelay = ref.watch(exercicesProvider).currentExerciceIndex == 0;
    useRemarkDialog(context, remark, remarkImage, shouldDelay: shouldDelay);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Header (Tito + Question Type)
          QuestionTypeWidget(question: questionType)
              .animate().fadeIn().slideX(begin: -0.1, end: 0),
          
          24.verticalSpace,
          
          // Main Question Card
          if (questionWidget != null)
            QuestionSection(
              question: Column(
                children: [
                  questionWidget!,
                  if (imageUrl != null) ...[
                    16.verticalSpace,
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20.r),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: CustomCachedImage(
                          imageUrl: imageUrl!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ).animate().fadeIn(delay: 200.ms).scale(curve: Curves.easeOutBack),
          
          if (useSpacerAfterQuestion) const Spacer(),
          if (!useSpacerAfterQuestion) 32.verticalSpace,
          
          // Answer Choices Section
          Column(children: choices).animate().fadeIn(delay: 400.ms),
          
          if (useSpacerBeforeButton) const Spacer(),
          if (!useSpacerBeforeButton) 32.verticalSpace,
          
          // Action Button (Check)
          BigButton(
            text: buttonText,
            onPressed: ref.watch(exercicesProvider).submittingStatus.isLoading
                ? null
                : onButtonPressed,
          ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2, end: 0),
          
          40.verticalSpace,
        ],
      ),
    );
  }
}
