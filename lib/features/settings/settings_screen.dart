import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:tayssir/common/app_buttons/logout_button.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/common/sliver_scrolling_widget.dart';
import 'package:tayssir/constants/app_consts.dart';
import 'package:tayssir/features/settings/widgets/custom_switch_button.dart';
import 'package:tayssir/features/settings/widgets/settings_item.dart';
import 'package:tayssir/resources/colors/app_colors.dart';
import 'package:tayssir/router/app_router.dart';
import 'package:tayssir/services/actions/snack_bar_service.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/strings.dart';
import '../../resources/resources.dart';

class SettingsScreen extends HookConsumerWidget {
  const SettingsScreen({
    super.key,
  });

  Future<void> requestReview() async {
    final InAppReview inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      try {
        inAppReview.openStoreListing();
        // inAppReview.requestReview();
      } catch (e) {}
    }
  }

  // use launcher to open url
  Future<void> _launchUrl(String url, BuildContext context) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!context.mounted) return;

      SnackBarService.showErrorToast(
        'Could not launch the app. Please install it or try another method.',
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScaffold(
      paddingB: 0,
      body: SliverScrollingWidget(
        children: [
          10.verticalSpace,
          Text(
            AppStrings.settings,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          10.verticalSpace,
          SettingsItem(
            title: AppStrings.personalInformations,
            pathName: AppRoutes.profile.name,
            icon: SVGs.icPerson,
          ),
          // SettingsItem(
          //   title: AppStrings.notifications,
          //   pathName: AppRoutes.notifcations.name,
          //   icon: SVGs.notification,
          // ),
          SettingsItem(
            title: AppStrings.security,
            pathName: AppRoutes.security.name,
            icon: SVGs.icSecurity,
          ),
          // SettingsItem(
          //   title: AppStrings.aboutApp,
          //   pathName: AppRoutes.security.name,
          //   icon: SVGs.icTime,
          // ),
          // SettingsItem(
          //   title: AppStrings.version,
          //   pathName: AppRoutes.security.name,
          //   icon: SVGs.icTime,
          // ),
          // 20.verticalSpace,
          const SettingsItem(
            title: AppStrings.audioEffects,
            actionWidget: AudioSoundSwitchButton(),
            icon: SVGs.icSound,
          ),
          SettingsItem(
            title: 'قيم التطبيق',
            onTap: () {
              requestReview();
            },
            actionWidget: GestureDetector(
                onTap: () {},
                child: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                )),
            iconData: Icons.star,
          ),
          SettingsItem(
            title: AppStrings.contactUs,
            pathName: AppRoutes.contactUs.name,
            icon: SVGs.icPhone,
          ),
          20.verticalSpace,
          if (true)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade100.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.favorite,
                    color: AppColors.primaryColor,
                    size: 24.sp,
                  ),
                  8.verticalSpace,
                  Text(
                    'نحن فريق صغير من المطورين ',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  4.verticalSpace,
                  Text(
                    'لأي مشكلة أو استفسار، يرجى التواصل معنا',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  4.verticalSpace,
                  Text(
                    'هذا سيساعدنا كثيراً، وشكراً لدعمكم',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          10.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: SvgPicture.asset(
                  SVGs.telegram,
                  width: 32.w,
                  height: 32.h,
                ),
                onPressed: () {
                  _launchUrl(AppConsts.telegramLink, context);
                },
              ),
              IconButton(
                icon: SvgPicture.asset(
                  SVGs.instagram,
                  width: 32.w,
                  height: 32.h,
                ),
                onPressed: () {
                  _launchUrl(AppConsts.instagramLink, context);
                },
              ),
              IconButton(
                icon: SvgPicture.asset(
                  SVGs.youtube,
                  width: 32.w,
                  height: 32.h,
                ),
                onPressed: () {
                  _launchUrl(AppConsts.youtubeLink, context);
                },
              ),
            ],
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 70),
            child: LogoutButton(),
          ),
          30.verticalSpace,
        ],
      ),
    );
  }
}
