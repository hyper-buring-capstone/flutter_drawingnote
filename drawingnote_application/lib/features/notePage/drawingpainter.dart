import 'package:flutter/material.dart';

// Painter 클래스
class DrawingPainter extends CustomPainter {
  final List<List<Offset?>> lines;

  final Offset offset;

  DrawingPainter(this.lines, {this.offset = Offset.zero});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue.withOpacity(0.3)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0;

    for (var line in lines) {
      Path path = Path();
      path.moveTo(line[0]!.dx, line[0]!.dy);
      for (int i = 0; i < line.length - 1; i++) {
        if (line[i] != null && line[i + 1] != null) {
          path.quadraticBezierTo(
              line[i]!.dx, line[i]!.dy, line[i + 1]!.dx, line[i + 1]!.dy);
        }
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
