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
          decoration: const BoxDecoration(
            color: Colors.white,
            // radius top
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.darkColor,
                  fontWeight: FontWeight.normal,
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
