// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

class CardPatternPainter extends CustomPainter {
  final Color color;

  CardPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Draw some curved lines for decoration
    final path = Path();

    // Bottom right corner decoration
    path.moveTo(size.width * 0.7, size.height);
    path.quadraticBezierTo(
        size.width * 0.8, size.height * 0.8, size.width, size.height * 0.7);

    // Top left corner decoration
    path.moveTo(0, size.height * 0.3);
    path.quadraticBezierTo(
        size.width * 0.2, size.height * 0.2, size.width * 0.3, 0);

    canvas.drawPath(path, paint);

    // Draw some dots
    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.2), 4, dotPaint);
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.8), 4, dotPaint);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.3), 2, dotPaint);
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.6), 2, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
