import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tayssir/providers/data/data_provider.dart';
import '../state/ai_planner_notifier.dart';
import 'package:tayssir/services/sounds/sound_manager.dart';
import 'package:tayssir/providers/special_effect/special_effect_provider.dart';

class AIPlannerPopup extends StatefulHookConsumerWidget {
  const AIPlannerPopup({super.key});

  @override
  ConsumerState<AIPlannerPopup> createState() => _AIPlannerPopupState();
}

class _AIPlannerPopupState extends ConsumerState<AIPlannerPopup> {
  final List<int> selectedSubjectIds = [];
  int selectedDuration = 30; // Default 30 min

  @override
  Widget build(BuildContext context) {
    final modules = ref.watch(dataProvider).contentData.modules;
    final isLoading = ref.watch(aiPlannerProvider).isLoading;
    final isSoundOn = ref.watch(isSoundEnabledProvider);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A).withOpacity(0.85),
          borderRadius: BorderRadius.vertical(top: Radius.circular(45.r)),
          border: Border(
            top: BorderSide(
              color: Colors.white.withOpacity(0.12),
              width: 2.5,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 40,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        padding: EdgeInsets.fromLTRB(24.w, 15.h, 24.w, 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Premium Handle
            Container(
              width: 50.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            30.verticalSpace,
            
            // AI Aura Icon
            Container(
              width: 70.w,
              height: 70.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF00C6E0), Color(0xFF00B4D8)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00B4D8).withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(Icons.psychology_alt_rounded, color: Colors.white, size: 40),
            ).animate(onPlay: (c) => c.repeat(reverse: true))
             .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 2.seconds)
             .shimmer(delay: 3.seconds, duration: 2.seconds),
            
            25.verticalSpace,
            
            Text(
              "واش حاب تقرا اليوم؟ 🤔",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26.sp,
                fontWeight: FontWeight.w900,
                fontFamily: 'SomarSans',
                letterSpacing: -0.5,
              ),
            ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0),
            
            10.verticalSpace,
            
            Text(
              "حدد وقتك وخلي الباقي على بيان!",
              style: TextStyle(
                color: const Color(0xFF94A3B8),
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                fontFamily: 'SomarSans',
              ),
            ).animate().fadeIn(delay: 200.ms),
            
            35.verticalSpace,
            
            // Duration Selection (New Mode)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildModeCard(15, "١٥ دقيقة", "⚡", const Color(0xFFF59E0B)).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
                12.horizontalSpace,
                _buildModeCard(30, "٣٠ دقيقة", "🧠", const Color(0xFF00C6E0)).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2, end: 0),
                12.horizontalSpace,
                _buildModeCard(60, "ساعة واحدة", "🏆", const Color(0xFF10B981)).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2, end: 0),
              ],
            ),
            
            35.verticalSpace,
            
            // Subject Selection Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "اختر المواد الدراسية",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'SomarSans',
                  ),
                ),
                Text(
                  "${selectedSubjectIds.length} مختارة",
                  style: TextStyle(
                    color: const Color(0xFF00B4D8),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SomarSans',
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 500.ms),
            
            15.verticalSpace,
            
            SizedBox(
              height: 150.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: modules.length,
                itemBuilder: (context, index) {
                  final module = modules[index];
                  final isSelected = selectedSubjectIds.contains(module.id);
                  final color = _getSubjectColor(module.title);
                  
                  return GestureDetector(
                    onTap: () {
                      if (isSoundOn) SoundService.playClickPremium();
                      setState(() {
                        if (isSelected) {
                          selectedSubjectIds.remove(module.id);
                        } else {
                          selectedSubjectIds.add(module.id);
                        }
                      });
                    },
                    child: AnimatedContainer(
                      duration: 300.ms,
                      width: 105.w,
                      margin: EdgeInsets.only(left: 14.w),
                      decoration: BoxDecoration(
                        color: isSelected ? color.withOpacity(0.12) : Colors.white.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(
                          color: isSelected ? color : Colors.white.withOpacity(0.08),
                          width: 2,
                        ),
                        boxShadow: isSelected ? [
                          BoxShadow(color: color.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 5))
                        ] : [],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (isSelected)
                            Positioned(
                              top: 8.h,
                              right: 8.w,
                              child: Icon(Icons.check_circle, color: color, size: 18.sp),
                            ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(12.r),
                                decoration: BoxDecoration(
                                  color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  _getEmojiForSubject(module.title),
                                  style: TextStyle(fontSize: 32.sp),
                                ),
                              ),
                              8.verticalSpace,
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                                child: Text(
                                  module.title,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                                    fontSize: 12.sp,
                                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
                                    fontFamily: 'SomarSans',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: (700 + index * 100).ms).slideX(begin: 0.1, end: 0),
                  );
                },
              ),
            ).animate().fadeIn(delay: 600.ms),
            
            40.verticalSpace,
            
            // Action Button
            GestureDetector(
              onTap: (selectedSubjectIds.isEmpty || isLoading) ? null : () async {
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
                if (mounted) Navigator.pop(context);
              },
              child: AnimatedOpacity(
                duration: 300.ms,
                opacity: selectedSubjectIds.isEmpty ? 0.5 : 1.0,
                child: Container(
                  width: double.infinity,
                  height: 65.h,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00C6E0), Color(0xFF0077B6)],
                    ),
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00B4D8).withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Center(
                    child: isLoading 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "انطلق الآن! 🔥",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'SomarSans',
                                letterSpacing: 0.5,
                              ),
                            ),
                            10.horizontalSpace,
                            const Icon(Icons.rocket_launch_rounded, color: Colors.white),
                          ],
                        ),
                  ),
                ),
              ),
            ).animate().fadeIn(delay: 800.ms).scale(curve: Curves.easeOutBack),
            
            10.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildModeCard(int minutes, String label, String icon, Color color) {
    final isSelected = selectedDuration == minutes;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedDuration = minutes),
        child: AnimatedContainer(
          duration: 300.ms,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.12) : Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: isSelected ? color : Colors.white.withOpacity(0.08),
              width: 2,
            ),
            boxShadow: isSelected ? [
              BoxShadow(color: color.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 4))
            ] : [],
          ),
          child: Column(
            children: [
              Text(icon, style: TextStyle(fontSize: 26.sp)),
              8.verticalSpace,
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF94A3B8),
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

  String _getEmojiForSubject(String title) {
    title = title.toLowerCase();
    if (title.contains('رياضيات')) return '📐';
    if (title.contains('فلسفة')) return '📜';
    if (title.contains('علوم')) return '🧪';
    if (title.contains('فيزياء')) return '⚡';
    if (title.contains('تاريخ')) return '🌍';
    if (title.contains('إسلامية')) return '🕌';
    if (title.contains('عربية')) return '📖';
    if (title.contains('فرنسية')) return '🇫🇷';
    if (title.contains('إنجليزية')) return '🇬🇧';
    return '📚';
  }

  Color _getSubjectColor(String title) {
    title = title.toLowerCase();
    if (title.contains('رياضيات')) return const Color(0xFF00C6E0);
    if (title.contains('فلسفة')) return const Color(0xFFEC4899);
    if (title.contains('علوم')) return const Color(0xFF10B981);
    if (title.contains('فيزياء')) return const Color(0xFFF59E0B);
    if (title.contains('تاريخ') || title.contains('جغرافيا')) return const Color(0xFF6366F1);
    if (title.contains('إسلامية')) return const Color(0xFF8B5CF6);
    return const Color(0xFF00B4D8);
  }
}
