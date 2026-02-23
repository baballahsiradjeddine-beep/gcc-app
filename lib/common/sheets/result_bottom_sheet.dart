import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/features/auth/presentation/login/custom_text_form_field.dart';
import 'package:tayssir/features/chapters/widgets/custom_check_mark.dart';
import 'package:tayssir/features/exercice/presentation/state/exercice_controller.dart';
import 'package:tayssir/features/exercice/presentation/view/select_right_option/latext_text_widget.dart';
import 'package:tayssir/providers/user/user_notifier.dart';
import 'package:tayssir/resources/colors/app_colors.dart';

//not the best
class ResultBottomSheet extends ConsumerWidget {
  const ResultBottomSheet({
    super.key,
    required this.isCorrect,
    required this.onNext,
    this.message,
    this.onPopScope,
    this.isLatex = false,
  });

  final bool isCorrect;
  final VoidCallback onNext;
  final String? message;
  final VoidCallback? onPopScope;
  final bool isLatex;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isShowVideo = ref.watch(exercicesProvider).isShowVideo;
    final hasVideo =
        ref.watch(exercicesProvider).currentExercise.explanationVideo != null;
    final user = ref.watch(userNotifierProvider).requireValue!;

    return AbsorbPointer(
      absorbing: isShowVideo,
      child: Container(
        padding: EdgeInsets.all(24.r),
        decoration: BoxDecoration(
          color: isShowVideo
              ? Colors.black.withValues(alpha: 0.5)
              : isCorrect
                  ? const Color(0xff12D18E)
                  : const Color(0xffF85556),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                hasVideo
                    ? GestureDetector(
                        onTap: () => {
                          context.pop(),
                          ref.read(exercicesProvider.notifier).showVideo(),
                        },
                        child: const Icon(
                          Icons.file_copy,
                          color: Colors.white,
                        ),
                      )
                    : const SizedBox.shrink(),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return const ReportExoDialog();
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.report,
                    color: Colors.white,
                  ),
                ),
                10.horizontalSpace,
                Expanded(
                  child: Text(
                    isCorrect ? 'صحيح! إختيارك جيد.' : 'خطأ! حاول مرة أخرى',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.r,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SomarSans',
                    ),
                  ),
                ),
                10.horizontalSpace,
                isCorrect
                    ? const CustomCheckMark(color: AppColors.greenColor)
                    : const CustomCheckMark(
                        color: AppColors.redColor, icon: Icons.close),
              ],
            ),
            10.verticalSpace,
            if (message != null)
              Align(
                alignment: Alignment.centerRight,
                // child: Text(
                //   message!,
                //   textAlign: TextAlign.right,
                //   style: const TextStyle(
                //     color: Colors.white,
                //     fontSize: 18,
                //     fontWeight: FontWeight.normal,
                //   ),
                // ),
                child: LatextTextWidget(
                  //TODO
                  text: message!,
                  isLatex: isLatex,
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            10.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'التالي',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.r,
                        color: isCorrect
                            ? AppColors.greenColor
                            : AppColors.redColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ReportExoDialog extends HookConsumerWidget {
  const ReportExoDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageController = useTextEditingController();

    return Card(
      elevation: 0,
      color: Colors.transparent,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.report_outlined,
                    size: 80.r,
                    color: AppColors.redColor,
                  ),
                  10.verticalSpace,
                  Text(
                    'الإبلاغ عن التمرين',
                    style: TextStyle(
                      fontSize: 20.r,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SomarSans',
                    ),
                  ),
                  10.verticalSpace,
                  Text(
                    'يرجى وصف المشكلة في هذا التمرين',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.r,
                      fontFamily: 'SomarSans',
                    ),
                  ),
                  20.verticalSpace,
                  CustomTextFormField(
                    controller: messageController,
                    hintText: 'اكتب هنا...',
                    labelText: 'المشكلة',
                    isMultiLine: true,
                  ),
                  20.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => context.pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            'إلغاء',
                            style: TextStyle(
                              fontSize: 16.r,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      10.horizontalSpace,
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (messageController.text.trim().isNotEmpty) {
                              context.pop();
                              ref
                                  .read(exercicesProvider.notifier)
                                  .reportCurrentExercise(
                                    reason: messageController.text.trim(),
                                  );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.redColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            'إبلاغ',
                            style: TextStyle(
                              fontSize: 16.r,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
