import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuestionWidget extends StatelessWidget {
  const QuestionWidget({
    super.key,
    this.startColor = const Color(0xffFFC447),
    this.endColor = const Color(0xffF9AB05),
    this.onTap,
  });

  final Color startColor;
  final Color endColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!.call();
        }
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              startColor,
              endColor,
            ],
          ),
          // circle with radius
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.question_mark_outlined,
          color: Colors.white,
          size: 20.sp,
        ),
      ),
    );
  }
}
