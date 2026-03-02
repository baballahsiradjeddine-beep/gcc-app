import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tayssir/common/tayssir_icon.dart';
import 'package:tayssir/resources/colors/app_colors.dart';

class SettingsItem extends StatelessWidget {
  final String title;
  final String? subTitle;
  final String? pathName;
  final String? icon;
  final Widget? actionWidget;
  final IconData? iconData;
  final VoidCallback? onTap;
  const SettingsItem(
      {super.key,
      required this.title,
      this.subTitle,
      this.pathName,
      this.onTap,
      this.icon,
      this.iconData,
      this.actionWidget})
      : assert(pathName != null || actionWidget != null || onTap != null),
        assert(icon != null || iconData != null,
            'Either icon or iconData must be provided');

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap ??
          () {
            if (pathName != null && actionWidget == null) {
              context.pushNamed(pathName!);
            }
          },
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black26 : Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.02),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: isDark 
                    ? AppColors.primaryColor.withOpacity(0.15) 
                    : AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: iconData != null
                  ? Icon(
                      iconData,
                      size: 22.sp,
                      color: AppColors.primaryColor,
                    )
                  : TayssirIcon(
                      icon: icon!,
                      size: 22.sp,
                    ),
            ),
            16.horizontalSpace,
            Expanded(
              child: subTitle != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          subTitle!,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: isDark ? Colors.white60 : Colors.black45,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                      ),
                    ),
            ),
            if (actionWidget != null)
              actionWidget!
            else
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16.sp,
                color: isDark ? Colors.white38 : Colors.grey.shade400,
              ),
          ],
        ),
      ),
    );
  }
}
