import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/core/shield_badge.dart';
import 'package:tayssir/providers/special_effect/special_effect_provider.dart';
import 'package:tayssir/providers/user/user_notifier.dart';
import 'package:tayssir/router/app_router.dart';

class ProfileButton extends ConsumerWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userNotifierProvider).asData?.value;
    if (user == null) return const SizedBox.shrink();

    final badgeIconUrl = user.badge?.iconUrl;
    final badgeColor = user.badge?.color;
    final themeColor = badgeColor != null
        ? Color(int.parse(badgeColor.replaceAll('#', '0xFF')))
        : const Color(0xFF2DD4BF);

    return GestureDetector(
      onTap: () {
        ref.read(specialEffectServiceProvider).playEffects();
        context.pushNamed(AppRoutes.achievementLog.name);
      },
      child: ShieldBadge(
        userAvatarUrl: user.completeProfilePic,
        badgeIconUrl: badgeIconUrl,
        themeColor: themeColor,
        width: 72,
        height: 90,
        avatarPaddingTop: 20,
        avatarSize: 60,
        avatarOffsetX: -1.5,
      ),
    );
  }
}
