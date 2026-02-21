import 'package:flutter/material.dart';

class CircularProgress extends CustomPainter {
  final double percentage;
  final Color color;

  CircularProgress({required this.percentage, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint backgroundPaint = Paint()
      ..color = const Color(0xffEEEEEE)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    final Paint progressPaint = Paint()
      ..color = color
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double radius = size.width / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(center, radius, backgroundPaint);

    double sweepAngle = (2 * 3.141592653589793) * (percentage / 100);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.141592653589793 / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
