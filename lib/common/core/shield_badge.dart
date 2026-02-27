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
  final double avatarOffsetX;

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
    this.avatarOffsetX = 0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // 1. Bottom Layer: Theme Color filling the back of the shield hole
          ClipPath(
            clipper: _ShieldClipper(),
            child: Container(
              width: width,
              height: height,
              color: themeColor,
            ),
          ),

          // 2. Middle Layer: User Avatar (Circular)
          Transform.translate(
            offset: Offset(avatarOffsetX, 0),
            child: Container(
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
                      : (userAvatarUrl != null && userAvatarUrl!.trim().isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: userAvatarUrl!.startsWith('http') 
                                ? userAvatarUrl! 
                                : 'https://gcc.tayssir-bac.com/storage/${userAvatarUrl!.replaceAll(RegExp(r'^/'), '')}',
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => const Icon(Icons.person),
                              placeholder: (context, url) => const CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.person)),
                ),
              ),
            ),
          ),

          // 3. Top Layer: Shield Badge PNG
          if (badgeIconUrl != null && badgeIconUrl!.trim().isNotEmpty)
            CachedNetworkImage(
              imageUrl: badgeIconUrl!.startsWith('http') 
                ? badgeIconUrl! 
                : 'https://gcc.tayssir-bac.com/storage/${badgeIconUrl!.replaceAll(RegExp(r'^/'), '')}',
              width: width,
              height: height,
              fit: BoxFit.contain,
              errorWidget: (context, url, error) => const SizedBox.shrink(),
              placeholder: (context, url) => const SizedBox.shrink(),
            )
          else
            // Fallback Shield Paint
            IgnorePointer(
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
    // This is strictly an "underlay" clip path for the background color. 
    // It is narrowed at the top (0.25 to 0.75) and starts lower (0.18) 
    // to guarantee it hides perfectly beneath the shield's curved top/shoulders.
    path.moveTo(size.width * 0.25, size.height * 0.18);
    path.quadraticBezierTo(
        size.width * 0.5, size.height * 0.15, size.width * 0.75, size.height * 0.18);
    
    // Spreads outwards to safely cover the full width of the circular avatar hole
    path.lineTo(size.width * 0.86, size.height * 0.60);
    
    // Curves to fill the bottom, staying safely above the pointy tip to avoid leaking 
    path.quadraticBezierTo(
        size.width * 0.5, size.height * 0.95, size.width * 0.14, size.height * 0.60);
    
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

    // The original beautiful shield curve perfectly restored for the fallback
    final path = Path();
    path.moveTo(size.width * 0.15, size.height * 0.08);
    path.quadraticBezierTo(
        size.width * 0.5, size.height * 0.03, size.width * 0.85, size.height * 0.08);
    path.lineTo(size.width * 0.92, size.height * 0.7);
    path.quadraticBezierTo(
        size.width * 0.5, size.height * 0.98, size.width * 0.08, size.height * 0.7);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
