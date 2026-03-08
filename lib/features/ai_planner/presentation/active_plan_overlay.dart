import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tayssir/services/sounds/sound_manager.dart';
import 'package:tayssir/providers/special_effect/special_effect_provider.dart';
import 'package:tayssir/router/app_router.dart';
import 'package:tayssir/resources/colors/app_colors.dart';
import '../../exercice/presentation/state/exercice_controller.dart';
import '../state/ai_planner_notifier.dart';
import '../models/learning_plan.dart';
import 'success_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tayssir/providers/data/data_provider.dart';

class ActivePlanOverlay extends ConsumerWidget {
  const ActivePlanOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plannerState = ref.watch(aiPlannerProvider);
    final plan = plannerState.activePlan;

    if (plan == null) return const SizedBox.shrink();

    return Positioned(
      bottom: 100.h,
      left: 20.w,
      right: 20.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMinimizedPanel(context, ref, plan),
        ],
      ).animate().slideY(begin: 1.0, end: 0, curve: Curves.easeOutCubic),
    );
  }

  Widget _buildMinimizedPanel(BuildContext context, WidgetRef ref, LearningPlan plan) {
    final double progress = plan.items.where((it) => it.isCompleted).length / plan.items.length;
    final bool isFinished = plan.isFinished;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark ? AppColors.secondaryDark : AppColors.surfaceWhite;
    final titleColor = isDark ? Colors.white : AppColors.textBlack;
    final subtitleColor = isDark ? AppColors.disabledTextColor : AppColors.greyColor;
    final borderColor = isDark ? AppColors.primaryColor.withOpacity(0.3) : AppColors.borderColor;

    return GestureDetector(
      onTap: () => _showFullChecklist(context, ref, plan),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: backgroundColor.withOpacity(isDark ? 0.8 : 0.95),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(color: borderColor, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 45.sp,
                      height: 45.sp,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 4,
                        backgroundColor: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
                        valueColor: const AlwaysStoppedAnimation(AppColors.primaryColor),
                      ),
                    ),
                    Text(
                      "${(progress * 100).toInt()}%",
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                15.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isFinished ? "اكتملت الدراسة! 😍" : "خطة الدراسة الحالية ⚡",
                        style: TextStyle(
                          color: titleColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'SomarSans',
                        ),
                      ),
                      Text(
                        isFinished ? "اضغط للمشاركة الآن" : "اضغط لمتابعة مهامك",
                        style: TextStyle(
                          color: subtitleColor,
                          fontSize: 12.sp,
                          fontFamily: 'SomarSans',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isFinished ? Icons.celebration_rounded : Icons.keyboard_arrow_up_rounded,
                  color: AppColors.primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFullChecklist(BuildContext context, WidgetRef ref, LearningPlan plan) {
    final isSoundOn = ref.read(isSoundEnabledProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    if (plan.isFinished) {
      if (isSoundOn) SoundService.playAiMagic();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => SuccessCard(
          subjectName: plan.items.first.title,
          duration: plan.totalDurationMinutes >= 60 
            ? "${plan.totalDurationMinutes ~/ 60} ساعة"
            : "${plan.totalDurationMinutes} دقيقة",
          onShare: () {},
          onClose: () {
            Navigator.pop(ctx);
            ref.read(aiPlannerProvider.notifier).resetPlan();
          },
        ),
      );
      return;
    }

    final backgroundColor = isDark ? AppColors.secondaryDark : AppColors.scaffoldColor;
    final titleColor = isDark ? Colors.white : AppColors.textBlack;
    final subtitleColor = isDark ? AppColors.disabledTextColor : AppColors.greyColor;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (ctx) => Container(
        height: 0.85.sh,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(35.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.5 : 0.1),
              blurRadius: 40,
              spreadRadius: 10,
            )
          ],
        ),
        child: Column(
          children: [
            20.verticalSpace,
            Container(
              width: 50.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: isDark ? Colors.white12 : Colors.black12,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            25.verticalSpace,
            Text(
              "خطة الدراسة الذكية 🧠",
              style: TextStyle(
                color: titleColor,
                fontSize: 22.sp,
                fontWeight: FontWeight.w900,
                fontFamily: 'SomarSans',
              ),
            ),
            8.verticalSpace,
            Text(
              "اضغط على أي مهمة للذهاب إليها مباشرة",
              style: TextStyle(
                color: subtitleColor, 
                fontSize: 13.sp, 
                fontFamily: 'SomarSans',
                fontWeight: FontWeight.bold,
              ),
            ),
            20.verticalSpace,
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    _buildPlanItems(ref, plan, ctx, isSoundOn, isDark),
                    30.verticalSpace,
                    _buildActionButtons(ctx, ref, isDark),
                    30.verticalSpace,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanItems(WidgetRef ref, LearningPlan plan, BuildContext ctx, bool isSoundOn, bool isDark) {
    final items = plan.items;
    final dividerColor = isDark ? Colors.white12 : AppColors.borderColor;
    final titleColor = isDark ? Colors.white60 : AppColors.greyColor;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final modules = ref.read(dataProvider).contentData.modules;
        final module = modules.firstWhere(
          (m) => m.id.toString() == item.subjectId,
          orElse: () => modules.first,
        );
        
        final isFirstInSubject = index == 0 || items[index - 1].subjectId != item.subjectId;
        final startColor = _hexToColor(module.gradiantColorStart);
        final endColor = _hexToColor(module.gradiantColorEnd);
        
        final chapters = ref.read(dataProvider).contentData.chapters;
        final chapter = chapters.firstWhere((c) => c.id == item.chapterId, orElse: () => chapters.first);
        final chapterImage = chapter.image ?? '';
        final String fullChapterImageUrl = chapterImage.startsWith('http') 
            ? chapterImage 
            : 'https://gcc.tayssir-bac.com/storage/${chapterImage.replaceAll(RegExp(r'^/'), '')}';

        return Column(
          children: [
            if (isFirstInSubject) ...[
              15.verticalSpace,
              Row(
                children: [
                  Expanded(child: Divider(color: dividerColor, thickness: 1)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      module.title,
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'SomarSans',
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: dividerColor, thickness: 1)),
                ],
              ),
              15.verticalSpace,
            ],
            Container(
              margin: EdgeInsets.only(bottom: 12.h),
              child: GestureDetector(
                onTap: item.isCompleted ? null : () {
                  if (item.chapterId != null) {
                    // 1. Close the modal sheet first
                    Navigator.pop(context);

                    // 2. Mark session as active
                    ref.read(isPlannerSessionActiveProvider.notifier).state = true;
                    
                    if (isSoundOn) SoundService.playClickPremium();
                    HapticFeedback.lightImpact();
                    ref.read(currentChapterIdProvider.notifier).state = item.chapterId!;
                    context.pushNamed(AppRoutes.exercices.name);
                  }
                },
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    children: [
                      Container(
                        width: 72.sp,
                        height: 72.sp,
                        padding: EdgeInsets.all(4.sp),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: item.isCompleted ? AppColors.greenColor : (isDark ? Colors.white24 : Colors.black.withOpacity(0.08)), 
                            width: item.isCompleted ? 3.5 : 2
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(36),
                          child: CachedNetworkImage(
                            imageUrl: fullChapterImageUrl,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Container(
                              color: startColor.withOpacity(0.2),
                              child: Center(
                                child: Text(
                                  _getEmojiForSubject(module.title),
                                  style: TextStyle(fontSize: 35.sp),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      12.horizontalSpace,
                      Expanded(
                        child: Container(
                          constraints: BoxConstraints(minHeight: 60.h),
                          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [startColor, endColor],
                              begin: Alignment.centerRight,
                              end: Alignment.centerLeft,
                            ),
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow: [
                              BoxShadow(
                                color: startColor.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      item.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w900,
                                        fontFamily: 'SomarSans',
                                        decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                                      ),
                                    ),
                                    Text(
                                      item.timeRange,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.9),
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'SomarSans',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                item.isCompleted ? Icons.check_circle_rounded : Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 24.sp,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionButtons(BuildContext ctx, WidgetRef ref, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: BigButton(
            text: "إغفاء",
            isDark: isDark,
            onPressed: () => Navigator.pop(ctx),
          ),
        ),
        12.horizontalSpace,
        Expanded(
          child: BigButton(
            text: "إلغاء الخطة",
            isDanger: true,
            isDark: isDark,
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(aiPlannerProvider.notifier).resetPlan();
            },
          ),
        ),
      ],
    );
  }

  Color _hexToColor(String colorStr) {
    try {
      String s = colorStr.replaceAll('#', '');
      if (s.length == 6) s = 'FF$s';
      return Color(int.parse(s, radix: 16));
    } catch (e) {
      return AppColors.primaryColor;
    }
  }

  String _getEmojiForSubject(String title) {
    title = title.toLowerCase();
    if (title.contains('رياضيات')) return '📐';
    if (title.contains('فلسفة')) return '📜';
    if (title.contains('علوم')) return '🧪';
    if (title.contains('فيزياء')) return '⚡';
    if (title.contains('تاريخ')) return '🌍';
    if (title.contains('إسلامية')) return '🕌';
    if (title.contains('عربية')) return '📖';
    return '📚';
  }
}

class BigButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isDanger;
  final bool isDark;
  const BigButton({super.key, required this.text, required this.onPressed, this.isDanger = false, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 56.h,
        decoration: BoxDecoration(
          color: isDanger 
              ? AppColors.redColor.withOpacity(0.12) 
              : (isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.05)),
          borderRadius: BorderRadius.circular(18.r),
          border: isDanger ? Border.all(color: AppColors.redColor.withOpacity(0.5)) : null,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isDanger ? AppColors.redColor : (isDark ? Colors.white : AppColors.textBlack),
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'SomarSans',
            ),
          ),
        ),
      ),
    );
  }
}
