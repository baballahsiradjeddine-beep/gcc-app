import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tayssir/features/exercice/presentation/state/exercice_controller.dart';
import 'package:tayssir/features/exercice/presentation/view/question_widget.dart';
import 'package:tayssir/resources/colors/app_colors.dart';
import 'package:tayssir/resources/resources.dart';
import 'package:tayssir/services/actions/dialog_service.dart';

// a widget that wrap child by directionality and watch the current direction from exercise
class DirectionalityWrapper extends ConsumerWidget {
  const DirectionalityWrapper({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Directionality(
      textDirection:
          ref.watch(exercicesProvider).currentExercise.currentDirection,
      child: child,
    );
  }
}

class QuestionTypeWidget extends ConsumerWidget {
  const QuestionTypeWidget({
    super.key,
    required this.question,
  });

  final String question;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(
            SVGs.titoBoarding,
            height: 45.h,
            width: 45.w,
          ),
          5.horizontalSpace,
          Text(
            question,
            style: const TextStyle(
              color: AppColors.darkColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          if (ref.watch(exercicesProvider).currentExercise.shouldShowHint)
            QuestionWidget(onTap: () {
              DialogService.showHintDialog(
                  context,
                  ref.watch(exercicesProvider).currentExercise.hints,
                  ref.watch(exercicesProvider).currentExercise.hintImage);
            }),
        ],
      ),
    );
  }
}
