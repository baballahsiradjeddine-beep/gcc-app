import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/common/sliver_scrolling_widget.dart';
import 'package:tayssir/features/settings/notifications/setting_option_header.dart';
import 'package:tayssir/features/settings/notifications/tayssir_notification_switch.dart';

import '../../../constants/strings.dart';

class TayssirNotificationOption {
  final String title;
  final bool value;
  final Function(bool) onChanged;

  TayssirNotificationOption({
    required this.title,
    required this.value,
    required this.onChanged,
  });
}

final notificationProvider = Provider<List<TayssirNotificationOption>>((ref) {
  return [
    TayssirNotificationOption(
      title: AppStrings.dailyReminder,
      value: true,
      onChanged: (value) {
        // ref.read(notificationProvider).state = value;
      },
    ),
    TayssirNotificationOption(
      title: AppStrings.dailyReminder,
      value: true,
      onChanged: (value) {},
    ),
    TayssirNotificationOption(
      title: AppStrings.dailyReminder,
      value: true,
      onChanged: (value) {},
    ),
  ];
});

class NotificationScreen extends HookConsumerWidget {
  const NotificationScreen({
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScaffold(
      paddingB: 0,
      body: SliverScrollingWidget(
        children: [
          const SettingOptionHeader(title: AppStrings.notifications),
          20.verticalSpace,
          ...ref.watch(notificationProvider).map((option) {
            return TayssirNotificationSwitch(
              text: option.title,
              value: option.value,
              onChanged: option.onChanged,
            );
          }),
        ],
      ),
    );
  }
}
