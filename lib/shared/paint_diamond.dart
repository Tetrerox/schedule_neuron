import 'package:flutter/material.dart';

// used for sign-in and register page design
class DiamondPainter1 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
    ..color = Colors.limeAccent // handles color of line
    ..strokeWidth = 5; // handles width of line

    final path = Path();
    path.moveTo(size.width * 0.50, size.height * 0.15);
    path.lineTo(size.width * 0.20, size.height * 0.50);
    path.lineTo(size.width * 0.50, size.height * 0.85);
    path.lineTo(size.width * 0.80, size.height * 0.50);
    path.close();

    canvas.drawPath(path, paint);

  }

  // to prevent repainting of widget, true if doing animation
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class DiamondPainter2 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
    ..color = Colors.indigoAccent // handles color of line
    ..strokeWidth = 5; // handles width of line

    final path = Path();
    path.moveTo(size.width * 0.50, size.height * 0.15);
    path.lineTo(size.width * 0.20, size.height * 0.50);
    path.lineTo(size.width * 0.50, size.height * 0.85);
    path.lineTo(size.width * 0.80, size.height * 0.50);
    path.close();

    canvas.drawPath(path, paint);

  }

  // to prevent repainting of widget, true if doing animation
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class DiamondPainter3 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
    ..color = Colors.lightBlueAccent // handles color of line
    ..strokeWidth = 5; // handles width of line

    final path = Path();
    path.moveTo(size.width * 0.50, size.height * 0.15);
    path.lineTo(size.width * 0.20, size.height * 0.50);
    path.lineTo(size.width * 0.50, size.height * 0.85);
    path.lineTo(size.width * 0.80, size.height * 0.50);
    path.close();

    canvas.drawPath(path, paint);

  }

  // to prevent repainting of widget, true if doing animation
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}