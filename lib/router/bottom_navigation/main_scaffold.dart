import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:tayssir/features/onboarding/onboarding_notifier.dart';
import 'package:tayssir/router/app_router.dart';
import 'package:tayssir/services/sounds/sound_manager.dart';
import 'package:tayssir/providers/special_effect/special_effect_provider.dart';
import 'package:flutter/services.dart';

// ── Global showcase keys for each nav tab ──
final GlobalKey tourKeyHome = GlobalKey();
final GlobalKey tourKeyLeaderboard = GlobalKey();
final GlobalKey tourKeyTools = GlobalKey();
final GlobalKey tourKeyChallenges = GlobalKey();
final GlobalKey tourKeySettings = GlobalKey();
final GlobalKey tourKeyFirstMaterial = GlobalKey();

/// The ordered list of showcase keys + which tab they belong to
const _tourOrder = [
  // (navIndex, label, description)
  _TourStepDef(
    navIndex: 2,
    label: 'الصفحة الرئيسية 📚',
    desc: 'مرحباً بك! هنا تجد كل موادك الدراسية منظمة حسب الشعبة.',
  ),
  _TourStepDef(
    navIndex: 1,
    label: 'لوحة المتصدرين �',
    desc: 'هنا يمكنك منافسة زملائك ورؤية ترتيبك الوطني!',
  ),
  _TourStepDef(
    navIndex: 3,
    label: 'صفحة التحديات 🎮',
    desc: 'تحدى نفسك وأصدقاءك في مسابقات سريعة وممتعة لتربح النقاط.',
  ),
  _TourStepDef(
    navIndex: 0,
    label: 'صفحة الأدوات 🧰',
    desc: 'هنا تجد كل ما يساعدك: بومودورو، ملخصات، وأدوات دراسية ذكية.',
  ),
  _TourStepDef(
    navIndex: 4,
    label: 'الإعدادات ⚙️',
    desc: 'خصص حسابك، اختر الوضع الليلي، وتحكم في تنبيهاتك بكل سهولة.',
  ),
];

class _TourStepDef {
  final int navIndex;
  final String label;
  final String desc;
  const _TourStepDef({
    required this.navIndex,
    required this.label,
    required this.desc,
  });
}

GlobalKey _keyForStep(int stepIndex) {
  if (stepIndex >= _tourOrder.length) return tourKeyFirstMaterial;
  switch (_tourOrder[stepIndex].navIndex) {
    case 0: return tourKeyTools;
    case 1: return tourKeyLeaderboard;
    case 2: return tourKeyHome;
    case 3: return tourKeyChallenges;
    case 4: return tourKeySettings;
    default: return tourKeyHome;
  }
}

class MainScaffold extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;
  const MainScaffold({super.key, required this.navigationShell});

  @override
  ConsumerState<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends ConsumerState<MainScaffold> {
  BuildContext? _showCaseContext;
  bool _tourStarted = false;

  void _startTourIfNeeded(BuildContext showCaseCtx) {
    if (_tourStarted) return;
    final tourStep = ref.read(onboardingProvider).tourStep;
    if (tourStep < 0 || tourStep >= 6) return;

    _tourStarted = true;
    _showCaseContext = showCaseCtx;

    // Map tourStep → showcase key
    final stepIndex = tourStep < _tourOrder.length ? tourStep : 0;
    final key = _keyForStep(stepIndex);

    // Delay so screen renders fully and layout stabilizes first
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        // Wait for potential animations and layout settling
        await Future.delayed(const Duration(milliseconds: 1000));
        if (mounted) {
          ShowCaseWidget.of(showCaseCtx).startShowCase([key]);
        }
      }
    });
  }

  // Called when user taps the highlighted nav item (showcase bubble dismissed).
  // showcaseview intercepts taps and never fires the widget's own onTap,
  // so we handle navigation + tour advancement here.
  void _onShowCaseComplete(int? showcaseIndex, GlobalKey key) async {
    final current = ref.read(onboardingProvider).tourStep;
    if (current < 0 || current >= _tourOrder.length) return;

    final isSoundOn = ref.read(isSoundEnabledProvider);
    if (isSoundOn) SoundService.playClickPremium();
    HapticFeedback.lightImpact();

    // 1. Navigate to the tapped tab right away
    final navIndex = _tourOrder[current].navIndex;
    widget.navigationShell.goBranch(
      navIndex,
      initialLocation: true,
    );

    final next = current + 1;

    if (next >= _tourOrder.length) {
      // Nav tour done — Go back to Home for Material spotlight
      await ref.read(onboardingProvider.notifier).setTourStep(5); // step 5 = Home material spotlight
      widget.navigationShell.goBranch(2, initialLocation: true);
      setState(() => _tourStarted = false);
    } else {
      // Advance state and start next showcase
      await ref.read(onboardingProvider.notifier).setTourStep(next);
      setState(() => _tourStarted = false);

      if (_showCaseContext != null && mounted) {
        final nextKey = _keyForStep(next);
        // Wait for the new tab's page to render before highlighting
        await Future.delayed(const Duration(milliseconds: 700));
        if (mounted) {
          ShowCaseWidget.of(_showCaseContext!).startShowCase([nextKey]);
        }
      }
    }
  }

  // onFinish fires after the whole batch completes — not used since we
  // handle everything in onComplete.
  void _onShowCaseDone() {}

  void _showRegisterSheet() {
    final name = ref.read(onboardingProvider).name ?? 'صديقي';
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (_) => _RegisterNowSheet(
        name: name,
        onRegister: () async {
          await ref.read(onboardingProvider.notifier).completeOnboarding();
          if (mounted) {
            Navigator.pop(context);
            context.goNamed(AppRoutes.register.name);
          }
        },
        onSkip: () async {
          await ref.read(onboardingProvider.notifier).completeOnboarding();
          if (mounted) Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tourStep = ref.watch(onboardingProvider).tourStep;
    final isTourActive = tourStep >= 0 && tourStep <= 5; // step 5 is the material highlight in HomeScreen

    final currentStepDef = (tourStep >= 0 && tourStep < _tourOrder.length) 
        ? _tourOrder[tourStep] 
        : null;

    return ShowCaseWidget(
      onFinish: _onShowCaseDone,
      onComplete: _onShowCaseComplete,
      builder: (showCaseCtx) {
        // Trigger tour on first build if active
        if (isTourActive && !_tourStarted) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => _startTourIfNeeded(showCaseCtx),
          );
        }
        
        // Automatically show register sheet when tour reaches completion state
        if (tourStep == 99) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (ModalRoute.of(context)?.isCurrent ?? false) {
              _showRegisterSheet();
            }
          });
        }

        return Scaffold(
          extendBody: true,
          body: Stack(
            children: [
              widget.navigationShell,
              if (isTourActive && tourStep < _tourOrder.length)
                _TitoBubbleOverlay(
                  step: currentStepDef,
                  name: ref.read(onboardingProvider).name ?? 'صديقي',
                ),
            ],
          ),
          bottomNavigationBar: _TourAwareNavBar(
            currentIndex: widget.navigationShell.currentIndex,
            isTourActive: isTourActive,
            currentTourNavIndex: (tourStep >= 0 && tourStep < _tourOrder.length)
                ? _tourOrder[tourStep].navIndex
                : -1,
            onTap: (index) {
              widget.navigationShell.goBranch(index,
                  initialLocation: widget.navigationShell.currentIndex == index);
            },
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────
// Tour-aware Bottom Nav Bar
// ─────────────────────────────────────────

class _TourAwareNavBar extends ConsumerWidget {
  final int currentIndex;
  final bool isTourActive;
  final int currentTourNavIndex;
  final Function(int) onTap;

  const _TourAwareNavBar({
    required this.currentIndex,
    required this.isTourActive,
    required this.currentTourNavIndex,
    required this.onTap,
  });

  GlobalKey _keyForNavIndex(int index) {
    switch (index) {
      case 0: return tourKeyTools;
      case 1: return tourKeyLeaderboard;
      case 2: return tourKeyHome;
      case 3: return tourKeyChallenges;
      case 4: return tourKeySettings;
      default: return tourKeyHome;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 80.h,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          // Background
          _NavBackground(isDark: isDark),

          // Items
          Container(
            height: 80.h,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildNavItem(context, ref, 0, Icons.category_outlined, Icons.category_rounded, "أدوات", isDark),
                _buildNavItem(context, ref, 1, Icons.leaderboard_outlined, Icons.leaderboard_rounded, "ترتيب", isDark),
                _buildNavItem(context, ref, 2, Icons.home_outlined, Icons.home_rounded, "الرئيسية", isDark),
                _buildNavItem(context, ref, 3, Icons.flag_outlined, Icons.flag_rounded, "تحديات", isDark),
                _buildNavItem(context, ref, 4, Icons.settings_outlined, Icons.settings_rounded, "اعدادات", isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    WidgetRef ref,
    int index,
    IconData outlineIcon,
    IconData filledIcon,
    String label,
    bool isDark,
  ) {
    final isSelected = currentIndex == index;
    final isTargetted = isTourActive && index == currentTourNavIndex;
    final isBlocked = isTourActive && index != currentTourNavIndex;
    final isSoundOn = ref.watch(isSoundEnabledProvider);
    
    final VoidCallback? tapCallback = isBlocked ? null : () {
      if (isSoundOn && !isSelected) {
        SoundService.playClickPremium();
        HapticFeedback.lightImpact();
      }
      onTap(index);
    };

    // For selected item: build the floating container using layout padding 
    // instead of Transform.translate so Showcase calculates the exact bounds.
    if (isSelected) {
      Widget showcasedOrNot = GestureDetector(
        onTap: tapCallback,
        child: Container(
          width: 68.sp,
          height: 68.sp,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF00B4D8), Color(0xFF0077B6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
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
          child: Icon(filledIcon, size: 30.sp, color: Colors.white),
        ),
      ).animate().scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack);

      if (isTargetted) {
        final step = _tourOrder.firstWhere((s) => s.navIndex == index,
            orElse: () => const _TourStepDef(navIndex: -1, label: '', desc: ''));
        showcasedOrNot = Showcase(
          key: _keyForNavIndex(index),
          description: step.desc,
          descTextStyle: TextStyle(
            fontFamily: 'SomarSans',
            fontSize: 14.sp,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
          tooltipBackgroundColor: const Color(0xFF0F172A),
          tooltipPosition: TooltipPosition.top,
          targetBorderRadius: BorderRadius.circular(24.r),
          overlayOpacity: 0.3,
          targetPadding: EdgeInsets.all(8.sp),
          child: showcasedOrNot,
        );
      }

      // Use Padding to push the element up in the layout tree, 
      // preventing any Showcase bounding box calculation errors.
      return Padding(
        padding: EdgeInsets.only(bottom: 25.h),
        child: showcasedOrNot,
      );
    }

    // Non-selected item
    Widget item = _NavItemWidget(
      index: index,
      outlineIcon: outlineIcon,
      filledIcon: filledIcon,
      label: label,
      isDark: isDark,
      isSelected: false,
      onTap: tapCallback,
    );

    if (isTargetted) {
      final step = _tourOrder.firstWhere((s) => s.navIndex == index,
          orElse: () => const _TourStepDef(navIndex: -1, label: '', desc: ''));
      item = Showcase(
        key: _keyForNavIndex(index),
        description: step.desc,
        descTextStyle: TextStyle(
          fontFamily: 'SomarSans',
          fontSize: 14.sp,
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
        tooltipBackgroundColor: const Color(0xFF0F172A),
        tooltipPosition: TooltipPosition.top,
        targetBorderRadius: BorderRadius.circular(16.r),
        overlayOpacity: 0.3,
        targetPadding: EdgeInsets.all(8.sp),
        child: item,
      );
    }

    return item;
  }
}

class _NavItemWidget extends StatelessWidget {
  final int index;
  final IconData outlineIcon;
  final IconData filledIcon;
  final String label;
  final bool isDark;
  final bool isSelected;
  final VoidCallback? onTap;

  const _NavItemWidget({
    required this.index,
    required this.outlineIcon,
    required this.filledIcon,
    required this.label,
    required this.isDark,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Note: selected state is now handled in _buildNavItem directly
    // to allow Showcase to wrap the visual position correctly.
    if (isSelected) {
      return GestureDetector(
        onTap: onTap,
        child: Transform.translate(
          offset: Offset(0, -25.h),
          child: Container(
            width: 68.sp,
            height: 68.sp,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF00B4D8), Color(0xFF0077B6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
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
            child: Icon(filledIcon, size: 30.sp, color: Colors.white),
          ),
        ),
      ).animate().scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack);
    }

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 60.w,
        padding: EdgeInsets.only(bottom: 12.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              outlineIcon,
              size: 26.sp,
              color: onTap == null
                  ? (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E0))
                  : (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
            ),
            6.verticalSpace,
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                color: onTap == null
                    ? (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E0))
                    : (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
                fontFamily: 'SomarSans',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// Tito bubble overlay during tour
// ─────────────────────────────────────────

class _TitoBubbleOverlay extends StatelessWidget {
  final _TourStepDef? step;
  final String name;

  const _TitoBubbleOverlay({this.step, required this.name});

  @override
  Widget build(BuildContext context) {
    if (step == null) return const SizedBox.shrink();

    return Positioned(
      top: MediaQuery.of(context).padding.top + 16.h,
      left: 16.w,
      right: 16.w,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B).withOpacity(0.95), // Slightly lighter, more premium navy
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: const Color(0xFF00B4D8).withOpacity(0.6), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00B4D8).withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                '${step!.desc}',
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'SomarSans',
                ),
              ),
            ),
            12.horizontalSpace,
            Text('🐬', style: TextStyle(fontSize: 30.sp)),
          ],
        ),
      ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.3, end: 0),
    );
  }
}

// ── Nav Background helper ──
class _NavBackground extends StatelessWidget {
  final bool isDark;
  const _NavBackground({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(32.r),
        topRight: Radius.circular(32.r),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          height: 80.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF0F172A).withOpacity(0.85)
                : Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32.r),
              topRight: Radius.circular(32.r),
            ),
            border: Border(
              top: BorderSide(
                color: isDark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.black.withOpacity(0.05),
                width: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// Register Now Bottom Sheet
// ─────────────────────────────────────────

class _RegisterNowSheet extends StatelessWidget {
  final String name;
  final VoidCallback onRegister;
  final VoidCallback onSkip;

  const _RegisterNowSheet({
    required this.name,
    required this.onRegister,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(28.w),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(32.r),
        border: Border.all(color: const Color(0xFF00B4D8).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00B4D8).withOpacity(0.15),
            blurRadius: 40,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('🎉🐬', style: TextStyle(fontSize: 60.sp))
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .moveY(begin: -6, end: 6, duration: 2.seconds),
          20.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            textDirection: TextDirection.rtl,
            children: [
              Text(
                'أحسنت يا ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'SomarSans',
                ),
              ),
              Text(
                name,
                style: TextStyle(
                  color: const Color(0xFF00B4D8),
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'SomarSans',
                ),
              ),
              Text(
                ' ! 🌟',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'SomarSans',
                ),
              ),
            ],
          ),
          10.verticalSpace,
          Text(
            'رأيت كل ما يقدمه التطبيق!\nسجّل الآن لتحفظ مسارك ونقاطك',
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              color: const Color(0xFF94A3B8),
              fontSize: 15.sp,
              fontFamily: 'SomarSans',
              height: 1.6,
            ),
          ),
          28.verticalSpace,
          GestureDetector(
            onTap: onRegister,
            child: Container(
              width: double.infinity,
              height: 56.h,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00B4D8), Color(0xFF0077B6)],
                ),
                borderRadius: BorderRadius.circular(18.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00B4D8).withOpacity(0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: Center(
                child: Text(
                  '🔑 إنشاء حساب مجاناً',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'SomarSans',
                  ),
                ),
              ),
            ),
          ),
          14.verticalSpace,
          GestureDetector(
            onTap: onSkip,
            child: Text(
              'تخطي الآن',
              style: TextStyle(
                color: const Color(0xFF64748B),
                fontSize: 14.sp,
                fontFamily: 'SomarSans',
                decoration: TextDecoration.underline,
                decorationColor: const Color(0xFF64748B),
              ),
            ),
          ),
          20.verticalSpace,
        ],
      ),
    );
  }
}
