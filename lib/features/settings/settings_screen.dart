import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:tayssir/common/app_buttons/logout_button.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/common/core/custom_app_bar.dart';
import 'package:tayssir/common/tayssir_icon.dart';
import 'package:tayssir/constants/app_consts.dart';
import 'package:tayssir/features/settings/widgets/custom_switch_button.dart';
import 'package:tayssir/features/settings/widgets/settings_item.dart';
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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return AppScaffold(
      topSafeArea: true,
      extendBody: true,
      bodyBackgroundColor: Colors.transparent,
      paddingX: 0,
      paddingB: 0,
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          // App Bar
          SliverToBoxAdapter(
              child: const CustomAppBar(showActions: false, showLogo: false),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 8.h), // This acts as the margin bottom
          ),

          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                15.verticalSpace,
                Text(
                  AppStrings.settings,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                    fontFamily: 'SomarSans',
                  ),
                ),
                15.verticalSpace,

                // Account Section
                _buildSectionHeader(isDark, 'الحساب'),
                SettingsItem(
                  title: AppStrings.personalInformations,
                  pathName: AppRoutes.profile.name,
                  icon: SVGs.icPerson,
                ),
                SettingsItem(
                  title: AppStrings.security,
                  pathName: AppRoutes.security.name,
                  icon: SVGs.icSecurity,
                ),
                15.verticalSpace,

                // Preferences Section
                _buildSectionHeader(isDark, 'التفضيلات'),
                const SettingsItem(
                  title: AppStrings.audioEffects,
                  actionWidget: AudioSoundSwitchButton(),
                  icon: SVGs.icSound,
                ),
                15.verticalSpace,

                // Support Section
                _buildSectionHeader(isDark, 'الدعم والتواصل'),
                SettingsItem(
                  title: 'قيم التطبيق',
                  onTap: () => requestReview(),
                  iconData: Icons.star_rounded,
                ),
                SettingsItem(
                  title: AppStrings.contactUs,
                  pathName: AppRoutes.contactUs.name,
                  icon: SVGs.icPhone,
                ),
                15.verticalSpace,

                // About Us Card
                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9), // Slate-100 instead of blue.shade50
                    borderRadius: BorderRadius.circular(24.r),
                    border: Border.all(
                      color: isDark ? Colors.white10 : const Color(0xFFE2E8F0), // Slate-200
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.favorite_rounded,
                        color: Colors.redAccent,
                        size: 28.sp,
                      ),
                      12.verticalSpace,
                      Text(
                        'نحن فريق صغير من المطورين',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF1E293B),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      8.verticalSpace,
                      Text(
                        'لأي مشكلة أو استفسار، يرجى التواصل معنا. هذا سيساعدنا كثيراً، وشكراً لدعمكم.',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: isDark ? Colors.white60 : Colors.black54,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      20.verticalSpace,
                      Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialIcon(SVGs.telegram, () => _launchUrl(AppConsts.telegramLink, context), isDark),
                  20.horizontalSpace,
                  _buildSocialIcon(SVGs.instagram, () => _launchUrl(AppConsts.instagramLink, context), isDark),
                  20.horizontalSpace,
                  _buildSocialIcon(SVGs.youtube, () => _launchUrl(AppConsts.youtubeLink, context), isDark),
                ],
              ),
                    ],
                  ),
                ),

                12.verticalSpace,
                const LogoutButton(),
                140.verticalSpace,
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(bool isDark, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, right: 4.w),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white38 : const Color(0xFF64748B), // Slate-500
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSocialIcon(String svg, VoidCallback onTap, bool isDark) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF334155) : Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: SvgPicture.asset(
          svg,
          width: 24.w,
          height: 24.h,
        ),
      ),
    );
  }
}
