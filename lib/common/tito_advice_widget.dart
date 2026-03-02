import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'tito_bubble_talk_widget.dart';
import '../utils/enums/triangle_side.dart';

class TitoAdviceWidget extends StatelessWidget {
  const TitoAdviceWidget({
    super.key,
    required this.text,
    this.isHorizontal = true,
    this.size,
  });

  final String text;
  final double? size;
  final bool isHorizontal;

  @override
  Widget build(BuildContext context) {
    if (isHorizontal) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: TitoBubbleTalkWidget(
              text: text,
              triangleSide: TriangleSide.left,
            ),
          ),
          8.horizontalSpace,
          _buildTito(40.sp),
        ],
      );
    } else {
      return Column(
        children: [
          TitoBubbleTalkWidget(
            text: text,
            triangleSide: TriangleSide.bottom,
          ),
          8.verticalSpace,
          _buildTito(60.sp),
        ],
      );
    }
  }

  Widget _buildTito(double emojiSize) {
    return Text(
      "🐬",
      style: TextStyle(fontSize: emojiSize),
    )
    .animate(onPlay: (controller) => controller.repeat())
    .moveY(begin: -5, end: 5, duration: 2.seconds, curve: Curves.easeInOutSine);
  }
}
