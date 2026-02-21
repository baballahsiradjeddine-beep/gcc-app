import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UnitCredentialsWidget extends StatelessWidget {
  const UnitCredentialsWidget({
    super.key,
    this.name,
    required this.upperText,
  });

  final String? name;
  final String upperText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          upperText,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (name != null) ...[
          5.verticalSpace,
          Text(
            name!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ]
      ],
    );
  }
}
