import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tayssir/constants/app_consts.dart';
import 'package:tayssir/features/leaderboard/leaderboard_user.dart';
import 'package:tayssir/providers/user/user_notifier.dart';
import 'package:tayssir/resources/colors/app_colors.dart';
import 'package:tayssir/common/core/shield_badge.dart';

class PodiumUserWidget extends ConsumerWidget {
  final LeaderboardUser user;
  final int place;
  final double size;
  final double offsetY;
  final bool isDark;

  const PodiumUserWidget({
    required this.user,
    required this.place,
    required this.size,
    required this.offsetY,
    required this.isDark,
    super.key,
  });

  Color get placeColor {
    switch (place) {
      case 1:
        return const Color(0xFFFFD700); // Gold
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMe = user.id == ref.watch(userNotifierProvider).valueOrNull?.id;
    return Padding(
      padding: EdgeInsets.only(top: offsetY),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                // Shield Badge Avatar
                ShieldBadge(
                  userAvatarUrl: user.prodImage,
                  badgeIconUrl: user.badge?.completeIconUrl,
                  themeColor: user.badge?.color != null 
                      ? Color(int.parse(user.badge!.color!.replaceAll('#', '0xFF')))
                      : const Color(0xFF00B4D8),
                  width: size,
                  height: size * 1.25,
                  avatarPaddingTop: size * 0.25,
                  avatarSize: size * 0.85,
                ),
                
                // Rank Badge
                Positioned(
                  bottom: -12.h,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: placeColor,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: placeColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          place == 1 ? '🥇' : place == 2 ? '🥈' : '🥉',
                          style: TextStyle(fontSize: 10.sp),
                        ),
                        4.horizontalSpace,
                        Text(
                          place == 1 ? 'المركز الأول' : place == 2 ? 'المركز الثاني' : 'المركز الثالث',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 10.sp,
                            fontFamily: 'SomarSans',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Me Indicator
                if (isMe)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 24.sp,
                      height: 24.sp,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.w),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00B4D8).withOpacity(0.3),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Icon(Icons.person_rounded, color: Colors.white, size: 14.sp),
                    ),
                  ),
              ],
            ),
            30.verticalSpace,
            // Name
            Text(
              isMe ? "أنت (${user.name})" : user.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: size > 100 ? 16.sp : 14.sp,
                color: isMe 
                    ? AppColors.primaryColor 
                    : (isDark ? Colors.white : AppColors.secondaryDark),
                fontFamily: 'SomarSans',
              ),
            ),
            // City
            Text(
              user.wilaya,
              style: TextStyle(
                color: isDark ? Colors.white60 : const Color(0xFF64748B),
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                fontFamily: 'SomarSans',
              ),
            ),
            // Points
            Text(
              '${user.points} $pointsText',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w900,
                color: isMe ? const Color(0xFF00B4D8) : (isDark ? Colors.cyanAccent : const Color(0xFF0D9488)),
                fontFamily: 'SomarSans',
              ),
            ),
          ],
      ),
    );
  }

  String get pointsText {
    if (user.points <= 10) return 'نقاط';
    return 'نقطة';
  }
}
