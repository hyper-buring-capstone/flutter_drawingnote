import 'package:flutter/material.dart';

import 'drawingpainter.dart';
import '../../services/httpmanager.dart';
import '../../services/bluetoothmanager.dart';
import '../../datas/drawingdata.dart';
import '../../datas/bluetoothheaderFormat.dart';
import '../../datas/pagedata.dart';

class NotePage extends StatefulWidget {
  //service manager 객체
  final Bluetoothmanager _bluetoothmanager;
  final Httpmanager _httpmanager;
  final Pagedata _pagedata;

  const NotePage({
    super.key,
    required bluetoothmanager,
    required httpmanager,
    required pagedata,
  })  : _bluetoothmanager = bluetoothmanager,
        _httpmanager = httpmanager,
        _pagedata = pagedata;

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

    widget._pagedata.imageBytes.addListener(() {
      setState(() {});
    });
  }

  /// controlMode에 따라 floatingActionButton의 아이콘 변경
  IconData setFloatingButtonIcon() {
    if (drawingData.controlMode == ControlMode.draw) {
      return Icons.brush;
    } else if (drawingData.controlMode == ControlMode.erase) {
      return Icons.cleaning_services;
    } else if (drawingData.controlMode == ControlMode.pan) {
      return Icons.mouse;
    }
    return Icons.no_cell;
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
                  if (!drawingData.isPanning) {
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
                },
                child: Container(
                  //debugging 용
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: MemoryImage(widget._pagedata.imageBytes.value!),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              drawingData.changeControlMode();
            });
          },
          child: Icon(setFloatingButtonIcon()),
        ));
  }
}
