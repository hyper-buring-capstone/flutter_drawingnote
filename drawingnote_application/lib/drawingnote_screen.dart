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

  List<List<Offset?>> lines = [];
  List<Offset?> currentLine = [];
  bool isEraser = false; // 지우개 모드 변수

  @override
  void initState() {
    super.initState();
    //TODO : 이미지랑 기존 drawing data 불러오기
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/dummyBackgroundImage.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: GestureDetector(
          onPanStart: (details) async {
            // 터치 시작 시 헤더 전송 (지우개 또는 그리기 모드)
            await widget.bluetoothClassic
                .write("${isEraser ? eraserHeader : drawingHeader}\r\n");

            //지우개 기능 관리
            setState(() {
              if (isEraser) {
                _eraseLine(details.localPosition);
              } else {
                currentLine = [details.localPosition];
                lines.add(currentLine);
              }
            });
          },
          onPanUpdate: (details) async {
            RenderBox renderBox = context.findRenderObject() as RenderBox;
            Offset localPosition =
                renderBox.globalToLocal(details.globalPosition);
            //points.add(localPosition);

            // 터치할 때마다 좌표를 블루투스를 통해 전송
            await widget.bluetoothClassic
                .write("${localPosition.dx} ${localPosition.dy}\r\n");

            setState(() {
              if (!isEraser) {
                currentLine.add(details.localPosition);
              } else {
                _eraseLine(details.localPosition);
              }
            });
          },
          onPanEnd: (details) async {
            //points.add(null); // null을 추가해서 선이 끊기도록 함
            if (!isEraser) {
              currentLine.add(null); // null을 추가해서 선이 끊기도록 함
            }
            await widget.bluetoothClassic.write("$endstring\r\n");
          },
          child: CustomPaint(
            painter: DrawingPainter(lines, offset: const Offset(0, -100)),
            size: Size.infinite,
          ),
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
            tooltip:
                isEraser ? 'Switch to Drawing Mode' : 'Switch to Eraser Mode',
            child: Icon(isEraser ? Icons.brush : Icons.cleaning_services),
          ),
        ],
      ),
    );
  }

  void _eraseLine(Offset position) {
    lines.removeWhere((line) =>
        line.any((point) => point != null && (point - position).distance < 20));
  }
}

// Painter 클래스
class DrawingPainter extends CustomPainter {
  final List<List<Offset?>> lines;

  //final List<Offset?> points;
  final Offset offset;

  DrawingPainter(this.lines, {this.offset = Offset.zero});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    // for (int i = 0; i < points.length - 1; i++) {
    //   if (points[i] != null && points[i + 1] != null) {
    //     canvas.drawLine(points[i]! + offset, points[i + 1]! + offset, paint);
    //   }
    // }

    for (var line in lines) {
      for (int i = 0; i < line.length - 1; i++) {
        if (line[i] != null && line[i + 1] != null) {
          canvas.drawLine(line[i]!, line[i + 1]!, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
