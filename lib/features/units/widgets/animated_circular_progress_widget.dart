import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shimmer/shimmer.dart';

class AnimatedCircularProgressWidget extends StatelessWidget {
  const AnimatedCircularProgressWidget({
    super.key,
    required this.color,
    required this.percentage,
    this.imageUrl,
    this.isLocked = false,
    this.showPercentage = false,
    this.size = 65,
    this.borderWidth = 4.0,
    this.padding = 2.0, // Added padding parameter
    this.animationDuration = const Duration(milliseconds: 1000),
    this.onTap,
    this.showImageIcon = true,
    this.showText = false,
  });

  final Color color;
  final double percentage;
  final String? imageUrl;
  final bool isLocked;
  final bool showPercentage;
  final double size;
  final double borderWidth;
  final double padding; // New padding property
  final Duration animationDuration;
  final VoidCallback? onTap;
  final bool showImageIcon;
  final bool showText;

  @override
  Widget build(BuildContext context) {
    // Determine the complete Image URL
    String fullImageUrl = '';
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      fullImageUrl = imageUrl!.startsWith('http') 
          ? imageUrl! 
          : 'https://gcc.tayssir-bac.com/storage/${imageUrl!.replaceAll(RegExp(r'^/'), '')}';
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: CircularPercentIndicator(
          radius: size / 2,
        lineWidth: borderWidth,
        percent: percentage / 100,
        backgroundColor: const Color(0xffEEEEEE),
        progressColor: color,
        circularStrokeCap: CircularStrokeCap.round,
        animation: true,
        animationDuration: animationDuration.inMilliseconds,
        center: Container(
          width: size - (2 * borderWidth), // Outer diameter minus its borders 
          height: size - (2 * borderWidth),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          padding: EdgeInsets.all(padding), // Move the padding here onto the white background
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Image or placeholder
              fullImageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: fullImageUrl,
                      imageBuilder: (context, imageProvider) => Container(
                        width: size - (2 * borderWidth) - (2 * padding),
                        height: size - (2 * borderWidth) - (2 * padding),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                            colorFilter: isLocked
                                ? const ColorFilter.matrix([
                                    0.2126,
                                    0.7152,
                                    0.0722,
                                    0,
                                    0,
                                    0.2126,
                                    0.7152,
                                    0.0722,
                                    0,
                                    0,
                                    0.2126,
                                    0.7152,
                                    0.0722,
                                    0,
                                    0,
                                    0,
                                    0,
                                    0,
                                    1,
                                    0,
                                  ])
                                : null,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => Center(
                        child: Container(
                          width: size - (2 * borderWidth) - (2 * padding),
                          height: size - (2 * borderWidth) - (2 * padding),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[300],
                          ),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: size - (2 * borderWidth) - (2 * padding),
                              height: size - (2 * borderWidth) - (2 * padding),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    )
                  : Container(
                      width: size - (2 * borderWidth) - (2 * padding),
                      height: size - (2 * borderWidth) - (2 * padding),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: showImageIcon
                          ? Icon(
                              Icons.image,
                              color: percentage >= 0.99 ? color : Colors.grey,
                              size: (size - (2 * borderWidth) - (2 * padding)) /
                                  3,
                            )
                          : showText
                              ? Center(
                                  child: Text(
                                    percentage == 100
                                        ? '100'
                                        : '${percentage.toStringAsFixed(0)}%',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : null),
              // Lock overlay for locked items - adjusted for padding
              if (isLocked)
                Container(
                  width: size - (2 * borderWidth) - (2 * padding),
                  height: size - (2 * borderWidth) - (2 * padding),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        Colors.black.withOpacity(0.3), // Fixed withValues
                  ),
                  child: Icon(
                    Icons.lock,
                    color: Colors.white,
                    size: (size - (2 * borderWidth) - (2 * padding)) / 4,
                  ),
                ),

              // Percentage text overlay - adjusted for padding
              if (showPercentage)
                Container(
                  width: size - (2 * borderWidth) - (2 * padding),
                  height: size - (2 * borderWidth) - (2 * padding),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        Colors.black.withOpacity(0.3), // Fixed withValues
                  ),
                  child: Center(
                    child: Text(
                      percentage >= 0.995
                          ? "100%"
                          : "${(percentage * 100).toInt()}%",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize:
                            (size - (2 * borderWidth) - (2 * padding)) / 5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
