import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/push_buttons/pushable_button.dart';
import 'package:tayssir/providers/token/token_controller.dart';

class LogoutButton extends ConsumerWidget {
  const LogoutButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PushableButton(
      height: 30,
      elevation: 7,
      borderRadius: 30,
      hasBorder: false,
      hslColor: HSLColor.fromColor(const Color(0xffF85556)),
      onPressed: () {
        ref.read(tokenProvider.notifier).clearToken();
      },
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'تسجيل الخروج',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            5.horizontalSpace,
            const Icon(
              Icons.logout,
              color: Colors.white,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}
