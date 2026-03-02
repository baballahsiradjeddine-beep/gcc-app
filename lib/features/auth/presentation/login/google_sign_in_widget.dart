import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/features/auth/presentation/login/login_controller.dart';
import 'package:tayssir/features/auth/presentation/register/state/register_controller.dart';
import 'package:tayssir/providers/google/google_sign_in.dart';
import 'package:tayssir/resources/resources.dart';

class GoogleSignInWidget extends ConsumerWidget {
  final bool isLogin;

  const GoogleSignInWidget({
    super.key,
    required this.isLogin,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final googleSignIn = ref.watch(googleSignInProvider);
    if (!googleSignIn.supportsAuthenticate()) return const SizedBox.shrink();
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.r),
          onTap: () async {
            final res = await googleSignIn.authenticate();
            if (isLogin) {
              ref.read(loginControllerProvider.notifier).loginWithGoogle(
                    idToken: res.authentication.idToken!,
                  );
            } else {
              ref.read(registerControllerProvider.notifier).googleSignUp(
                    res.authentication.idToken!,
                    res.displayName ?? '',
                    res.email,
                  );
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               SvgPicture.asset(
                SVGs.icGoogle,
                height: 24.h,
              ),
              12.horizontalSpace,
              Text(
                'المتابعة باستخدام Google',
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF334155),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SomarSans',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
