import 'package:flutter/material.dart';

class GesturePatternPainter extends CustomPainter {
  final List<Offset> points;

  GesturePatternPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(GesturePatternPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

class UserGestures {
  bool detectZShape(points) {
    if (points.length < 3) return false;

    // Split points into 3 parts: beginning, middle, and end
    int oneThird = (points.length / 3).floor();
    List<Offset> start = points.sublist(0, oneThird);
    List<Offset> middle = points.sublist(oneThird, 2 * oneThird);
    List<Offset> end = points.sublist(2 * oneThird);

    // Detect horizontal movement in start (left to right)
    bool horizontalStart = start.last.dx > start.first.dx &&
        (start.last.dy - start.first.dy).abs() < 30;

    // Detect diagonal movement in middle (top-right to bottom-left)
    bool diagonalMiddle = middle.first.dx > middle.last.dx &&
        middle.last.dy > middle.first.dy &&
        (middle.first.dx - middle.last.dx).abs() > 50 &&
        (middle.last.dy - middle.first.dy).abs() > 50;

    // Detect horizontal movement in end (left to right)
    bool horizontalEnd = end.last.dx > end.first.dx &&
        (end.last.dy - end.first.dy).abs() < 30;

    return horizontalStart && diagonalMiddle && horizontalEnd;
  }
}