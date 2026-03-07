import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';

class SuccessCard extends StatelessWidget {
  final String subjectName;
  final String duration;
  final VoidCallback onShare;
  final VoidCallback onClose;

  const SuccessCard({
    super.key, 
    required this.subjectName, 
    required this.duration,
    required this.onShare,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(30.w),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30.r),
              border: Border.all(color: const Color(0xFF00B4D8), width: 2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00B4D8).withOpacity(0.2),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.network(
                  'https://assets10.lottiefiles.com/packages/lf20_toufyc92.json',
                  height: 150.h,
                  repeat: false,
                ),
                
                Text(
                  "إنجاز مبهر! 🏆",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'SomarSans',
                  ),
                ),
                
                15.verticalSpace,
                
                Text(
                  "لقد أتممت تحدي $duration في مادة $subjectName بنجاح على تطبيق بيان! 🔥",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFFCBD5E1),
                    fontSize: 16.sp,
                    fontFamily: 'SomarSans',
                    height: 1.5,
                  ),
                ),
                
                30.verticalSpace,
                
                GestureDetector(
                  onTap: () {
                    Share.share(
                      "لقد أتممت تحدي $duration في مادة $subjectName بنجاح على تطبيق بيان! 🔥 حمل التطبيق الآن وابدأ دراستك بالذكاء الاصطناعي.",
                      subject: "إنجاز جديد على تطبيق بيان!",
                    );
                    onShare();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                      ),
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.share, color: Colors.white),
                        10.horizontalSpace,
                        Text(
                          "شارك الإنجاز",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SomarSans',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                10.verticalSpace,
                
                TextButton(
                  onPressed: onClose,
                  child: Text(
                    "إغلاق",
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ],
            ),
          ).animate().scale(curve: Curves.elasticOut, duration: 800.ms),
          
          // Confetti overlay could go here
        ],
      ),
    );
  }
}
