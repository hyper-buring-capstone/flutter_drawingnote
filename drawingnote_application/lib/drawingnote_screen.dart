import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

class DrawingScreen extends StatefulWidget {
  final BluetoothClassic bluetoothClassic;

  const DrawingScreen({super.key, required this.bluetoothClassic});

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  List<Offset?> points = [];

  @override
  void initState() {
    super.initState();

    //TODO : 이미지랑 기존 drawing data 불러오기
  }

  //드로잉때마다 호출
  void sendDrawingData() {
    //TODO : drawing data 전송
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
          await widget.bluetoothClassic.write("type:drawingData\r\n");
        },
        onPanUpdate: (details) async {
          RenderBox renderBox = context.findRenderObject() as RenderBox;
          Offset localPosition =
              renderBox.globalToLocal(details.globalPosition);
          points.add(localPosition);

          // 터치할 때마다 좌표를 블루투스를 통해 전송
          await widget.bluetoothClassic
              .write("${localPosition.dx}:${localPosition.dy}\r\n");

          // if (kDebugMode) {
          //   print("${localPosition.dx}:${localPosition.dy}");
          // }

          setState(() {});
        },
        onPanEnd: (details) async {
          points.add(null); // null을 추가해서 선이 끊기도록 함
          await widget.bluetoothClassic.write("end\r\n");
        },
        child: CustomPaint(
          painter: DrawingPainter(points, offset: const Offset(0, -100)),
          size: Size.infinite,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await widget.bluetoothClassic.write("ping\r\n");
        },
        child: const Icon(Icons.print),
      ),
    );
  }
}

//Painter 클래스
class DrawingPainter extends CustomPainter {
  final List<Offset?> points;
  final Offset offset; // 추가된 오프셋 변수, 그림 위치 조정에 사용

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
