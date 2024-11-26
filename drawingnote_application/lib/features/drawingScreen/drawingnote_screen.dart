import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:flutter/material.dart';

import 'drawingpainter.dart';
import '../../services/httpmanager.dart';
import '../../datas/drawingdata.dart';

const String drawingHeader = "HEADER:DRAWING";
const String eraserHeader = "HEADER:ERASER";
const String endstring = "END";

class DrawingScreen extends StatefulWidget {
  final BluetoothClassic bluetoothClassic;
  final String ipAddress;

  const DrawingScreen(
      {super.key, required this.bluetoothClassic, required this.ipAddress});

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  DrawingData drawingData = DrawingData();

  //TODO 나중에 여기서 선언하지 말고 parameter로 받을 거임
  late Httpmanager httpmanager;

  final TransformationController _transformationController =
      TransformationController();

  @override
  void initState() {
    super.initState();
    httpmanager = Httpmanager(ipAddress: widget.ipAddress);
    //httpmanager.fetchImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: httpmanager.imageBytes == null
            ? InteractiveViewer(
                panEnabled: drawingData.isPanning,
                transformationController: _transformationController,
                minScale: 0.1,
                maxScale: 4.0,
                onInteractionStart: (details) async {
                  if (details.pointerCount == 1) {
                    //터치 시작 시 헤더 전송 (지우개 또는 그리기 모드)
                    await widget.bluetoothClassic.write(
                        "${drawingData.isEraser ? eraserHeader : drawingHeader}\r\n");

                    //지우개 기능 관리
                    setState(() {
                      if (drawingData.isEraser) {
                        drawingData.eraseLine(details.localFocalPoint);
                      } else {
                        drawingData.setCurrentLine(details.localFocalPoint);
                        drawingData.addNewLine();
                      }
                    });
                  } else if (details.pointerCount == 2) {
                    setState(() {
                      drawingData.isPanning = true;
                    });
                  }
                },
                onInteractionUpdate: (details) async {
                  if (!drawingData.isPanning) {
                    RenderBox renderBox =
                        context.findRenderObject() as RenderBox;
                    Offset localPosition =
                        renderBox.globalToLocal(details.focalPoint);

                    // 터치할 때마다 좌표를 블루투스를 통해 전송
                    await widget.bluetoothClassic
                        .write("${localPosition.dx} ${localPosition.dy}\r\n");

                    setState(() {
                      if (!drawingData.isEraser) {
                        drawingData
                            .addPointToCurrentLine(details.localFocalPoint);
                      } else {
                        drawingData.eraseLine(details.localFocalPoint);
                      }
                    });
                  }
                },
                onInteractionEnd: (details) async {
                  if (!drawingData.isPanning) {
                    if (!drawingData.isEraser) {
                      drawingData.cutCurrentLine();
                    }
                    await widget.bluetoothClassic.write("$endstring\r\n");
                  }
                  setState(() {
                    drawingData.isPanning = false;
                  });
                },
                child: Container(
                  // decoration: BoxDecoration(
                  //   image: DecorationImage(
                  //     image: MemoryImage(httpmanager.imageBytes!),
                  //     fit: BoxFit.contain,
                  //   ),
                  // ),
                  child: CustomPaint(
                    painter: DrawingPainter(drawingData.linesData,
                        offset: const Offset(0, -100)),
                    size: Size.infinite,
                  ),
                ),
              )
            : const Center(child: CircularProgressIndicator()),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                setState(() {
                  drawingData.switchEraserMode();
                });
              },
              tooltip: drawingData.isEraser
                  ? 'Switch to Drawing Mode'
                  : 'Switch to Eraser Mode',
              child: Icon(
                  drawingData.isEraser ? Icons.brush : Icons.cleaning_services),
            ),
          ],
        ));
  }
}
