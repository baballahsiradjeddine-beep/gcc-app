import 'package:flutter/material.dart';
import '../../../../common/app_buttons/big_button.dart';

class CheckButton extends StatelessWidget {
  const CheckButton({super.key, this.onPressed, this.text});
  final Function()? onPressed;
  final String? text;
  @override
  Widget build(BuildContext context) {
    return BigButton(
      onPressed: onPressed,
      text: text ?? 'تحقق',
    );
  }
}
