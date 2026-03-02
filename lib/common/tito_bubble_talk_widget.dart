import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/utils/enums/triangle_side.dart';

class TitoBubbleTalkWidget extends StatelessWidget {
  final String text;
  final TriangleSide triangleSide;

  const TitoBubbleTalkWidget({
    super.key,
    required this.text,
    required this.triangleSide,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    final Color bgColor = isDark 
        ? const Color(0xFF1E293B).withOpacity(0.8) 
        : Colors.white.withOpacity(0.8);
    final Color borderColor = isDark 
        ? const Color(0xFF334155) 
        : const Color(0xFFF1F5F9);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // Bubble Content
            ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: borderColor, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SomarSans',
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ),
            
            // Premium Tail (Square rotated 45deg)
            Positioned(
              bottom: (triangleSide == TriangleSide.bottom) ? -6.h : null,
              top: (triangleSide == TriangleSide.top) ? -6.h : null,
              left: (triangleSide == TriangleSide.left) ? -6.w : null,
              right: (triangleSide == TriangleSide.right) ? -6.w : null,
              child: Transform.rotate(
                angle: 0.785, // 45 degrees
                child: Container(
                  width: 12.w,
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: bgColor,
                    border: Border(
                      bottom: (triangleSide == TriangleSide.bottom || triangleSide == TriangleSide.right)
                          ? BorderSide(color: borderColor)
                          : BorderSide.none,
                      right: (triangleSide == TriangleSide.bottom || triangleSide == TriangleSide.right)
                          ? BorderSide(color: borderColor)
                          : BorderSide.none,
                      top: (triangleSide == TriangleSide.top || triangleSide == TriangleSide.left)
                          ? BorderSide(color: borderColor)
                          : BorderSide.none,
                      left: (triangleSide == TriangleSide.top || triangleSide == TriangleSide.left)
                          ? BorderSide(color: borderColor)
                          : BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
