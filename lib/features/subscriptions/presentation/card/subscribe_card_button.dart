// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tayssir/common/push_buttons/pushable_button.dart';
import 'package:tayssir/resources/resources.dart';

class SubscribeCardButton extends StatelessWidget {
  const SubscribeCardButton(
      {super.key,
      required this.controller,
      required this.hasError,
      this.price = 2500});
  // final String cardNumber;
  // final ValueChanged<String> onChanged;
  final TextEditingController controller;
  final bool hasError;
  final int price;
  @override
  Widget build(BuildContext context) {
    return PushableButton(
      height: 160.h,
      elevation: 7,
      onPressed: null,
      hasBorder: false,
      hslColor: HSLColor.fromColor(const Color(0XFF175DC7)),
      borderRadius: 20,
      hslDisabledColor: HSLColor.fromColor(const Color(0XFF175DC7)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(
          20,
          15,
          20,
          10,
        ),
        decoration: const BoxDecoration(
          //gradiant
          gradient: LinearGradient(
            colors: [
              Color(0XFF175DC7),
              Color(0XFF00C4F6),
            ],
          ),
          //RADIUS
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'بطاقة تيسير :',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SvgPicture.asset(
                  SVGs.latestLogo,
                )
              ],
            ),
            5.verticalSpace,
            // text of 2500 da
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                // '2500 دج',
                // convert to price
                '${price.toStringAsFixed(0)} دج',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            10.verticalSpace,

            Container(
              height: 35.h,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                textAlignVertical: TextAlignVertical.center,
                keyboardType: TextInputType.number,
                maxLength: 12,
                onChanged: (value) {
                  controller.text = value;
                },
                style: TextStyle(
                    color: hasError ? Colors.red : Colors.black,
                    fontSize: 16,
                    letterSpacing: 10),
                textAlign: TextAlign.center,
                controller: controller,
                decoration: const InputDecoration(
                  counterText: '',
                  contentPadding: EdgeInsets.only(bottom: 10),
                  border: InputBorder.none,
                  hintText: 'أدخل رقم البطاقة',
                  hintStyle: TextStyle(
                      color: Colors.grey, fontSize: 14, letterSpacing: 1),
                ),
              ),
            ),
            // 10.verticalSpace,
            const Spacer(),
            //مع تيسيير الباك في الجيب Sur! 🚀✨
            Align(
              alignment: Alignment.center,
              child: Text(
                'مع تيسيير الباك في الجيب Sur! 🚀✨',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
