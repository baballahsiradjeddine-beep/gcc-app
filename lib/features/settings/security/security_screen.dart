import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/common/sliver_scrolling_widget.dart';
import 'package:tayssir/features/settings/notifications/setting_option_header.dart';
import 'package:tayssir/features/settings/security/security_option_widget.dart';
import 'package:tayssir/resources/resources.dart';

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
    return AppScaffold(
      paddingB: 0,
      body: SliverScrollingWidget(
        children: [
          const SettingOptionHeader(title: AppStrings.security),
          30.verticalSpace,
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
