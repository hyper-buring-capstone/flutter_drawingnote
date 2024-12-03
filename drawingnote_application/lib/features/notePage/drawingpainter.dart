import 'package:flutter/material.dart';
import '../../datas/onelinedata.dart';

// Painter 클래스
class DrawingPainter extends CustomPainter {
  final List<OneLineData> linesData;

  final Offset offset;

  DrawingPainter(this.linesData, {this.offset = Offset.zero});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    for (var line in linesData) {
      paint.color = Color(line.color);
      paint.strokeWidth = line.strokeWidth;

      Path path = Path();
      path.moveTo(line.points[0]!.dx, line.points[0]!.dy);
      for (int i = 0; i < line.points.length - 1; i++) {
        if (line.points[i] != null && line.points[i + 1] != null) {
          path.quadraticBezierTo(line.points[i]!.dx, line.points[i]!.dy,
              line.points[i + 1]!.dx, line.points[i + 1]!.dy);
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
