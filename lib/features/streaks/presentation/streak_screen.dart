import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tayssir/common/app_buttons/big_button.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/features/streaks/data/streak_model.dart';
import 'package:tayssir/features/streaks/utils/streak_share_utils.dart';
import 'package:tayssir/router/app_router.dart';
import 'package:tayssir/resources/resources.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tayssir/common/core/app_assets/dynamic_app_asset.dart';

class StreakScreen extends StatelessWidget {
  final StreakModel streak;
  final int unitId;

  const StreakScreen({super.key, required this.streak, required this.unitId});

  @override
  Widget build(BuildContext context) {
    final int currentStreak = streak.currentStreak;
    final int weekNumber = (currentStreak > 0) ? (currentStreak - 1) ~/ 7 : 0;
    final int weekStartDay = (weekNumber * 7) + 1;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppScaffold(
      onPopScope: () {},
      paddingX: 0,
      paddingY: 0,
      body: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        ),
        child: Stack(
          children: [
            // Ambient Orance Glow (Top)
            Positioned(
              top: -100.h,
              left: 0,
              right: 0,
              child: Container(
                height: 300.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFF28F3B).withOpacity(0.15),
                      const Color(0xFFF28F3B).withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),

            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
                child: Column(
                  children: [
                    // Header Section
                    SizedBox(height: 20.h),
                    Text(
                      "مبارك لك 🎉",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: const Color(0xFFF28F3B),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SomarSans',
                      ),
                    ),
                    Text(
                      "$currentStreak أيام متواصلة",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32.sp,
                        color: const Color(0xFFF28F3B),
                        fontWeight: FontWeight.w900,
                        fontFamily: 'SomarSans',
                        height: 1.2,
                      ),
                    ),

                    const Spacer(flex: 1),

                    // Glowing Fire Section
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Multiple layers of glow
                        Container(
                          width: 180.w,
                          height: 180.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                const Color(0xFFF28F3B).withOpacity(0.3),
                                const Color(0xFFF28F3B).withOpacity(0.0),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 120.w,
                          height: 120.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFF28F3B).withOpacity(0.1),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFF28F3B).withOpacity(0.2),
                                blurRadius: 30,
                                spreadRadius: 5,
                              )
                            ]
                          ),
                          child: Center(
                            child: Text(
                              "🔥",
                              style: TextStyle(fontSize: 70.sp),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const Spacer(flex: 1),

                    // Card Section
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                        borderRadius: BorderRadius.circular(30.r),
                        border: Border.all(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0), 
                          width: 1.5
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(7, (index) {
                                final dayNumber = weekStartDay + index;
                                final bool isCompleted = dayNumber <= currentStreak;
                                return _buildNumericDayItem(dayNumber, isCompleted, isDark);
                              }),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Container(
                            height: 1.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Text(
                            "استمر في العطاء، فكل خطوة صغيرة تقربك من القمة! 🚀",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: isDark ? Colors.white70 : const Color(0xFF1E293B),
                              fontWeight: FontWeight.w700,
                              fontFamily: 'SomarSans',
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(flex: 2),

                    // Tito Mascot
                    SizedBox(
                      height: 130.h,
                      child: DynamicAppAsset(
                        assetKey: 'tito_good',
                        fallbackAssetPath: SVGs.titoGood,
                        type: AppAssetType.svg,
                        fit: BoxFit.contain,
                      ),
                    ),

                    const Spacer(flex: 1),

                    // Footer Section
                    Text(
                      "لا تتوقف... كل يوم يصنع فارقاً!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0077B6),
                        fontWeight: FontWeight.w900,
                        fontFamily: 'SomarSans',
                      ),
                    ),

                    SizedBox(height: 25.h),

                    Row(
                      children: [
                        Expanded(
                          child: BigButton(
                            text: "تابع",
                            buttonType: ButtonType.secondary,
                            onPressed: () {
                              context.pushReplacementNamed(
                                AppRoutes.chapters.name,
                                pathParameters: {
                                  'unitId': unitId.toString(),
                                },
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: BigButton(
                            text: "مشاركة",
                            buttonType: ButtonType.primary,
                            onPressed: () {
                              StreakShareUtils.shareStreak(context, streak);
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumericDayItem(int dayNumber, bool isCompleted, bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "$dayNumber",
          style: TextStyle(
            fontSize: 13.sp,
            color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
            fontWeight: FontWeight.bold,
            fontFamily: 'SomarSans',
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: 36.w,
          height: 36.w,
          decoration: BoxDecoration(
            color: isCompleted ? const Color(0xFF00B4D8) : (isDark ? const Color(0xFF0F172A) : Colors.white),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isCompleted 
                  ? const Color(0xFF00B4D8) 
                  : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
              width: 1.5,
            ),
            boxShadow: [
              if (isCompleted)
                BoxShadow(
                  color: const Color(0xFF00B4D8).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
            ]
          ),
          child: isCompleted
              ? Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 22.sp,
                )
              : null,
        ),
      ],
    );
  }
}
