import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/core/shield_badge.dart';
import 'package:tayssir/providers/user/user_notifier.dart';
import 'package:tayssir/resources/resources.dart';
import '../../services/actions/share_service.dart';
import 'utils/achievement_share_utils.dart';

class AchievementLogScreen extends HookConsumerWidget {
  const AchievementLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userNotifierProvider).requireValue!;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text(
          'سجل الإنجازات',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'SomarSans',
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () async {
              final shareUtils = AchievementShareUtils();
              final imagePath = await shareUtils.captureAchievementImage(user);
              if (imagePath != null) {
                await ShareService.shareFile(
                  filePath: imagePath,
                  text: 'تحقق من إنجازاتي في تطبيق تيسير! 🚀',
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            // Shield Section
            _ShieldWidget(
              userAvatarUrl: user.completeProfilePic,
              level: user.level,
              rank: user.rank,
              badgeIconUrl: user.badge?.iconUrl,
              badgeColor: user.badge?.color,
              points: user.points,
            ),
            25.verticalSpace,

            // Stats Grid
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'النقاط الإجمالية',
                    value: '${user.points}',
                    icon: SVGs.icPoints,
                    valueColor: const Color(0xFFF59E0B),
                  ),
                ),
                15.horizontalSpace,
                Expanded(
                  child: _StatCard(
                    title: 'الرتبة الحالية',
                    value: user.rank,
                    icon: SVGs.icRank,
                    valueColor: const Color(0xFF8B5CF6),
                  ),
                ),
              ],
            ),
            15.verticalSpace,
            _StatCard(
              title: 'المستوى',
              value: 'مستوى ${user.level}',
              icon: SVGs.icLevel,
              valueColor: const Color(0xFF10B981),
            ),
            30.verticalSpace,

            // Badge section placeholder or title
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'الأوسمة المكتسبة',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SomarSans',
                ),
              ),
            ),
            15.verticalSpace,

            // Example badges grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 15.w,
                mainAxisSpacing: 15.h,
                childAspectRatio: 0.8,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                return _BadgeItem(
                  isLocked: index > 1,
                  title: index == 0 ? 'المتفوق' : 'المثابر',
                  icon: index == 0 ? SVGs.icBadge1 : SVGs.icBadge2,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ShieldWidget extends StatelessWidget {
  final String userAvatarUrl;
  final int level;
  final String rank;
  final String? badgeIconUrl;
  final String? badgeColor;
  final int points;

  const _ShieldWidget({
    required this.userAvatarUrl,
    required this.level,
    required this.rank,
    this.badgeIconUrl,
    this.badgeColor,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    final themeColor = badgeColor != null
        ? Color(int.parse(badgeColor!.replaceAll('#', '0xFF')))
        : const Color(0xFF2DD4BF);

    return SizedBox(
      height: 195.h,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          ShieldBadge(
            userAvatarUrl: userAvatarUrl,
            badgeIconUrl: badgeIconUrl,
            themeColor: themeColor,
            width: 140.w,
            height: 165.h,
            avatarPaddingTop: 40.h,
            avatarSize: 125.w,
          ),

          // Stars (Only show if no badge icon or as part of custom design)
          if (badgeIconUrl == null) ...[
            Positioned(
              top: 45.h,
              left: 55.w,
              child: const Icon(Icons.star, color: Colors.white70, size: 14),
            ),
            Positioned(
              top: 45.h,
              right: 55.w,
              child: const Icon(Icons.star, color: Colors.white70, size: 14),
            ),
          ],

          // Points/Level display at the bottom center of the shield
          Positioned(
            bottom: 38.h,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$points pts',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'SomarSans',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String icon;
  final Color valueColor;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          SvgPicture.asset(icon, width: 24.w, height: 28.h),
          10.horizontalSpace,
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF6B7280),
                    fontFamily: 'SomarSans',
                  ),
                ),
                1.verticalSpace,
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
                    color: valueColor,
                    fontFamily: 'SomarSans',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeItem extends StatelessWidget {
  final bool isLocked;
  final String title;
  final String icon;

  const _BadgeItem({
    required this.isLocked,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80.w,
          height: 80.w,
          decoration: BoxDecoration(
            color: isLocked ? Colors.grey.shade100 : Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: isLocked ? 0.3 : 1.0,
                child: SvgPicture.asset(icon, width: 45.w),
              ),
              if (isLocked)
                Icon(Icons.lock_outline, color: Colors.grey.shade400, size: 24.w),
            ],
          ),
        ),
        8.verticalSpace,
        Text(
          title,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: isLocked ? Colors.grey : Colors.black,
            fontFamily: 'SomarSans',
          ),
        ),
      ],
    );
  }
}
