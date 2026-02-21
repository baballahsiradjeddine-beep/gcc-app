import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OptionSelection extends StatelessWidget {
  const OptionSelection(
      {super.key,
      required this.iconPath,
      required this.text,
      required this.onPressed,
      required this.isSelected});
  final String iconPath;
  final String text;
  final Function() onPressed;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    bool isNetworkicon =
        iconPath.startsWith('http') || iconPath.startsWith('https');
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onPressed,
      child: Container(
        height: 50.h,
        padding: EdgeInsets.all(14.r),
        margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xffECF6FF) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                isSelected ? const Color(0xffBEE0FF) : const Color(0xffEEEEEE),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FittedBox(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            isNetworkicon
                ? SvgPicture.network(
                    iconPath,
                    height: 20.h,
                  )
                : SvgPicture.asset(
                    iconPath,
                    height: 20.h,
                  ),
          ],
        ),
      ),
    );
  }
}
