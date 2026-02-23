import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/app_buttons/big_button.dart';
import 'package:tayssir/common/custom_cached_image.dart';
import 'package:tayssir/constants/app_consts.dart';
import 'package:tayssir/features/exercice/presentation/state/exercice_controller.dart';
import 'package:tayssir/features/exercice/presentation/view/fill_in_the_blank/exercise_view_scaffold.dart';
import 'package:tayssir/features/exercice/presentation/view/question_type_widget.dart';
import 'package:tayssir/features/exercice/presentation/view/select_right_option/use_remark_dialog.dart';
import 'package:tayssir/providers/data/models/latex_field.dart';
import 'package:tayssir/utils/extensions/context.dart';

import '../../../../../constants/strings.dart';
import 'question_section.dart';

class ExerciseTemplate extends HookConsumerWidget {
  const ExerciseTemplate({
    super.key,
    required this.choices,
    required this.questionType,
    this.questionWidget,
    this.remark,
    this.buttonText = AppStrings.check,
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
    // should delay if this is the first exercice
    final shouldDelay = ref.watch(exercicesProvider).currentExerciceIndex == 0;
    Widget getSpacing() {
      if (useSpacerAfterQuestion) {
        return const Spacer();
      } else {
        return 20.verticalSpace;
      }
    }

    useRemarkDialog(context, remark, remarkImage, shouldDelay: shouldDelay);
    final imageSize = context.isSmallDevice
        ? 180.h
        : context.isMediumDevice
            ? 200.h
            : 600.h;
    return ExerciseViewScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          QuestionTypeWidget(question: questionType),
          30.verticalSpace,
          if (questionWidget != null) ...[
            QuestionSection(question: questionWidget!),
            imageUrl != null
                ? Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.r),
                        child: CustomCachedImage(
                          imageUrl: imageUrl!,
                          width: double.infinity,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  )
                : getSpacing(),
            if (imageUrl != null) const Spacer()
          ],
          ...choices,
          if ((useSpacerBeforeButton && !useSpacerAfterQuestion) ||
              (questionWidget == null && useSpacerBeforeButton))
            const Spacer(),
          if (AppConsts.isDebug)
            // button to insepct the state
            TextButton(
              onPressed: () {
                inspect(ref.watch(exercicesProvider));
              },
              child: const Text('Inspect State'),
            ),
          30.verticalSpace,
          BigButton(
            text: buttonText,
            onPressed: ref.watch(exercicesProvider).submittingStatus.isLoading
                ? null
                : onButtonPressed,
          ),
          5.verticalSpace
        ],
      ),
    );
  }
}
