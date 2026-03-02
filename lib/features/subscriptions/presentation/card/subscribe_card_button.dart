import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tayssir/resources/resources.dart';

class SubscribeCardButton extends StatelessWidget {
  const SubscribeCardButton({
    super.key,
    required this.controller,
    required this.hasError,
    this.price = 2500,
  });

  final TextEditingController controller;
  final bool hasError;
  final int price;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00B4D8), Color(0xFF005B8C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00B4D8).withOpacity(0.35),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background Glow
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [Colors.white.withOpacity(0.15), Colors.transparent],
                ),
              ),
            ),
          ),
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'SomarSans',
                      ),
                      children: [
                        const TextSpan(text: "Tay", style: TextStyle(color: Colors.white)),
                        TextSpan(text: "ssir", style: TextStyle(color: Colors.white.withOpacity(0.8))),
                      ],
                    ),
                  ),
                  Text(
                    'بطاقة تيسير',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SomarSans',
                    ),
                  ),
                ],
              ),
              
              20.verticalSpace,
              
              Text(
                '$price دج',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'SomarSans',
                  letterSpacing: 1.2,
                  shadows: [Shadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))]
                ),
              ),
              
              24.verticalSpace,
              
              // Input Field for Card Number
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))
                  ],
                ),
                child: TextField(
                  controller: controller,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 12,
                  style: TextStyle(
                    color: hasError ? Colors.red : const Color(0xFF1E293B),
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 8,
                    fontFamily: 'SomarSans',
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: "- - - - - - - - - - - -",
                    hintStyle: TextStyle(
                      color: const Color(0xFFCBD5E1),
                      fontSize: 18.sp,
                      letterSpacing: 4,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              
              16.verticalSpace,
              
              Center(
                child: Text(
                  'مع تيسير الباك في الجيب Sur! ✨🚀',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SomarSans',
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
