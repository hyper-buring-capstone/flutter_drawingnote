import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

const String drawingHeader = "HEADER:DRAWING";
const String eraserHeader = "HEADER:ERASER";
const String endstring = "END";

class DrawingScreen extends StatefulWidget {
  final BluetoothClassic bluetoothClassic;

  const DrawingScreen({super.key, required this.bluetoothClassic});

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  List<Offset?> points = [];
  bool isEraser = false; // 지우개 모드 변수

  @override
  void initState() {
    super.initState();
    //TODO : 이미지랑 기존 drawing data 불러오기
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter 그림판'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                points.clear();
              });
            },
          ),
        ],
      ),
      body: GestureDetector(
        onPanStart: (details) async {
          // 터치 시작 시 헤더 전송 (지우개 또는 그리기 모드)
          await widget.bluetoothClassic
              .write("${isEraser ? eraserHeader : drawingHeader}\r\n");
        },
        onPanUpdate: (details) async {
          RenderBox renderBox = context.findRenderObject() as RenderBox;
          Offset localPosition =
              renderBox.globalToLocal(details.globalPosition);
          points.add(localPosition);

          // 터치할 때마다 좌표를 블루투스를 통해 전송
          await widget.bluetoothClassic
              .write("${localPosition.dx} ${localPosition.dy}\r\n");

          setState(() {});
        },
        onPanEnd: (details) async {
          points.add(null); // null을 추가해서 선이 끊기도록 함
          await widget.bluetoothClassic.write("$endstring\r\n");
        },
        child: CustomPaint(
          painter: DrawingPainter(points, offset: const Offset(0, -100)),
          size: Size.infinite,
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              setState(() {
                isEraser = !isEraser; // 지우개 모드 토글
              });
            },
            child: Icon(isEraser ? Icons.brush : Icons.cleaning_services),
            tooltip:
                isEraser ? 'Switch to Drawing Mode' : 'Switch to Eraser Mode',
          ),
        ],
      ),
    );
  }
}

// Painter 클래스
class DrawingPainter extends CustomPainter {
  final List<Offset?> points;
  final Offset offset;

  DrawingPainter(this.points, {this.offset = Offset.zero});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]! + offset, points[i + 1]! + offset, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
