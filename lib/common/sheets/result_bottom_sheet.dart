import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/features/auth/presentation/login/custom_text_form_field.dart';
import 'package:tayssir/features/exercice/presentation/state/exercice_controller.dart';
import 'package:tayssir/features/exercice/presentation/view/select_right_option/latext_text_widget.dart';
import 'package:tayssir/resources/colors/app_colors.dart';

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
    final hasVideo = ref.watch(exercicesProvider).currentExercise.explanationVideo != null;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color primaryColor = isCorrect ? const Color(0xFF10B981) : const Color(0xFFF43F5E);
    final Color secondaryColor = isCorrect ? const Color(0xFF059669) : const Color(0xFFE11D48);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.r),
          topRight: Radius.circular(40.r),
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.4),
            blurRadius: 30,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.r),
          topRight: Radius.circular(40.r),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 40.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header Row
                Row(
                  children: [
                    // Icon Wrapper
                    Container(
                      width: 50.sp,
                      height: 50.sp,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF334155) : AppColors.surfaceWhite,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        isCorrect ? Icons.check_circle_rounded : Icons.close_rounded,
                        color: primaryColor,
                        size: 32.sp,
                      ),
                    ),
                    16.horizontalSpace,
                    // Title
                    Expanded(
                      child: Text(
                        isCorrect ? 'صحيح ! أحسنت' : 'أوبس! إجابة غير دقيقة',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'SomarSans',
                        ),
                      ),
                    ),
                    // Action Buttons (Report, Video)
                    Row(
                      children: [
                        if (hasVideo)
                          IconButton(
                            onPressed: () {
                              context.pop();
                              ref.read(exercicesProvider.notifier).showVideo();
                            },
                            icon: const Icon(Icons.play_circle_fill, color: Colors.white, size: 30),
                          ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const ReportExoDialog(),
                            );
                          },
                          icon: const Icon(Icons.report_problem_rounded, color: Colors.white, size: 28),
                        ),
                      ],
                    ),
                  ],
                ),
                
                if (message != null) ...[
                  24.verticalSpace,
                  // Correct Answer Block
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.info_outline, color: Colors.white70, size: 16),
                            8.horizontalSpace,
                            Text(
                              "الإجابة الصحيحة",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SomarSans',
                              ),
                            ),
                          ],
                        ),
                        8.verticalSpace,
                        LatextTextWidget(
                          text: message!,
                          isLatex: isLatex,
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'SomarSans',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
                32.verticalSpace,
                
                // Next Button
                SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton(
                    onPressed: onNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF1E293B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      elevation: 8,
                      shadowColor: Colors.black.withOpacity(0.2),
                    ),
                    child: Text(
                      'التالي',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'SomarSans',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        padding: EdgeInsets.all(24.r),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: const Color(0xFFF43F5E).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.report_gmailerrorred_rounded,
                size: 48,
                color: Color(0xFFF43F5E),
              ),
            ),
            16.verticalSpace,
            Center(
              child: Text(
                'الإبلاغ عن التمرين',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'SomarSans',
                  color: isDark ? Colors.white : AppColors.textBlack,
                ),
              ),
            ),
            8.verticalSpace,
            Center(
              child: Text(
                'يرجى وصف المشكلة في هذا التمرين',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isDark ? Colors.white70 : Colors.black54,
                  fontFamily: 'SomarSans',
                ),
              ),
            ),
            24.verticalSpace,
            CustomTextFormField(
              controller: messageController,
              hintText: 'اكتب هنا...',
              labelText: 'المشكلة',
              isMultiLine: true,
            ),
            24.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => context.pop(),
                    child: Text(
                      'إلغاء',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                16.horizontalSpace,
                Expanded(
                  child: SizedBox(
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: () {
                        if (messageController.text.trim().isNotEmpty) {
                          context.pop();
                          ref.read(exercicesProvider.notifier).reportCurrentExercise(
                                reason: messageController.text.trim(),
                              );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF43F5E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'إبلاغ',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
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
