import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tayssir/resources/colors/app_colors.dart';

class OptionSelection extends StatelessWidget {
  final String? iconPath;
  final IconData? iconData;
  final String text;
  final String? subText;
  final VoidCallback onPressed;
  final bool isSelected;
  final Color? activeColor;
  final Color? accentColor;

  const OptionSelection({
    super.key,
    this.iconPath,
    this.iconData,
    required this.text,
    this.subText,
    required this.onPressed,
    required this.isSelected,
    this.activeColor,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color effectiveActiveColor = activeColor ?? const Color(0xFF00B4D8);
    final Color effectiveAccentColor = accentColor ?? const Color(0xFFEC4899);

    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: isDark ? (isSelected ? effectiveActiveColor.withOpacity(0.08) : const Color(0xFF1E293B)) : (isSelected ? effectiveActiveColor.withOpacity(0.08) : Colors.white),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? effectiveActiveColor : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: effectiveActiveColor.withOpacity(0.12),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ] : [
            BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.2 : 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4)
            )
          ],
        ),
        child: Stack(
          children: [
            // Pink Accent Line for specific methods (if needed)
            if (accentColor != null)
              Positioned(
                top: 0,
                bottom: 0,
                right: -16.w, 
                child: Container(
                  width: 6.w,
                  decoration: BoxDecoration(
                    color: effectiveAccentColor,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(20.r), bottomRight: Radius.circular(20.r)),
                  ),
                ),
              ),
              
            Row(
              children: [
                // Icon/Graphics
                Container(
                  width: 44.r,
                  height: 44.r,
                  decoration: BoxDecoration(
                    color: isSelected ? effectiveActiveColor.withOpacity(0.1) : (isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9)),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: iconData != null
                        ? Icon(iconData, color: isSelected ? effectiveActiveColor : Colors.blueGrey, size: 24.sp)
                        : (iconPath != null 
                            ? (iconPath!.startsWith('http') 
                                ? Image.network(iconPath!, width: 24.w, height: 24.h, color: isSelected ? effectiveActiveColor : Colors.blueGrey)
                                : Image.asset(iconPath!, width: 24.w, height: 24.h, color: isSelected ? effectiveActiveColor : Colors.blueGrey))
                            : Icon(Icons.payment, color: isSelected ? effectiveActiveColor : Colors.blueGrey)),
                  ),
                ),
                
                16.horizontalSpace,
                
                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: TextStyle(
                          color: isDark ? Colors.white : const Color(0xFF1E293B),
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'SomarSans',
                        ),
                      ),
                      if (subText != null) ...[
                        4.verticalSpace,
                        Text(
                          subText!,
                          style: TextStyle(
                            color: isDark ? Colors.blueGrey.shade400 : Colors.blueGrey.shade500,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SomarSans',
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Radio Indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 22.r,
                  height: 22.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? effectiveActiveColor : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                      width: 2,
                    ),
                    color: isSelected ? effectiveActiveColor : Colors.transparent,
                    boxShadow: isSelected ? [BoxShadow(color: effectiveActiveColor.withOpacity(0.35), blurRadius: 10)] : [],
                  ),
                  child: isSelected 
                    ? const Center(child: Icon(Icons.check, color: Colors.white, size: 12)) 
                    : null,
                ),
              ],
            ),
          ],
        ),
      ).animate(target: isSelected ? 1 : 0)
        .scale(begin: const Offset(1, 1), end: const Offset(1.02, 1.02), duration: 200.ms),
    );
  }
}
