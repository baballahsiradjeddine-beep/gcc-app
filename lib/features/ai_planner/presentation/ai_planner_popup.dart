import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tayssir/providers/data/data_provider.dart';
import '../state/ai_planner_notifier.dart';
import 'package:tayssir/services/sounds/sound_manager.dart';
import 'package:tayssir/providers/special_effect/special_effect_provider.dart';
import 'package:tayssir/resources/colors/app_colors.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:equatable/equatable.dart';
import 'package:go_router/go_router.dart';
import 'package:tayssir/router/app_router.dart';
import 'package:tayssir/features/exercice/presentation/state/exercice_controller.dart';
import '../models/learning_plan.dart';

class AIPlannerPopup extends ConsumerStatefulWidget {
  const AIPlannerPopup({super.key});

  @override
  ConsumerState<AIPlannerPopup> createState() => _AIPlannerPopupState();
}

class _AIPlannerPopupState extends ConsumerState<AIPlannerPopup> {
  final List<int> selectedSubjectIds = [];
  int selectedDuration = 10;

  @override
  Widget build(BuildContext context) {
    final modules = ref.watch(dataProvider).contentData.modules;
    final isLoading = ref.watch(aiPlannerProvider).isLoading;
    final isSoundOn = ref.watch(isSoundEnabledProvider);
    final activePlan = ref.watch(aiPlannerProvider).activePlan;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final backgroundColor = isDark ? AppColors.secondaryDark : AppColors.surfaceWhite;
    final shellColor = isDark ? const Color(0xFF1E293B) : AppColors.scaffoldColor;
    final titleTextColor = isDark ? Colors.white : AppColors.textBlack;
    final subtitleTextColor = isDark ? AppColors.disabledTextColor : AppColors.greyColor;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor.withOpacity(isDark ? 0.95 : 0.98),
            borderRadius: BorderRadius.vertical(top: Radius.circular(35.r)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 40,
                offset: const Offset(0, -10),
              ),
            ],
          ),
          constraints: BoxConstraints(maxHeight: 0.9.sh),
          child: SafeArea(
            bottom: true,
            child: Column(
              children: [
                16.verticalSpace,
                // Handle
                Container(
                  width: 45.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white12 : Colors.black.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                28.verticalSpace,
                
                // Centered Header
                Column(
                  children: [
                    Text(
                      "خطة الدراسة الذكية 🧠",
                      style: TextStyle(
                        color: titleTextColor,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'SomarSans',
                      ),
                    ),
                    8.verticalSpace,
                    Text(
                      "حدد وقتك المتاح ودع \"بيان\" يرتب أولوياتك",
                      style: TextStyle(
                        color: subtitleTextColor,
                        fontSize: 13.sp,
                        fontFamily: 'SomarSans',
                      ),
                    ),
                  ],
                ).animate().fadeIn().slideY(begin: 0.1, end: 0),
                
                24.verticalSpace,
                
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (activePlan == null) ...[
                          // Time Selection
                          _buildSectionLabel("كم عندك وقت للدراسة؟", titleTextColor),
                          16.verticalSpace,
                          Row(
                            children: [
                              _buildTimeChip(10, "10 دقايق", "⚡", isDark),
                              12.horizontalSpace,
                              _buildTimeChip(20, "20 دقيقة", "🎯", isDark),
                              12.horizontalSpace,
                              _buildTimeChip(30, "30 دقيقة", "🔥", isDark),
                            ],
                          ),
                          
                          35.verticalSpace,
                          
                          // Subject Selection
                          _buildSectionLabel("فيم تريد التركيز اليوم؟", titleTextColor),
                          16.verticalSpace,
                          
                          Wrap(
                            spacing: 12.w,
                            runSpacing: 12.h,
                            children: modules.map((module) {
                              final isSelected = selectedSubjectIds.contains(module.id);
                              final subjectColor = _hexToColor(module.gradiantColorStart);
                              return _buildSubjectChip(module, isSelected, subjectColor, isDark, shellColor);
                            }).toList(),
                          ).animate().fadeIn(delay: 300.ms),
                          
                          45.verticalSpace,
                          
                          // Action Button
                          if (!isLoading)
                          GestureDetector(
                            onTap: (selectedSubjectIds.isEmpty) ? null : () async {
                              if (isSoundOn) SoundService.playAiMagic();
                              final List<String> names = modules
                                  .where((m) => selectedSubjectIds.contains(m.id))
                                  .map((m) => m.title)
                                  .toList();
                                  
                              await ref.read(aiPlannerProvider.notifier).generatePlan(
                                subjects: selectedSubjectIds.map((e) => e.toString()).toList(),
                                subjectNames: names,
                                durationMinutes: selectedDuration,
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              height: 60.h,
                              decoration: BoxDecoration(
                                gradient: selectedSubjectIds.isEmpty 
                                    ? null 
                                    : AppColors.primaryGradient,
                                color: selectedSubjectIds.isEmpty 
                                    ? (isDark ? Colors.white10 : Colors.black.withOpacity(0.05))
                                    : null,
                                borderRadius: BorderRadius.circular(20.r),
                                boxShadow: selectedSubjectIds.isEmpty ? [] : [
                                  BoxShadow(
                                    color: AppColors.primaryColor.withOpacity(0.25),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.auto_awesome, 
                                    color: selectedSubjectIds.isEmpty ? subtitleTextColor : Colors.white,
                                    size: 20.sp,
                                  ),
                                  12.horizontalSpace,
                                  Text(
                                    "ابدأ رحلة التعلم",
                                    style: TextStyle(
                                      color: selectedSubjectIds.isEmpty ? subtitleTextColor : Colors.white,
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'SomarSans',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ).animate().scale(delay: 500.ms, curve: Curves.easeOutBack),
                          
                          if (isLoading)
                            const Center(child: CircularProgressIndicator(color: AppColors.primaryColor)),
                        ] else ...[
                          _buildPlanList(activePlan, isDark, isDark ? Colors.white12 : AppColors.borderColor),
                          24.verticalSpace,
                          _buildActionButtons(isDark),
                          50.verticalSpace,
                        ],
                      ],
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

  Widget _buildSectionLabel(String text, Color color) {
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 18.h,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        10.horizontalSpace,
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 16.sp,
            fontWeight: FontWeight.w900,
            fontFamily: 'SomarSans',
          ),
        ),
      ],
    );
  }

  Widget _buildTimeChip(int minutes, String label, String emo, bool isDark) {
    final isSelected = selectedDuration == minutes;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedDuration = minutes),
        child: AnimatedContainer(
          duration: 300.ms,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
            color: isSelected 
                ? AppColors.primaryColor.withOpacity(0.08) 
                : (isDark ? Colors.white.withOpacity(0.03) : Colors.white),
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: isSelected ? AppColors.primaryColor : (isDark ? Colors.white10 : AppColors.borderColor),
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Text(emo, style: TextStyle(fontSize: 24.sp)),
              8.verticalSpace,
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? AppColors.primaryColor : (isDark ? Colors.white38 : AppColors.greyColor),
                  fontSize: 12.sp,
                  fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
                  fontFamily: 'SomarSans',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectChip(dynamic module, bool isSelected, Color subjectColor, bool isDark, Color bgColor) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedSubjectIds.remove(module.id);
          } else {
            selectedSubjectIds.add(module.id);
          }
        });
      },
      child: AnimatedContainer(
        duration: 250.ms,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? subjectColor.withOpacity(0.12) : (isDark ? Colors.white.withOpacity(0.05) : bgColor),
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: isSelected ? subjectColor : (isDark ? Colors.white10 : AppColors.borderColor),
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_getEmojiForSubject(module.title), style: TextStyle(fontSize: 18.sp)),
            8.horizontalSpace,
            Text(
              module.title,
              style: TextStyle(
                color: isSelected ? subjectColor : (isDark ? Colors.white70 : AppColors.textBody),
                fontSize: 13.sp,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
                fontFamily: 'SomarSans',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanList(LearningPlan plan, bool isDark, Color borderColor) {
    final items = plan.items;
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final modules = ref.read(dataProvider).contentData.modules;
        final module = modules.firstWhere((m) => m.id.toString() == item.subjectId, orElse: () => modules.first);
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
              25.verticalSpace,
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: startColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      module.title,
                      style: TextStyle(color: startColor, fontSize: 12.sp, fontWeight: FontWeight.w900, fontFamily: 'SomarSans'),
                    ),
                  ),
                  10.horizontalSpace,
                  Expanded(child: Divider(color: borderColor, thickness: 1)),
                ],
              ),
              16.verticalSpace,
            ],
            GestureDetector(
              onTap: () {
                 if (item.chapterId != null) {
                     // 1. Close popup
                     Navigator.pop(context);

                     // 2. Mark that we are STARTING a planner session
                     ref.read(isPlannerSessionActiveProvider.notifier).state = true;
                     
                     // 3. Go to exercise
                     ref.read(currentChapterIdProvider.notifier).state = item.chapterId!;
                     context.pushNamed(AppRoutes.exercices.name);
                 }
              },
              child: Row(
                children: [
                  Container(
                    width: 65.sp, height: 65.sp,
                    padding: EdgeInsets.all(3.sp),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: item.isCompleted ? AppColors.greenColor : startColor.withOpacity(0.3), width: 2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32.sp),
                      child: CachedNetworkImage(
                        imageUrl: fullChapterImageUrl,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Container(
                          color: startColor.withOpacity(0.1),
                          child: Center(child: Text(_getEmojiForSubject(module.title), style: TextStyle(fontSize: 28.sp))),
                        ),
                      ),
                    ),
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [startColor, endColor]),
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [BoxShadow(color: startColor.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.title, style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.w900, fontFamily: 'SomarSans', decoration: item.isCompleted ? TextDecoration.lineThrough : null)),
                                Text(item.timeRange, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11.sp, fontFamily: 'SomarSans')),
                              ],
                            ),
                          ),
                          Icon(item.isCompleted ? Icons.check_circle_rounded : Icons.keyboard_arrow_left_rounded, color: Colors.white, size: 22.sp),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            12.verticalSpace,
          ],
        );
      },
    );
  }

  Widget _buildActionButtons(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              height: 52.h,
              decoration: BoxDecoration(color: isDark ? Colors.white12 : Colors.black.withOpacity(0.05), borderRadius: BorderRadius.circular(15.r)),
              child: Center(child: Text("إغفاء", style: TextStyle(color: isDark ? Colors.white70 : AppColors.textBody, fontWeight: FontWeight.bold, fontSize: 15.sp, fontFamily: 'SomarSans'))),
            ),
          ),
        ),
        12.horizontalSpace,
        Expanded(
          child: GestureDetector(
            onTap: () => ref.read(aiPlannerProvider.notifier).resetPlan(),
            child: Container(
              height: 52.h,
              decoration: BoxDecoration(color: AppColors.redColor.withOpacity(0.1), borderRadius: BorderRadius.circular(15.r), border: Border.all(color: AppColors.redColor.withOpacity(0.5))),
              child: Center(child: Text("إلغاء الخطة", style: TextStyle(color: AppColors.redColor, fontWeight: FontWeight.bold, fontSize: 15.sp, fontFamily: 'SomarSans'))),
            ),
          ),
        ),
      ],
    );
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

  Color _hexToColor(String hexCode) {
    try {
      final hex = hexCode.replaceAll('#', '').trim();
      if (hex.length == 6) return Color(int.parse('0xFF$hex'));
      if (hex.length == 8) return Color(int.parse('0x$hex'));
      return AppColors.primaryColor;
    } catch (e) {
      return AppColors.primaryColor;
    }
  }
}
