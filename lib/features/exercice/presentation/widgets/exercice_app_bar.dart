import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/features/exercice/presentation/state/exercise_state.dart';
import 'package:tayssir/features/exercice/presentation/widgets/exercise_header.dart';
import 'package:tayssir/providers/settings/settings_provider.dart';
import 'package:tayssir/resources/colors/app_colors.dart';

class ExerciceAppBar extends ConsumerWidget {
  const ExerciceAppBar({
    super.key,
    required this.exercisesState,
    required this.onClosePressed,
  });

  final ExerciseState exercisesState;
  final VoidCallback onClosePressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final settings = ref.watch(settingsNotifierProvider);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A).withOpacity(0.7) : Colors.white.withOpacity(0.7),
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF1E293B).withOpacity(0.5) : const Color(0xFFF1F5F9),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Theme Toggle Button (Right side in RTL)
            GestureDetector(
              onTap: () => ref.read(settingsNotifierProvider.notifier).toggleDarkMode(),
              child: Container(
                width: 40.sp,
                height: 40.sp,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  settings.isDarkMode ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                  size: 20.sp,
                  color: settings.isDarkMode ? Colors.yellow : const Color(0xFF64748B),
                ),
              ),
            ),
            
            16.horizontalSpace,
            
            // Progress Bar and Points Section (Center)
            Expanded(
              child: Row(
                children: [
                   ExerciseHeader(progress: exercisesState.progress),
                   16.horizontalSpace,
                   // Points Display (GEM)
                   Row(
                     mainAxisSize: MainAxisSize.min,
                     children: [
                        Text(
                          exercisesState.points.toString(),
                          style: TextStyle(
                            color: isDark ? Colors.white : const Color(0xFF1E293B),
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'SomarSans',
                          ),
                        ),
                        4.horizontalSpace,
                        Text(
                          "💎", // Use Emoji for Diamond/Gem or specific icon
                          style: TextStyle(fontSize: 18.sp),
                        ),
                     ],
                   ),
                ],
              ),
            ),
            
            16.horizontalSpace,
            
            // Close Button (Left side in RTL)
            IconButton(
              onPressed: onClosePressed,
              icon: Icon(
                Icons.close_rounded,
                color: isDark ? Colors.white : const Color(0xFF64748B),
                size: 24.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
