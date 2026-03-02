import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeaderText extends StatelessWidget {
  final String text;
  
  const HeaderText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: isDark ? Colors.white : const Color(0xFF1E293B), // Slate-800
        fontSize: 28.sp,
        fontWeight: FontWeight.w900,
        fontFamily: 'SomarSans',
        letterSpacing: -0.5,
      ),
    );
  }
}
