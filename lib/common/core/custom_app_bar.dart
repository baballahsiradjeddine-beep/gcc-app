import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/common/core/profile_button.dart';
import 'package:tayssir/providers/settings/settings_provider.dart';
import 'package:tayssir/providers/user/user_notifier.dart';
import 'package:go_router/go_router.dart';
import 'package:tayssir/router/app_router.dart';
import 'app_logo.dart';

class CustomAppBar extends ConsumerWidget {
  final bool showActions;
  final bool showLogo;
  final bool reverse;
  final bool showNotifications;
  final bool showThemeToggle;
  final bool forceDarkMode;
  const CustomAppBar({
    super.key,
    this.showActions = true,
    this.showLogo = true,
    this.reverse = false,
    this.showNotifications = true,
    this.showThemeToggle = true,
    this.forceDarkMode = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final settings = ref.watch(settingsNotifierProvider);

    final user = ref.watch(userNotifierProvider).asData?.value;
    final bool isGuest = user == null;

    final Widget logo = showLogo ? const AppLogo(fontSize: 32) : const SizedBox.shrink();
    
    final Widget actions = showActions
      ? Row(
          children: reverse 
            ? [
                if (!isGuest && (showNotifications || showThemeToggle)) ...[
                  const ProfileButton(),
                  12.horizontalSpace,
                ],
                if (!isGuest && (!showNotifications && !showThemeToggle))
                  const ProfileButton(),
                // Notification Button
                if (showNotifications)
                  GestureDetector(
                    onTap: () => context.pushNamed(AppRoutes.notifcations.name),
                    child: _buildActionIcon(context, Icons.notifications_none_rounded, isDark || forceDarkMode),
                  ),
                if (showNotifications && showThemeToggle) 12.horizontalSpace,
                // Theme Toggle Button
                if (showThemeToggle)
                  GestureDetector(
                    onTap: () => ref.read(settingsNotifierProvider.notifier).toggleDarkMode(),
                    child: _buildActionIcon(
                      context, 
                      settings.isDarkMode ? Icons.wb_sunny_rounded : Icons.nightlight_round, 
                      isDark || forceDarkMode,
                      color: settings.isDarkMode ? Colors.yellow : (forceDarkMode ? Colors.white : null),
                    ),
                  ),
              ]
            : [
                 if (!isGuest) ...[
                  const ProfileButton(),
                  if (showNotifications || showThemeToggle) 12.horizontalSpace,
                ],
                // Notification Button
                if (showNotifications)
                  GestureDetector(
                    onTap: () => context.pushNamed(AppRoutes.notifcations.name),
                    child: _buildActionIcon(context, Icons.notifications_none_rounded, isDark || forceDarkMode),
                  ),
                if (showNotifications && showThemeToggle) 12.horizontalSpace,
                // Theme Toggle Button
                if (showThemeToggle)
                  GestureDetector(
                    onTap: () => ref.read(settingsNotifierProvider.notifier).toggleDarkMode(),
                    child: _buildActionIcon(
                      context, 
                      settings.isDarkMode ? Icons.wb_sunny_rounded : Icons.nightlight_round, 
                      isDark || forceDarkMode,
                      color: settings.isDarkMode ? Colors.yellow : (forceDarkMode ? Colors.white : null),
                    ),
                  ),
              ],
        )
      : const SizedBox.shrink();

    return Container(
      padding: showActions ? EdgeInsets.zero : EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: showLogo && showActions ? MainAxisAlignment.spaceBetween : (showLogo || showActions ? (reverse ? MainAxisAlignment.start : MainAxisAlignment.end) : MainAxisAlignment.center),
        children: reverse 
          ? [actions, logo]
          : [logo, actions],
      ),
    );
  }

  Widget _buildActionIcon(BuildContext context, IconData icon, bool isDark, {Color? color}) {
    return Container(
      width: 40.sp,
      height: 40.sp,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 22.sp,
        color: color ?? (isDark ? Colors.white : const Color(0xFF1E293B)),
      ),
    );
  }
}
