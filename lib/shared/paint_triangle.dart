import 'package:flutter/material.dart';

// used for sign-in and register page design
class TrianglePainter1 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
    ..color = Colors.amberAccent // handles color of line
    ..strokeWidth = 5; // handles width of line

    final path = Path();
    path.moveTo(size.width * 0.50, size.height * 0.05);
    path.lineTo(size.width * 0.02, size.height * 0.95);
    path.lineTo(size.width * 0.98, size.height * 0.95);
    path.close();

    canvas.drawPath(path, paint);

  }

  // to prevent repainting of widget, true if doing animation
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class TrianglePainter2 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
    ..color = Colors.yellowAccent // handles color of line
    ..strokeWidth = 5; // handles width of line

    final path = Path();
    path.moveTo(size.width * 0.50, size.height * 0.05);
    path.lineTo(size.width * 0.02, size.height * 0.95);
    path.lineTo(size.width * 0.98, size.height * 0.95);
    path.close();

    canvas.drawPath(path, paint);

  }

  // to prevent repainting of widget, true if doing animation
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}