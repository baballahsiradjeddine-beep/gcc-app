import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ShieldBadge extends StatelessWidget {
  final String? userAvatarUrl;
  final ImageProvider? localAvatarImage;
  final String? badgeIconUrl;
  final Color themeColor;
  final double width;
  final double height;
  final double avatarPaddingTop;
  final double avatarSize;

  const ShieldBadge({
    super.key,
    this.userAvatarUrl,
    this.localAvatarImage,
    this.badgeIconUrl,
    required this.themeColor,
    required this.width,
    required this.height,
    required this.avatarPaddingTop,
    required this.avatarSize,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // User Avatar (Bottom Layer)
          ClipPath(
            clipper: _ShieldClipper(),
            child: Container(
              width: width,
              height: height,
              color: Colors.white,
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(top: avatarPaddingTop),
              child: Container(
                width: avatarSize,
                height: avatarSize,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: localAvatarImage != null
                      ? Image(image: localAvatarImage!, fit: BoxFit.cover)
                      : (userAvatarUrl != null
                          ? CachedNetworkImage(
                              imageUrl: userAvatarUrl!,
                              fit: BoxFit.cover,
                            )
                          : const SizedBox.shrink()),
                ),
              ),
            ),
          ),

          // Badge Design (Top Layer)
          if (badgeIconUrl != null)
            CachedNetworkImage(
              imageUrl: badgeIconUrl!,
              width: width,
              height: height,
              fit: BoxFit.contain,
            )
          else
            // Fallback Shield Paint
            Center(
              child: CustomPaint(
                size: Size(width * 0.9, height * 0.9),
                painter: _ShieldPainter(color: themeColor),
              ),
            ),
        ],
      ),
    );
  }
}

class _ShieldClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width * 0.15, size.height * 0.08);
    path.quadraticBezierTo(
        size.width * 0.5, 0, size.width * 0.85, size.height * 0.08);
    path.lineTo(size.width * 0.92, size.height * 0.7);
    path.quadraticBezierTo(
        size.width * 0.5, size.height * 0.98, size.width * 0.08, size.height * 0.7);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _ShieldPainter extends CustomPainter {
  final Color color;
  _ShieldPainter({required this.color});

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
    path.moveTo(size.width * 0.15, size.height * 0.08);
    path.quadraticBezierTo(
        size.width * 0.5, 0, size.width * 0.85, size.height * 0.08);
    path.lineTo(size.width * 0.92, size.height * 0.7);
    path.quadraticBezierTo(
        size.width * 0.5, size.height * 0.98, size.width * 0.08, size.height * 0.7);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
