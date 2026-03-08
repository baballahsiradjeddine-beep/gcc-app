import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/common/sliver_scrolling_widget.dart';
import 'package:tayssir/features/settings/notifications/setting_option_header.dart';
import 'package:tayssir/resources/resources.dart';

import 'package:go_router/go_router.dart';
import 'package:tayssir/common/tayssir_icon.dart';
import 'package:tayssir/resources/colors/app_colors.dart';
import 'package:tayssir/router/app_router.dart';
import '../../../constants/strings.dart';

enum ChangeType {
  phone,
  email,
  password,
}

class TayssirSecurityOption {
  final String title;
  final String iconUrl;
  final ChangeType changeType;
  TayssirSecurityOption({
    required this.title,
    required this.iconUrl,
    required this.changeType,
  });
}

final securityOptionProvider = Provider<List<TayssirSecurityOption>>((ref) {
  return [
    // TayssirSecurityOption(
    //   title: AppStrings.changePhoneNumber,
    //   iconUrl: SVGs.icPhone,
    //   changeType: ChangeType.phone,
    // ),
    TayssirSecurityOption(
      title: AppStrings.changeEmail,
      iconUrl: SVGs.icPhilo,
      changeType: ChangeType.email,
    ),
    TayssirSecurityOption(
      title: AppStrings.changePassword,
      iconUrl: SVGs.icBox,
      changeType: ChangeType.password,
    ),
  ];
});

class SecurityScreen extends HookConsumerWidget {
  const SecurityScreen({
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppScaffold(
      includeBackButton: true,
      topSafeArea: true,
      paddingB: 0,
      appBar: Text(
        AppStrings.security + ' 🔐',
        style: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.w900,
          color: isDark ? Colors.white : AppColors.textBlack,
          fontFamily: 'SomarSans',
        ),
      ),
      body: SliverScrollingWidget(
        children: [
          12.verticalSpace,
          ...ref.watch(securityOptionProvider).map((option) {
            return SecurityOptionWidget(
              option: option,
            );
          }),
        ],
      ),
    );
  }
}

class SecurityOptionWidget extends HookConsumerWidget {
  final TayssirSecurityOption option;
  const SecurityOptionWidget({
    super.key,
    required this.option,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        //*bad practice
        if (option.changeType == ChangeType.password) {
          context.pushNamed(AppRoutes.resetPassword.name);
          return;
        }
        context.pushNamed(AppRoutes.changeEmail.name);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black26 : Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.02),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.primaryColor.withOpacity(0.15)
                    : AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: TayssirIcon(
                icon: option.iconUrl,
                size: 22.sp,
              ),
            ),
            16.horizontalSpace,
            Expanded(
              child: Text(
                option.title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                  fontFamily: 'SomarSans',
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16.sp,
              color: isDark ? Colors.white38 : Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
