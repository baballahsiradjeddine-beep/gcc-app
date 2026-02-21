import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCheckMark extends StatelessWidget {
  const CustomCheckMark({
    super.key,
    required this.color,
    this.icon = Icons.check,
  });

  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 27.w,
      height: 25.h,
      margin: EdgeInsets.only(left: 5.w),
      // padding: EdgeInsets.all(2.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Center(
        child: Icon(
          icon,
          color: color,
          size: 18.sp,
        ),
      ),
    );
  }
}
