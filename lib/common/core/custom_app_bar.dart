import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tayssir/common/core/profile_button.dart';
import 'package:tayssir/providers/user/user_notifier.dart';
import 'package:tayssir/resources/colors/app_colors.dart';
import 'package:tayssir/router/app_router.dart';
import 'package:badges/badges.dart' as badges;

import 'app_logo.dart';

class CustomAppBar extends ConsumerWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userNotifierProvider).requireValue!;
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const ProfileButton(),
            const SizedBox(width: 10),
            badges.Badge(
              position: badges.BadgePosition.topEnd(top: -5, end: -2),
              showBadge: user.hasNewNotifications,
              badgeContent: const Text(
                '',
                // user.newNotificationsCount.toString(),
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
              badgeAnimation: const badges.BadgeAnimation.fade(
                animationDuration: Duration(seconds: 2),
                colorChangeAnimationDuration: Duration(seconds: 1),
                loopAnimation: false,
                curve: Curves.fastOutSlowIn,
                colorChangeAnimationCurve: Curves.easeInCubic,
              ),
              badgeStyle: const badges.BadgeStyle(
                badgeColor: AppColors.redColor,
                padding: EdgeInsets.all(4),
              ),
              child: GestureDetector(
                onTap: () {
                  context.pushNamed(AppRoutes.notifcations.name);
                },
                child: const Icon(Icons.notifications_none_outlined,
                    size: 30, color: Colors.black),
              ),
            ),
          ],
        ),
        const Spacer(),
        AppLogo(
          width: 30.w,
          height: 30.w,
        ),
      ],
    );
  }
}
