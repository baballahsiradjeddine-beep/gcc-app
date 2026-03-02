import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/core/hexagon_clipper.dart';
import 'package:tayssir/common/core/shield_badge.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tayssir/providers/special_effect/special_effect_provider.dart';
import 'package:tayssir/providers/user/user_notifier.dart';
import 'package:tayssir/resources/colors/app_colors.dart';
import 'package:tayssir/router/app_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileButton extends ConsumerWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userNotifierProvider).asData?.value;
    if (user == null) return const SizedBox.shrink();
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final badgeColor = user.badge?.color as String?;
    final themeColor = badgeColor != null
        ? Color(int.parse(badgeColor.replaceAll('#', '0xFF')))
        : const Color(0xFF2DD4BF);
    final badgeIconUrl = user.badge?.completeIconUrl as String?;

    return GestureDetector(
      onTap: () {
        ref.read(specialEffectServiceProvider).playEffects();
        context.pushNamed(AppRoutes.achievementLog.name);
      },
      child: ShieldBadge(
        userAvatarUrl: user.completeProfilePic,
        badgeIconUrl: badgeIconUrl,
        themeColor: themeColor,
        width: 82.w, // Increased from 72.w to make it more visible
        height: 102.h,
        avatarPaddingTop: 26.h,
        avatarSize: 68.sp, // Scaled up
        avatarOffsetX: -1.5.w,
      ).animate().scale(begin: const Offset(0.9, 0.9), delay: 200.ms),
    );
  }
}

class _HexagonBorder extends ShapeBorder {
  final BorderSide side;

  const _HexagonBorder({this.side = BorderSide.none});

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(side.width);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return _getPath(rect.deflate(side.width));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return _getPath(rect);
  }

  Path _getPath(Rect rect) {
    final Path path = Path();
    path.moveTo(rect.center.dx, rect.top);
    path.lineTo(rect.right, rect.top + rect.height * 0.25);
    path.lineTo(rect.right, rect.top + rect.height * 0.75);
    path.lineTo(rect.center.dx, rect.bottom);
    path.lineTo(rect.left, rect.top + rect.height * 0.75);
    path.lineTo(rect.left, rect.top + rect.height * 0.25);
    path.close();
    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (side.style == BorderStyle.solid) {
      canvas.drawPath(getOuterPath(rect), side.toPaint());
    }
  }

  @override
  ShapeBorder scale(double t) => _HexagonBorder(side: side.scale(t));
}
