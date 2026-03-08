import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/resources/colors/app_colors.dart';

class SubjectWidget extends HookConsumerWidget {
  const SubjectWidget({
    super.key,
    required this.subjectName,
    required this.subjectGrade,
    required this.subjectCoef,
    required this.onGradeChange,
  });

  final String subjectName;
  final double subjectGrade;
  final int subjectCoef;
  final Function(double) onGradeChange;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController(
      text: subjectGrade == 0 ? '' : subjectGrade.toString(),
      keys: [subjectName],
    );

    final isDark = Theme.of(context).brightness == Brightness.dark;

    void correctValue(String decimal, String value) {
      final decimalValue = int.tryParse(decimal) ?? 0;
      if (decimalValue < 25) {
        controller.text = '${value.split('.')[0]}.0';
      } else if (decimalValue < 50) {
        controller.text = '${value.split('.')[0]}.25';
      } else if (decimalValue < 75) {
        controller.text = '${value.split('.')[0]}.5';
      } else {
        controller.text = '${value.split('.')[0]}.75';
      }
    }

    bool validateField(String value) {
      if (value.isNotEmpty) {
        final double? val = double.tryParse(value);
        if (val == null || val > 20 || val < 0) {
          controller.clear();
          return false;
        }
        if (value.contains('.')) {
          final parts = value.split('.');
          if (parts.length > 1) {
            final decimal = parts[1];
            if (decimal != '25' && decimal != '5' && decimal != '75' && decimal != '0' && decimal != '50') {
              correctValue(decimal, value);
              return false;
            }
          }
        }
      }
      return true;
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFE2E8F0),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Subject Name
            Expanded(
              flex: 4,
              child: Text(
                subjectName,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'SomarSans',
                  color: isDark ? Colors.white : AppColors.textBlack,
                ),
              ),
            ),
            
            // Coefficient (Small Circle) - Neutral Gray-Blue
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                color: (isDark ? Colors.white : AppColors.primaryColor).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  subjectCoef.toString(),
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white70 : AppColors.primaryColor,
                  ),
                ),
              ),
            ),
            
            12.horizontalSpace,
            
            // Grade Input - Smaller Height
            SizedBox(
              width: 55.w,
              height: 34.h,
              child: TextFormField(
                controller: controller,
                textAlign: TextAlign.center,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.next,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryColor,
                  fontFamily: 'SomarSans',
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                decoration: InputDecoration(
                  hintText: '0',
                  hintStyle: TextStyle(color: isDark ? Colors.white10 : Colors.black12),
                  contentPadding: EdgeInsets.zero,
                  filled: true,
                  fillColor: isDark ? Colors.black.withOpacity(0.2) : const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: const BorderSide(color: AppColors.primaryColor, width: 1.5),
                  ),
                ),
                onFieldSubmitted: (value) {
                  if (validateField(value) && value.isNotEmpty) {
                    onGradeChange(double.parse(value));
                  }
                },
                onTapOutside: (_) {
                   if (validateField(controller.text) && controller.text.isNotEmpty) {
                    onGradeChange(double.parse(controller.text));
                  }
                },
              ),
            ),
            
            10.horizontalSpace,
            
            // Total (Grade * Coef)
            Container(
              width: 45.w,
              height: 34.h,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      (subjectGrade * subjectCoef).toStringAsFixed(1).replaceAll('.0', ''),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
