import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tayssir/common/push_buttons/pushable_button.dart';
import 'package:tayssir/debug/app_logger.dart';
import 'package:tayssir/providers/user/user_notifier.dart';
import 'package:tayssir/resources/colors/app_colors.dart';
import 'package:tayssir/resources/resources.dart';

import '../../router/app_router.dart';
import 'app_button.dart';

class SubscribeButton extends ConsumerWidget {
  const SubscribeButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userNotifierProvider).requireValue;
    handlePress() {
      if (user != null && !user.isSub) {
        context.pushNamed(AppRoutes.subscriptionOptions.name);
        return;
      }
    }

    return PushableButton(
      height: 120.h,
      borderRadius: 16,
      elevation: 7,
      hasBorder: false,
      onPressed: () {
        final email = ref.watch(userNotifierProvider).requireValue!.email;
        AppLogger.sendLog(
          email: email,
          content: 'Clicked on subscribe button',
          type: LogType.subscriptions,
        );
        handlePress();
      },
      hslColor: HSLColor.fromColor(Colors.blue),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Images.subBg),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'احصل على جميع الدورات والمحتويات المميزة الآن!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SmallButton(
                      onPressed: () {
                        handlePress();
                      },
                      text: 'اشترك الآن',
                      fontSize: 16,
                      color: AppColors.primaryColor,
                      height: 30.h,
                      width: 100.h,
                    )
                  ],
                ),
              ),
            ),
            Expanded(
                child: SvgPicture.asset(
              SVGs.tito,
            ))
          ],
        ),
      ),
    );
  }
}
