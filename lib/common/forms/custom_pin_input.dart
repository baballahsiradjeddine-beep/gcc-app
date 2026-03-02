import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:tayssir/resources/colors/app_colors.dart';

class CustomPinInput extends StatelessWidget {
  const CustomPinInput({
    super.key,
    required this.pinController,
    this.onChanged,
    required this.isError,
    required this.isSubmitted,
  });

  final TextEditingController pinController;
  final Function? onChanged;
  final bool isError;
  final bool isSubmitted;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final defaultPinTheme = PinTheme(
      width: 54.w,
      height: 64.h,
      textStyle: TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.w900,
        color: isDark ? Colors.white : const Color(0xFF1E293B),
        fontFamily: 'SomarSans',
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        border: Border.all(color: AppColors.primaryColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 0,
          )
        ],
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.5), width: 1.5),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        border: Border.all(color: const Color(0xFFF43F5E), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF43F5E).withOpacity(0.1),
            blurRadius: 10,
          )
        ],
      ),
    );

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Pinput(
        length: 6,
        controller: pinController,
        defaultPinTheme: defaultPinTheme,
        focusedPinTheme: focusedPinTheme,
        submittedPinTheme: submittedPinTheme,
        errorPinTheme: errorPinTheme,
        forceErrorState: isError,
        errorText: 'رمز التحقق غير صحيح',
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        onChanged: (val) {
          if (onChanged != null) onChanged!();
        },
      ),
    );
  }
}
