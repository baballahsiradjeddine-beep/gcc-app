// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

class StrokeText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final Color strokeColor;
  final double strokeWidth;
  const StrokeText({
    super.key,
    required this.text,
    required this.fontSize,
    required this.fontWeight,
    required this.color,
    required this.strokeColor,
    required this.strokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: strokeColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        // foreground: Paint()
        // ..strokeWidth = strokeWidth
        // ..color = strokeColor

        // ..strokeCap = StrokeCap.
        // ..strokeJoin = StrokeJoin.miter
        // ..strokeMiterLimit = 10
        // ..style = PaintingStyle.stroke,
      ),
    );
    // Stack(
    //   children: [
    //     Text(
    //       text,
    //       style: TextStyle(
    //         fontSize: fontSize,
    //         fontWeight: fontWeight,
    //         // foreground: Paint()
    //         // ..color = color
    //         color: color,
    //       ),
    //     ),
    //     Text(
    //       text,
    //       style: TextStyle(
    //         fontSize: fontSize,
    //         fontWeight: fontWeight,
    //         foreground: Paint()
    //           ..strokeWidth = strokeWidth
    //           ..color = strokeColor
    //           // ..strokeCap = StrokeCap.
    //           // ..strokeJoin = StrokeJoin.miter
    //           // ..strokeMiterLimit = 10
    //           ..style = PaintingStyle.stroke,
    //       ),
    //     ),
    //   ],
    // );
  }
}
