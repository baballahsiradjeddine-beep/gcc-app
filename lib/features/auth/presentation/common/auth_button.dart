import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/app_buttons/big_button.dart';
import 'package:tayssir/constants/strings.dart';

class AuthButton extends ConsumerWidget {
  const AuthButton({
    super.key,
    this.isLogin = true,
    required this.onPressed,
  });
  final bool isLogin;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BigButton(
      text: isLogin ? AppStrings.login : AppStrings.createAccount,
      onPressed: onPressed,
    );
  }
}
