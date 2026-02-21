import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/features/settings/widgets/custom_switch_button.dart';

class TayssirNotificationSwitch extends StatelessWidget {
  const TayssirNotificationSwitch(
      {super.key,
      required this.text,
      required this.value,
      required this.onChanged});

  final String text;
  final bool value;
  final Function(bool) onChanged;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          CustomSwitchButton(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
