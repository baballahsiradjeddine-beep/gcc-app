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

class LeaderboardListTile extends ConsumerWidget {
  final LeaderboardUser user;
  final int rank;
  final bool isDark;

  const LeaderboardListTile({
    required this.user,
    required this.rank,
    required this.isDark,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMe = user.id == ref.watch(userNotifierProvider).valueOrNull?.id;
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Container(
        decoration: BoxDecoration(
          color: isMe 
              ? AppColors.primaryColor.withOpacity(0.08) 
              : (isDark ? AppColors.darkBlue : Colors.white),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isMe 
                ? AppColors.primaryColor.withOpacity(0.3) 
                : (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.02)),
            width: 1.w,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black26 : Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          child: Row(
            children: [
              // Rank Text
              Container(
                width: 32.w,
                alignment: Alignment.center,
                child: Text(
                  '$rank',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16.sp,
                    color: isMe ? const Color(0xFF00B4D8) : (isDark ? Colors.white70 : const Color(0xFF64748B)),
                    fontFamily: 'SomarSans',
                  ),
                ),
              ),
              12.horizontalSpace,
              // Shield Badge Avatar
              ShieldBadge(
                userAvatarUrl: user.prodImage,
                badgeIconUrl: user.badge?.completeIconUrl,
                themeColor: user.badge?.color != null 
                    ? Color(int.parse(user.badge!.color!.replaceAll('#', '0xFF')))
                    : const Color(0xFF00B4D8),
                width: 48.sp,
                height: 60.sp,
                avatarPaddingTop: 12.sp,
                avatarSize: 42.sp,
              ),
              16.horizontalSpace,
              // Name and Wilaya
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isMe ? "أنت (${user.name})" : user.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 14.sp,
                        color: isMe ? const Color(0xFF00B4D8) : (isDark ? Colors.white : const Color(0xFF1E293B)),
                        fontFamily: 'SomarSans',
                      ),
                    ),
                    2.verticalSpace,
                    Text(
                      user.wilaya,
                      style: TextStyle(
                        color: isDark ? Colors.white60 : const Color(0xFF64748B),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'SomarSans',
                      ),
                    ),
                  ],
                ),
              ),
              // Points
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white10 : AppColors.scaffoldColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  '${user.points} $pointsText',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w900,
                    color: isMe ? const Color(0xFF00B4D8) : (isDark ? Colors.cyanAccent : const Color(0xFF0D9488)),
                    fontFamily: 'SomarSans',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get pointsText {
    if (user.points <= 10) return 'نقاط';
    return 'نقطة';
  }
}
