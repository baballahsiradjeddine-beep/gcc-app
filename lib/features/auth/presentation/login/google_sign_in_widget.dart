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

    return Padding(
      padding: EdgeInsets.only(bottom: 0.h),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            padding: EdgeInsets.symmetric(vertical: 14.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            elevation: 0,
          ),
          icon: SvgPicture.asset(
            SVGs.icGoogle,
            height: 24.h,
          ),
          label: Text(
            'تسجيل الدخول باستخدام جوجل',
            style: TextStyle(fontSize: 16.sp),
          ),
          onPressed: () async {
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
        ),
      ),
    );
  }
}
