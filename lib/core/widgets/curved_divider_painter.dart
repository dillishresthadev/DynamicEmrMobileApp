import 'package:flutter/material.dart';

class CurvedDividerPainter extends CustomPainter {
  final Color color;

  CurvedDividerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final path = Path();

    path.quadraticBezierTo(
      size.width / 2,
      50, // Control point
      size.width,
      0, // End point
    );

    // Close the path
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
