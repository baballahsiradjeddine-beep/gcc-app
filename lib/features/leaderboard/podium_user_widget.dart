import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tayssir/constants/app_consts.dart';
import 'package:tayssir/features/leaderboard/leaderboard_user.dart';
import 'package:tayssir/providers/user/user_notifier.dart';
import 'package:tayssir/resources/colors/app_colors.dart';

class PodiumUserWidget extends ConsumerWidget {
  final LeaderboardUser user;
  final int place;
  final double size;
  final double offsetY;

  const PodiumUserWidget({
    required this.user,
    required this.place,
    required this.size,
    required this.offsetY,
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
    final isMe = user.id == ref.watch(userNotifierProvider).requireValue!.id;
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(top: offsetY),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CachedNetworkImage(
                  imageUrl: user.prodImage ?? AppConsts.defaultImageUrl,
                  imageBuilder: (context, imageProvider) => Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isMe ? Colors.blue : AppColors.primaryColor,
                        width: isMe ? 3 : 2,
                      ),
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
                      width: size,
                      height: size,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primaryColor,
                        width: 2,
                      ),
                    ),
                    child: const Icon(Icons.error),
                  ),
                ),
                if (isMe)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(4.r),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 14.r,
                      ),
                    ),
                  ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: placeColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: FittedBox(
                    child: Text(
                      place == 1
                          ? '🥇 المركز الأول'
                          : place == 2
                              ? '🥈 المركز الثاني'
                              : '🥉 المركز الثالث',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: size > 100 ? 11.sp : 10.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            10.verticalSpace,
            Text(
              isMe ? "أنت (${user.name})" : user.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
                color: isMe ? Colors.blue : Colors.black,
              ),
            ),
            // wilaya
            Text(
              user.wilaya,
              style: TextStyle(
                color: Colors.black.withValues(alpha: 0.5),
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              '${user.points} نقطة',
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: isMe ? Colors.blue : AppColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
