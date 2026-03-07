import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/resources/colors/app_colors.dart';

class CustomBottomNavBarWidget extends ConsumerWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBarWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 80.h, // Only occupy the physical navbar height
      child: Stack(
        clipBehavior: Clip.none, // Allow children (like the home button) to float outside
        alignment: Alignment.bottomCenter,
        children: [
          // 1. Navbar Background (Frosted Glass Container)
          Container(
            height: 80.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A).withOpacity(0.85) : Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32.r),
                topRight: Radius.circular(32.r),
              ),
              border: Border(
                top: BorderSide(
                  color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
                  width: 1,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.4 : 0.04),
                  blurRadius: 30,
                  offset: const Offset(0, -10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32.r),
                topRight: Radius.circular(32.r),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15), // Slightly reduced for clarity
                child: const SizedBox.expand(),
              ),
            ),
          ),

          // 2. Items Layer
          Container(
            height: 80.h,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildItem(context, 0, Icons.category_outlined, Icons.category_rounded, "أدوات", isDark),
                _buildItem(context, 1, Icons.leaderboard_outlined, Icons.leaderboard_rounded, "ترتيب", isDark),
                _buildItem(context, 2, Icons.home_outlined, Icons.home_rounded, "الرئيسية", isDark),
                _buildItem(context, 3, Icons.flag_outlined, Icons.flag_rounded, "تحديات", isDark),
                _buildItem(context, 4, Icons.settings_outlined, Icons.settings_rounded, "اعدادات", isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index, IconData outlineIcon, IconData filledIcon, String label, bool isDark) {
    final bool isSelected = currentIndex == index;

    if (isSelected) {
      return GestureDetector(
        onTap: () => onTap(index),
        child: Transform.translate(
          offset: Offset(0, -25.h), // Raised slightly per user request (from -18.h)
          child: Container(
            width: 68.sp,
            height: 68.sp,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00B4D8).withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Shine Effect
                Positioned(
                  top: -30.sp,
                  left: -30.sp,
                  child: RotationTransition(
                    turns: const AlwaysStoppedAnimation(45 / 360),
                    child: Container(
                      width: 25.sp,
                      height: 110.sp,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.white.withOpacity(0), Colors.white.withOpacity(0.3), Colors.white.withOpacity(0)],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  ).animate(onPlay: (c) => c.repeat(period: 3.seconds)).move(begin: const Offset(-50, -50), end: const Offset(120, 120)),
                ),
                
                Icon(
                  filledIcon,
                  size: 30.sp,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ).animate().scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack);
    }

    // Unselected State
    return GestureDetector(
      onTap: () => onTap(index),
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
              color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
            ),
            6.verticalSpace,
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                fontFamily: 'SomarSans',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
