import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/features/onboarding/onboarding_notifier.dart';
import 'package:tayssir/features/onboarding/widgets/onboarding_button.dart';
import 'package:tayssir/features/onboarding/widgets/tito_speaker.dart';
import 'package:tayssir/providers/settings/settings_provider.dart';

class StepThemePage extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  const StepThemePage({super.key, required this.onNext});

  @override
  ConsumerState<StepThemePage> createState() => _StepThemePageState();
}

class _StepThemePageState extends ConsumerState<StepThemePage> {
  bool? _isDarkSelected;

  Future<void> _handleNext() async {
    if (_isDarkSelected == null) return;
    
    // Set the theme in settings
    final currentIsDark = ref.read(settingsNotifierProvider).isDarkMode;
    if (currentIsDark != _isDarkSelected) {
      await ref.read(settingsNotifierProvider.notifier).toggleDarkMode();
    }
    
    // Start the tour redirecting to home
    await ref.read(onboardingProvider.notifier).startTour();
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 28.w),
        child: Column(
          children: [
            60.verticalSpace,

            // ── Tito ──
            TitoSpeaker(
              message: 'كيف تفضل المذاكرة؟ 💡\nأختر السمة التي تريح عينيك\nلنبدأ رحلتنا!',
            ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.2, end: 0, curve: Curves.easeOutBack),

            40.verticalSpace,

            // ── Theme Selection ──
            Row(
              children: [
                Expanded(
                  child: _ThemeCard(
                    isDark: true,
                    isSelected: _isDarkSelected == true,
                    onTap: () => setState(() => _isDarkSelected = true),
                  ),
                ),
                20.horizontalSpace,
                Expanded(
                  child: _ThemeCard(
                    isDark: false,
                    isSelected: _isDarkSelected == false,
                    onTap: () => setState(() => _isDarkSelected = false),
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),

            const Spacer(),

            // ── CTA ──
            OnboardingButton(
              label: 'بدء الرحلة 🚀',
              enabled: _isDarkSelected != null,
              onPressed: _handleNext,
            ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.3, end: 0),

            32.verticalSpace,
          ],
        ),
      ),
    );
  }
}

class _ThemeCard extends StatelessWidget {
  final bool isDark;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeCard({
    required this.isDark,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: isSelected ? const Color(0xFF00B4D8) : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
            width: isSelected ? 3 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF00B4D8).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  )
                ]
              : [],
        ),
        child: Column(
          children: [
            Container(
              width: 50.sp,
              height: 50.sp,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isDark ? Icons.nightlight_round : Icons.wb_sunny_rounded,
                color: isDark ? Colors.yellow : Colors.orange,
                size: 28.sp,
              ),
            ),
            16.verticalSpace,
            Text(
              isDark ? 'ليلي' : 'نهاري',
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF1E293B),
                fontSize: 18.sp,
                fontWeight: FontWeight.w900,
                fontFamily: 'SomarSans',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
