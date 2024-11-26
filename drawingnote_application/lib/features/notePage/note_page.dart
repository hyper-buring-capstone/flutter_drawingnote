import 'package:flutter/material.dart';

import 'drawingpainter.dart';
import '../../services/httpmanager.dart';
import '../../services/bluetoothmanager.dart';
import '../../datas/drawingdata.dart';
import '../../datas/bluetoothheaderFormat.dart';

class NotePage extends StatefulWidget {
  //service manager 객체
  final Bluetoothmanager _bluetoothmanager;
  final Httpmanager _httpmanager;

  const NotePage({
    super.key,
    required bluetoothmanager,
    required httpmanager,
  })  : _bluetoothmanager = bluetoothmanager,
        _httpmanager = httpmanager;

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  DrawingData drawingData = DrawingData();

  final TransformationController _transformationController =
      TransformationController();

  @override
  void initState() {
    super.initState();
    // widget._httpmanager.fetchImage().then((value) {
    //   setState(() {});
    // });

    widget._httpmanager.imageBytes.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: widget._httpmanager.isImageBytesNull()
            ? const Center(child: CircularProgressIndicator())
            : InteractiveViewer(
                panEnabled: drawingData.isPanning,
                transformationController: _transformationController,
                minScale: 0.1,
                maxScale: 4.0,
                onInteractionStart: (details) {
                  if (details.pointerCount == 1) {
                    //터치 시작 시 헤더 전송 (지우개 또는 그리기 모드)
                    widget._bluetoothmanager.sendData(
                        "${drawingData.isEraser ? BluetoothHeaderformat.eraserHeader : BluetoothHeaderformat.drawingHeader}\r\n");

                    //모바일 드로잉 관리
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
                onInteractionUpdate: (details) {
                  if (!drawingData.isPanning) {
                    RenderBox renderBox =
                        context.findRenderObject() as RenderBox;
                    Offset localPosition =
                        renderBox.globalToLocal(details.focalPoint);

                    // 터치할 때마다 좌표를 블루투스를 통해 전송
                    widget._bluetoothmanager.sendData(
                        "${localPosition.dx} ${localPosition.dy}\r\n");

                    //모바일 드로잉 관리리
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
                onInteractionEnd: (details) {
                  if (!drawingData.isPanning) {
                    if (!drawingData.isEraser) {
                      drawingData.cutCurrentLine();
                    }
                    widget._bluetoothmanager
                        .sendData("${BluetoothHeaderformat.endstring}\r\n");
                  }
                  setState(() {
                    drawingData.isPanning = false;
                  });
                },
                child: Container(
                  //debugging 용
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: MemoryImage(widget._httpmanager.imageBytes.value!),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: CustomPaint(
                    painter: DrawingPainter(drawingData.linesData,
                        offset: const Offset(0, -100)),
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
