import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latext/latext.dart';
import 'package:tayssir/debug/app_logger.dart';
import 'package:tayssir/features/exercice/presentation/view/execise_number_widget.dart';
import 'package:tayssir/providers/data/models/latex_field.dart';
import 'package:tayssir/resources/colors/app_colors.dart';

import '../state/exercice_controller.dart';

class QuestionContentWidget extends HookConsumerWidget {
  const QuestionContentWidget({
    super.key,
    required this.question,
  });

  final LatexField question;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(
          right:
              ref.watch(exercicesProvider).currentExercise.currentDirection ==
                      TextDirection.ltr
                  ? 4.w
                  : 0,
          left: ref.watch(exercicesProvider).currentExercise.currentDirection ==
                  TextDirection.rtl
              ? 4.w
              : 0),
      child: Align(
        alignment:
            ref.watch(exercicesProvider).currentExercise.currentDirection ==
                    TextDirection.ltr
                ? Alignment.centerLeft
                : Alignment.centerRight,
        child: question.isLatex
            ? LatexContentWidget(question: question)
            : PlainTextContentWidget(question: question),
      ),
    );
  }
}

///
/// A widget that builds the LaTeX content.
/// Previously `_buildLatexContent` function.
///
class LatexContentWidget extends ConsumerStatefulWidget {
  const LatexContentWidget({
    super.key,
    required this.question,
  });

  final LatexField question;

  @override
  ConsumerState<LatexContentWidget> createState() => _LatexContentWidgetState();
}

class _LatexContentWidgetState extends ConsumerState<LatexContentWidget> {
  bool isLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ExeciseNumberWidget(),
        8.verticalSpace,
        SizedBox(
          height: 100.h,
          child: TeXView(
            // wantKeepAlive: true,
            // loadingWidgetBuilder: (context) => const Center(
            //   child: CircularProgressIndicator(),
            // ),

            // onRenderFinished: (height) {
            //   AppLogger.logInfo('TeXView rendered with height: $height');
            //   setState(() {
            //     isLoaded = true;
            //   });
            // },
            child: TeXViewDocument(
              widget.question.cleanText,
              style: const TeXViewStyle.fromCSS(
                'padding: 4px; color: black; direction: rtl;',
              ),
            ),
            style: const TeXViewStyle(
              backgroundColor: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}

///
/// A widget that builds plain text content.
/// Previously `_buildPlainTextContent` function.
///
class PlainTextContentWidget extends HookConsumerWidget {
  const PlainTextContentWidget({
    super.key,
    required this.question,
  });

  final LatexField question;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RichText(
      textDirection:
          ref.watch(exercicesProvider).currentExercise.currentDirection,
      text: TextSpan(
        children: [
          WidgetSpan(
            child: Padding(
              padding: EdgeInsets.only(
                left: 4.w,
                right: 4.w,
                bottom: 4.h,
              ),
              child: const ExeciseNumberWidget(),
            ),
            alignment: PlaceholderAlignment.middle,
          ),
          TextSpan(
            text: question.text.toString(),
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.sp,
              fontFamily: 'SomarSans',
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
