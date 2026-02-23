import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:tayssir/constants/app_consts.dart';
import 'package:tayssir/features/auth/presentation/login/login_controller.dart';
import 'package:tayssir/features/auth/presentation/register/state/register_controller.dart';
import 'package:tayssir/providers/google/google_sign_in.dart';
import 'package:tayssir/resources/resources.dart';

class SocialRows extends ConsumerWidget {
  const SocialRows({super.key, this.isLogin = true});
  final bool isLogin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final googleSignIn = ref.watch(googleSignInProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (googleSignIn.supportsAuthenticate())
          GestureDetector(
            onTap: () async {
              final res = await googleSignIn.authenticate();
              // final auth = await res.authorizationClient.authorizationForScopes(
              //   ['email', 'https://www.googleapis.com/auth/contacts.readonly'],
              // );
              // AppLogger.logInfo(
              //     'Google Sign-In result: ${res.authentication.idToken}');

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
            child: SvgPicture.asset(
              SVGs.icGoogle,
              height: 30.h,
            ),
          ),
        if (AppConsts.isDebug) ...[
          10.horizontalSpace,
          IconButton(
              onPressed: () async {
                final credential = await SignInWithApple.getAppleIDCredential(
                  scopes: [
                    AppleIDAuthorizationScopes.email,
                    AppleIDAuthorizationScopes.fullName,
                  ],
                );
                inspect(credential);
              },
              iconSize: 50,
              icon: const Icon(
                Icons.apple,
                color: Colors.black,
              )),
        ]
      ],
    );
  }
}
