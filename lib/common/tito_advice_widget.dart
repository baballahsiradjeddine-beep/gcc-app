import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tayssir/resources/resources.dart';
import 'package:tayssir/utils/extensions/context.dart';

import 'tito_bubble_talk_widget.dart';
import '../utils/enums/triangle_side.dart';

class TitoAdviceWidget extends StatelessWidget {
  const TitoAdviceWidget({
    super.key,
    required this.text,
    this.isHorizontal = true,
    this.size,
  });

  final String text;
  final double? size;
  final bool isHorizontal;
  @override
  Widget build(BuildContext context) {
    Widget buildTito() {
      if (isHorizontal) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: TitoBubbleTalkWidget(
                text: text,
                triangleSide: TriangleSide.left,
              ),
            ),
            SvgPicture.asset(
              SVGs.titoLogin,
              height: size == null
                  //TODO
                  ? context.isSmallDevice
                      ? 110.h
                      : 110.h
                  : size!,
            ),
          ],
        );
      } else {
        return Column(
          children: [
            TitoBubbleTalkWidget(
              text: text,
              triangleSide: TriangleSide.bottom,
            ),
            Padding(
              padding: EdgeInsets.only(right: 25.w),
              child: SvgPicture.asset(
                SVGs.titoLogin,
                height: size == null
                    ? context.isSmallDevice
                        ? 150.h
                        : 190.h
                    : size!,
              ),
            ),
          ],
        );
      }
    }

    return buildTito();
  }
}
