import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onPressed;
  final Color? color;

  const OnboardingButton({
    super.key,
    required this.label,
    required this.enabled,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? const Color(0xFF00B4D8);

    return GestureDetector(
      onTap: enabled ? onPressed : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        height: 58.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: enabled ? buttonColor : const Color(0xFF1E293B),
          border: Border.all(
            color: enabled ? buttonColor : const Color(0xFF334155),
            width: 2,
          ),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: buttonColor.withOpacity(0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  )
                ]
              : [],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: enabled ? Colors.white : const Color(0xFF475569),
              fontSize: 18.sp,
              fontWeight: FontWeight.w900,
              fontFamily: 'SomarSans',
            ),
          ),
        ),
      ),
    )
        .animate(target: enabled ? 1 : 0)
        .scale(begin: const Offset(0.97, 0.97), end: const Offset(1, 1));
  }
}
