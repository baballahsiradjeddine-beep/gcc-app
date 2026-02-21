import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/features/units/widgets/animated_circular_progress_widget.dart';
import 'package:tayssir/features/units/widgets/unit_circle_progress_widget.dart';
import 'package:tayssir/features/units/widgets/unit_credentials_widget.dart';
import 'circular_progress_widget.dart';

class TayssirProgressWidget extends StatelessWidget {
  const TayssirProgressWidget(
      {super.key,
      this.name,
      required this.upperText,
      required this.progress,
      this.direction = TextDirection.rtl});

  final String? name;
  final String upperText;
  final double progress;
  final TextDirection direction;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: direction,
      child: Container(
        padding: EdgeInsets.only(
          right: direction == TextDirection.rtl ? 20 : 2,
          left: direction == TextDirection.rtl ? 2 : 20,
          top: 1,
          bottom: 1,
        ),
        decoration: BoxDecoration(
          color: const Color(0xffF037A5),
          borderRadius: direction == TextDirection.rtl
              ? const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  bottomLeft: Radius.circular(40),
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                )
              : const BorderRadius.only(
                  topRight: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
        ),
        child: Row(
          children: [
            Expanded(
                child: UnitCredentialsWidget(name: name, upperText: upperText)),
            UnitCircleProgressWidget(
              progress: progress,
            ),
          ],
        ),
      ),
    );
  }
}
