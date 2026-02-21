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
      : assert(pathName != null || actionWidget != null),
        assert(icon != null || iconData != null,
            'Either icon or iconData must be provided');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () {
            if (pathName != null && actionWidget == null) {
              context.pushNamed(pathName!);
            }
          },
      child: Container(
        constraints: BoxConstraints(minHeight: 30.h),
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        child: Row(
          children: [
            Container(
                padding: EdgeInsets.all(5.r),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: AppColors.borderColor,
                  ),
                ),
                child: iconData != null
                    ? Icon(
                        iconData,
                        size: 20.sp,
                        color: AppColors.primaryColor,
                      )
                    : TayssirIcon(icon: icon!)),
            10.horizontalSpace,
            subTitle != null
                ? Column(
                    children: [
                      Text(title),
                      Text(subTitle!),
                    ],
                  )
                : Text(title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.normal,
                    )),
            const Spacer(),
            actionWidget != null
                ? actionWidget!
                : const Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                  ),
          ],
        ),
      ),
    );
  }
}
