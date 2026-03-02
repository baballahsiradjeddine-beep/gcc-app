import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class BannerWidget extends StatelessWidget {
  final String? title;
  final String? description;
  final String actionUrl;
  final String gradientStart;
  final String gradientEnd;
  final String? image;

  const BannerWidget({
    super.key,
    this.title,
    this.description,
    required this.actionUrl,
    required this.gradientStart,
    required this.gradientEnd,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasImage = image != null;

    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(actionUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w), // maintain side gap
        height: 115.h,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: !hasImage
              ? LinearGradient(
                  colors: [
                    Color(int.parse(gradientStart.replaceFirst('#', '0xff'))),
                    Color(int.parse(gradientEnd.replaceFirst('#', '0xff'))),
                  ],
                )
              : null,
          borderRadius: BorderRadius.circular(20), // Updated to match SubscribeButton
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Dot Pattern for all banners
            Positioned.fill(
              child: Opacity(
                opacity: 0.2,
                child: CustomPaint(
                  painter: DotPatternPainter(),
                ),
              ),
            ),
            
            if (hasImage)
              Positioned.fill(child: _buildImageBanner(context))
            else
              Positioned.fill(child: _buildGradientBanner(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientBanner(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title ?? '',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
              ),
        ),
        Text(
          description ?? '',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
        ),
      ],
    );
  }

  Widget _buildImageBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        image: DecorationImage(
          image: CachedNetworkImageProvider(image!),
          fit: BoxFit.cover,
        ),
      ),
      child: title == null && description == null ||
              (description != null && description!.isEmpty)
          ? null
          : ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: .5, sigmaY: .5),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                  ),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (title != null)
                            Text(
                              title!,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                          if (description != null)
                            Text(
                              description!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.white70,
                                  ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    const spacing = 18.0;
    const radius = 1.2;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
