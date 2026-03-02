import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/resources/colors/app_colors.dart';

import '../utils/enums/triangle_side.dart';

class SpeechBubblePainter extends CustomPainter {
  final TriangleSide triangleSide;

  SpeechBubblePainter({this.triangleSide = TriangleSide.right});

  @override
  void paint(Canvas canvas, Size size) {
    double bubbleWidth = size.width - 20.w;
    double bubbleHeight = size.height - 20.h;
    double borderRadius = 14.r;
    double triangleSize = 10.w;

    var fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke;

    var borderPaint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.w;

    var path = Path();
    var borderPath = Path();

    switch (triangleSide) {
      case TriangleSide.top:
        path.addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(10.w, 10.h + triangleSize, bubbleWidth,
              bubbleHeight - triangleSize),
          Radius.circular(borderRadius),
        ));
        path.moveTo(size.width / 2 - triangleSize, 10.h + triangleSize);
        path.lineTo(size.width / 2 + triangleSize, 10.h + triangleSize);
        path.lineTo(size.width / 2, 10.h);
        path.close();

        borderPath.moveTo(10.w + borderRadius, 10.h + triangleSize);
        borderPath.lineTo(
            bubbleWidth + 10.w - borderRadius, 10.h + triangleSize);
        borderPath.arcToPoint(
            Offset(bubbleWidth + 10.w, 10.h + triangleSize + borderRadius),
            radius: Radius.circular(borderRadius));
        borderPath.lineTo(bubbleWidth + 10.w, bubbleHeight + 10.h);
        borderPath.arcToPoint(
            Offset(bubbleWidth + 10.w - borderRadius, bubbleHeight + 10.h),
            radius: Radius.circular(borderRadius));
        borderPath.lineTo(10.w + borderRadius, bubbleHeight + 10.h);
        borderPath.arcToPoint(Offset(10.w, bubbleHeight + 10.h - borderRadius),
            radius: Radius.circular(borderRadius));
        borderPath.lineTo(10.w, 10.h + triangleSize + borderRadius);
        borderPath.arcToPoint(Offset(10.w + borderRadius, 10.h + triangleSize),
            radius: Radius.circular(borderRadius));

        borderPath.moveTo(size.width / 2 - triangleSize, 10.h + triangleSize);
        borderPath.lineTo(size.width / 2, 10.h);
        borderPath.lineTo(size.width / 2 + triangleSize, 10.h + triangleSize);
        break;

      case TriangleSide.bottom:
        path.addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(10.w, 10.h, bubbleWidth, bubbleHeight - triangleSize),
          Radius.circular(borderRadius),
        ));
        path.moveTo(size.width / 2 - triangleSize, bubbleHeight + 10.h);
        path.lineTo(size.width / 2 + triangleSize, bubbleHeight + 10.h);
        path.lineTo(size.width / 2, bubbleHeight + 10.h + triangleSize);
        path.close();

        borderPath.moveTo(10.w + borderRadius, 10.h);
        borderPath.lineTo(bubbleWidth + 10.w - borderRadius, 10.h);
        borderPath.arcToPoint(Offset(bubbleWidth + 10.w, 10.h + borderRadius),
            radius: Radius.circular(borderRadius));
        borderPath.lineTo(
            bubbleWidth + 10.w, bubbleHeight + 10.h - borderRadius);
        borderPath.arcToPoint(
            Offset(bubbleWidth + 10.w - borderRadius, bubbleHeight + 10.h),
            radius: Radius.circular(borderRadius));
        borderPath.lineTo(size.width / 2 + triangleSize, bubbleHeight + 10.h);
        borderPath.moveTo(size.width / 2 - triangleSize, bubbleHeight + 10.h);
        borderPath.lineTo(10.w + borderRadius, bubbleHeight + 10.h);
        borderPath.arcToPoint(Offset(10.w, bubbleHeight + 10.h - borderRadius),
            radius: Radius.circular(borderRadius));
        borderPath.lineTo(10.w, 10.h + borderRadius);
        borderPath.arcToPoint(Offset(10.w + borderRadius, 10.h),
            radius: Radius.circular(borderRadius));

        borderPath.moveTo(size.width / 2 - triangleSize, bubbleHeight + 10.h);
        borderPath.lineTo(size.width / 2, bubbleHeight + 10.h + triangleSize);
        borderPath.lineTo(size.width / 2 + triangleSize, bubbleHeight + 10.h);
        break;
      //TODO: fix content not centered issue
      case TriangleSide.left:
        path.addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(10.w + triangleSize, 10.h, bubbleWidth - triangleSize,
              bubbleHeight),
          Radius.circular(borderRadius),
        ));
        path.moveTo(10.w + triangleSize, size.height / 2 - triangleSize);
        path.lineTo(10.w + triangleSize, size.height / 2 + triangleSize);
        path.lineTo(10.w, size.height / 2);
        path.close();

        borderPath.moveTo(10.w + triangleSize, size.height / 2 - triangleSize);
        borderPath.lineTo(10.w + triangleSize, 10.h + borderRadius);
        borderPath.arcToPoint(Offset(10.w + triangleSize + borderRadius, 10.h),
            radius: Radius.circular(borderRadius));
        borderPath.lineTo(bubbleWidth + 10.w - borderRadius, 10.h);
        borderPath.arcToPoint(Offset(bubbleWidth + 10.w, 10.h + borderRadius),
            radius: Radius.circular(borderRadius));
        borderPath.lineTo(
            bubbleWidth + 10.w, bubbleHeight + 10.h - borderRadius);
        borderPath.arcToPoint(
            Offset(bubbleWidth + 10.w - borderRadius, bubbleHeight + 10.h),
            radius: Radius.circular(borderRadius));
        borderPath.lineTo(
            10.w + triangleSize + borderRadius, bubbleHeight + 10.h);
        borderPath.arcToPoint(
            Offset(10.w + triangleSize, bubbleHeight + 10.h - borderRadius),
            radius: Radius.circular(borderRadius));
        borderPath.lineTo(10.w + triangleSize, size.height / 2 + triangleSize);

        borderPath.moveTo(10.w + triangleSize, size.height / 2 - triangleSize);
        borderPath.lineTo(10.w, size.height / 2);
        borderPath.lineTo(10.w + triangleSize, size.height / 2 + triangleSize);
        break;

      case TriangleSide.right:
        path.addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(10.w, 10.h, bubbleWidth - triangleSize, bubbleHeight),
          Radius.circular(borderRadius),
        ));
        path.moveTo(bubbleWidth + 10.w, size.height / 2 - triangleSize);
        path.lineTo(bubbleWidth + 10.w, size.height / 2 + triangleSize);
        path.lineTo(bubbleWidth + 10.w + triangleSize, size.height / 2);
        path.close();

        borderPath.moveTo(10.w + borderRadius, 10.h);
        borderPath.lineTo(bubbleWidth + 10.w - borderRadius, 10.h);
        borderPath.arcToPoint(Offset(bubbleWidth + 10.w, 10.h + borderRadius),
            radius: Radius.circular(borderRadius));
        borderPath.lineTo(bubbleWidth + 10.w, size.height / 2 - triangleSize);

        borderPath.moveTo(bubbleWidth + 10.w, size.height / 2 + triangleSize);
        borderPath.lineTo(
            bubbleWidth + 10.w, bubbleHeight + 10.h - borderRadius);
        borderPath.arcToPoint(
            Offset(bubbleWidth + 10.w - borderRadius, bubbleHeight + 10.h),
            radius: Radius.circular(borderRadius));
        borderPath.lineTo(10.w + borderRadius, bubbleHeight + 10.h);
        borderPath.arcToPoint(Offset(10.w, bubbleHeight + 10.h - borderRadius),
            radius: Radius.circular(borderRadius));
        borderPath.lineTo(10.w, 10.h + borderRadius);
        borderPath.arcToPoint(Offset(10.w + borderRadius, 10.h),
            radius: Radius.circular(borderRadius));

        borderPath.moveTo(bubbleWidth + 10.w, size.height / 2 - triangleSize);
        borderPath.lineTo(bubbleWidth + 10.w + triangleSize, size.height / 2);
        borderPath.lineTo(bubbleWidth + 10.w, size.height / 2 + triangleSize);
        break;
    }

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(borderPath, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
// class ResponsiveTextWidget extends StatelessWidget {
//   final String text;

//   const ResponsiveTextWidget({
//     super.key,
//     required this.text,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         double fontSize = constraints.maxWidth * 0.05;
//         double padding = constraints.maxWidth * 0.05;

//         return Padding(
//           padding: EdgeInsets.all(padding),
//           child: Container(
//             padding: EdgeInsets.all(padding),
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.blue),
//             ),
//             child: Center(
//               child: FittedBox(
//                 fit: BoxFit.scaleDown,
//                 child: Text(
//                   text,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: fontSize,
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
