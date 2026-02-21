import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/debug/app_logger.dart';
import 'package:tayssir/providers/user/user_notifier.dart';

import 'custom_bottom_nav_bar_widget.dart';

class MainScaffold extends HookConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const MainScaffold({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String getTabName(int index) {
      switch (index) {
        case 0:
          return 'أدوات';
        case 1:
          return 'ترتيب';
        case 2:
          return 'تعلم';
        case 3:
          return 'تحديات';
        case 4:
          return 'إعدادات';
        default:
          return '';
      }
    }

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: CustomBottomNavBarWidget(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          AppLogger.sendLog(
            email: ref.watch(userNotifierProvider).requireValue!.email,
            type: LogType.subscriptions,
            content: 'Selected tab: ${getTabName(index)}',
          );
          navigationShell.goBranch(
            index,
            initialLocation: navigationShell.currentIndex == index,
          );
        },
      ),
    );
  }
}
