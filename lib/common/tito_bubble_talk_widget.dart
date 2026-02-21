import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/utils/enums/triangle_side.dart';
import 'package:tayssir/resources/colors/app_colors.dart';

import 'speech_bubble_painter.dart';

final triangleSideProvider =
    StateProvider<TriangleSide>((ref) => TriangleSide.left);

class TitoBubbleTalkWidget extends ConsumerWidget {
  const TitoBubbleTalkWidget({
    super.key,
    required this.text,
    required this.triangleSide,
  });

  final String text;
  final TriangleSide triangleSide;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final triangleSide = ref.watch(triangleSideProvider);
    return CustomPaint(
      // size: Size(300.w, 10.h),
      painter: SpeechBubblePainter(
        triangleSide: triangleSide,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 30.w,
          vertical: 20.h,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.darkColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
