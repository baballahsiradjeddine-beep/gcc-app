import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/common/core/app_scaffold.dart';

class BacsLoadingView extends StatelessWidget {
  const BacsLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return AppScaffold(
      includeBackButton: true,
      topSafeArea: true,
      paddingX: 20.w,
      bodyBackgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: Text(
        'مواضيع البكالوريا 🎓',
        style: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.w900,
          color: isDark ? Colors.white : const Color(0xFF1E293B),
          fontFamily: 'SomarSans',
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 40.w,
              height: 40.w,
              child: const CircularProgressIndicator(
                color: Color(0xFF00B4D8),
                strokeWidth: 3,
              ),
            ),
            24.verticalSpace,
            Text(
              'جاري تحضير المواضيع...',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.black54,
                fontFamily: 'SomarSans',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
