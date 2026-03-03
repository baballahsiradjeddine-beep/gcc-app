import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/features/home/presentation/view_style.dart';

import 'change_view_widget.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.viewStyle,
    this.title = 'المواد المتاحة',
  });

  final ValueNotifier<ViewStyle> viewStyle;
  final String title;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 6.w,
              height: 22.h,
              decoration: BoxDecoration(
                color: const Color(0xFF00B4D8),
                borderRadius: BorderRadius.circular(3.r),
              ),
            ),
            10.horizontalSpace,
            Text(
              '$title :',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w900,
                fontFamily: 'SomarSans',
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
          ],
        ),
        ChangeViewWidget(viewStyle: viewStyle),
      ],
    );
  }
}
