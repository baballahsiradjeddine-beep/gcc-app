import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tayssir/constants/app_consts.dart';
import 'package:tayssir/features/leaderboard/leaderboard_user.dart';
import 'package:tayssir/providers/user/user_notifier.dart';
import 'package:tayssir/resources/colors/app_colors.dart';

class LeaderboardListTile extends ConsumerWidget {
  final LeaderboardUser user;
  final int rank;

  const LeaderboardListTile({
    required this.user,
    required this.rank,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMe = user.id == ref.watch(userNotifierProvider).requireValue!.id;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Container(
        decoration: BoxDecoration(
          color: isMe ? AppColors.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: isMe
                ? AppColors.primaryColor.withOpacity(0.7)
                : Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isMe ? Colors.white : Colors.grey[200],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  '$rank',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: rank < 10
                        ? 16.sp
                        : rank < 100
                            ? 14.sp
                            : 12.sp,
                    color: isMe ? AppColors.primaryColor : Colors.grey[700],
                  ),
                ),
              ),
              16.horizontalSpace,
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isMe ? Colors.white : AppColors.primaryColor,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (isMe ? Colors.white : AppColors.primaryColor)
                          .withOpacity(0.25),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: CachedNetworkImage(
                  imageUrl: user.prodImage ?? AppConsts.defaultImageUrl,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              16.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        color: isMe ? Colors.white : Colors.black,
                      ),
                    ),
                    4.verticalSpace,
                    Text(
                      user.wilaya,
                      style: TextStyle(
                        color: isMe
                            ? Colors.white.withOpacity(0.8)
                            : Colors.black.withValues(alpha: 0.5),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${user.points} نقطة',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: isMe ? Colors.white : AppColors.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
