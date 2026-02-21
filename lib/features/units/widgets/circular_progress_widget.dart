import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'circular_progress.dart';

class CircularProgressWidget extends StatelessWidget {
  const CircularProgressWidget({
    super.key,
    required this.color,
    required this.percentage,
    this.child,
    // this.image/Url,
  });

  final Color color;
  final double percentage;
  final Widget? child;
  // final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CircularProgress(percentage: percentage, color: color),
      child: Container(
        width: 50.w,
        height: 50.h,
        decoration: const BoxDecoration(
          // color: Colors.black,
          shape: BoxShape.circle,
          // image: imageUrl != null
          // ? DecorationImage(
          // image: NetworkImage(imageUrl!),
          // fit: BoxFit.contain,
          // )
          // : null,
        ),
        child: Center(
            child: child ??
                Text(
                  percentage == 100
                      ? '100'
                      : '${percentage.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                )),
      ),
    );
  }
}

class SimpleCircularProgressWidget extends StatelessWidget {
  const SimpleCircularProgressWidget({
    super.key,
    required this.color,
    required this.isFull,
    this.child,
    this.imageUrl,
    this.isLocked = false,
  });

  final Color color;
  // final double percentage;
  final Widget? child;
  final String? imageUrl;
  final bool isFull;
  final bool isLocked;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 65.w,
      height: 65.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isFull ? color : const Color(0xffEEEEEE),
          width: 4.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: imageUrl != null
                ? DecorationImage(
                    image: CachedNetworkImageProvider(imageUrl!),
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
                  )
                : null,
          ),
          child: imageUrl == null
              ? Center(
                  child: child ??
                      Icon(Icons.image, color: isFull ? color : Colors.grey),
                )
              : null,
        ),
      ),
    );
  }
}
