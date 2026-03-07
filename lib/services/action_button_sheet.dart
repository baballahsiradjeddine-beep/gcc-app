import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/resources/colors/app_colors.dart';

class ActionButtonSheet extends StatelessWidget {
  const ActionButtonSheet(
      {super.key,
      required this.title,
      required this.message,
      required this.actions});

  final String title;
  final String message;
  // final List<Widget> actions;
  final Widget actions;
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark 
                ? const Color(0xFF1E293B) 
                : AppColors.surfaceWhite.withOpacity(0.95),
            // radius top
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 30,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.greyColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              20.verticalSpace,
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              10.verticalSpace,
              Divider(
                color: Colors.grey[200],
              ),
              10.verticalSpace,
              // message
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : AppColors.textBlack,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'SomarSans',
                ),
              ),
              10.verticalSpace,
              Divider(
                color: Colors.grey[200],
              ),

              10.verticalSpace,
              actions
            ],
          ),
        ));
  }
}
