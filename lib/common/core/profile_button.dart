import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tayssir/common/push_buttons/rounded_pushable_button.dart';
import 'package:tayssir/constants/app_consts.dart';
import 'package:tayssir/providers/special_effect/special_effect_provider.dart';
import 'package:tayssir/providers/user/user_notifier.dart';
import 'package:tayssir/router/app_router.dart';

class ProfileButton extends ConsumerWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userNotifierProvider);
    final user = userAsync.asData?.value;

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
      child: SizedBox(
        width: 64,
        height: 80,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // User Avatar (Bottom Layer)
            Positioned(
              top: 20,
              child: ClipPath(
                clipper: _ShieldClipper(),
                child: Container(
                  width: 54,
                  height: 54,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: user.completeProfilePic,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),

            // Badge Design (Top Layer)
            if (badgeIconUrl != null)
              Positioned(
                top: 0,
                child: CachedNetworkImage(
                  imageUrl: badgeIconUrl,
                  width: 60,
                  height: 75,
                  fit: BoxFit.contain,
                ),
              )
            else
              // Mini Shield Fallback
              Center(
                child: CustomPaint(
                  size: const Size(56, 65),
                  painter: _MiniShieldPainter(color: themeColor),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MiniShieldPainter extends CustomPainter {
  final Color color;
  _MiniShieldPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withOpacity(0.8), color],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width * 0.1, size.height * 0.1);
    path.quadraticBezierTo(size.width * 0.5, 0, size.width * 0.9, size.height * 0.1);
    path.lineTo(size.width, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.5, size.height, 0, size.height * 0.7);
    path.lineTo(size.width * 0.1, size.height * 0.1);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _ShieldClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.82);
    path.lineTo(size.width * 0.5, size.height);
    path.lineTo(0, size.height * 0.82);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
