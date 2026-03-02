import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/features/units/widgets/animated_circular_progress_widget.dart';

class UnitCircleProgressWidget extends StatelessWidget {
  const UnitCircleProgressWidget({
    super.key,
    required this.progress,
    this.color = const Color(0xffF037A5),
    this.size = 65,
    this.padding = 4,
    this.borderWidth = 4,
  });
  final double progress;
  final Color color;
  final double size;
  final double padding;
  final double borderWidth;
  @override
  Widget build(BuildContext context) {
    return AnimatedCircularProgressWidget(
      color: color,
      percentage: progress,
      size: size.w,
      borderWidth: borderWidth.w,
      padding: padding,
      showText: true,
      showImageIcon: false,
      animationDuration: const Duration(milliseconds: 1500),
      showPercentage: false,
    );
  }
}
