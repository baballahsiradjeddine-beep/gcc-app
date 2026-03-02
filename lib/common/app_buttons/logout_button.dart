import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/providers/token/token_controller.dart';

class LogoutButton extends ConsumerWidget {
  const LogoutButton({
    super.key,
  });

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
        title: Text(
          'تسجيل الخروج',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'SomarSans',
            fontWeight: FontWeight.w900,
            fontSize: 20.sp,
            color: isDark ? Colors.white : const Color(0xFF1E293B),
          ),
        ),
        content: Text(
          'هل أنت متأكد أنك تريد تسجيل الخروج من حسابك؟',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'SomarSans',
            fontSize: 15.sp,
            color: isDark ? Colors.white70 : Colors.black87,
          ),
        ),
        actionsPadding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      side: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade200),
                    ),
                  ),
                  child: Text(
                    'إلغاء',
                    style: TextStyle(
                      fontFamily: 'SomarSans',
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white60 : Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
              12.horizontalSpace,
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ref.read(tokenProvider.notifier).clearToken();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF43F5E),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  child: Text(
                    'خروج',
                    style: TextStyle(
                      fontFamily: 'SomarSans',
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => _showLogoutDialog(context, ref),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: isDark ? Colors.redAccent.withOpacity(0.1) : const Color(0xFFFFF1F2),
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: isDark ? Colors.redAccent.withOpacity(0.2) : const Color(0xFFFECDD3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout_rounded,
              color: const Color(0xFFF43F5E),
              size: 20.sp,
            ),
            12.horizontalSpace,
            Text(
              'تسجيل الخروج',
              style: TextStyle(
                color: const Color(0xFFF43F5E),
                fontSize: 16.sp,
                fontWeight: FontWeight.w900,
                fontFamily: 'SomarSans',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
