import 'package:flutter/foundation.dart';
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

  final GlobalKey _imageKey = GlobalKey();
  Offset? _imagePositionTopLeft;
  Offset? _imagePositionBottomRight;

  bool _firstTouch = true;

  @override
  void initState() {
    super.initState();

    widget._pagedata.imageBytes.addListener(() {
      setState(() {
        _firstTouch = true;
      });
    });
  }

  /// controlMode에 따라 floatingActionButton의 아이콘 변경
  IconData _setFloatingButtonIcon() {
    if (drawingData.controlMode == ControlMode.draw) {
      return Icons.brush;
    } else if (drawingData.controlMode == ControlMode.erase) {
      return Icons.cleaning_services;
    } else if (drawingData.controlMode == ControlMode.pan) {
      return Icons.mouse;
    }
    return Icons.no_cell;
  }

  //image 좌상단, 우하단 좌표 설정
  void _setImageLocationInfo() {
    if (_imageKey.currentContext != null) {
      final RenderBox renderBox =
          _imageKey.currentContext!.findRenderObject() as RenderBox;
      final Size imageSize = renderBox.size;
      _imagePositionTopLeft = renderBox.localToGlobal(Offset.zero);

      //우 하단 좌표
      _imagePositionBottomRight =
          renderBox.localToGlobal(Offset(imageSize.width, imageSize.height));

      _imagePositionTopLeft =
          _transformationController.toScene(_imagePositionTopLeft!);
      _imagePositionBottomRight =
          _transformationController.toScene(_imagePositionBottomRight!);

      // if (kDebugMode) {
      //   print('Image TopLeft Position : $_imagePositionTopLeft');
      //   print('Image BottomRight Position : $_imagePositionBottomRight');
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: widget._httpmanager.isImageBytesNull()
            ? const Center(child: CircularProgressIndicator())
            : InteractiveViewer(
                panEnabled: drawingData.isPanning,
                scaleEnabled: drawingData.isPanning,
                transformationController: _transformationController,
                minScale: 0.1,
                maxScale: 4.0,
                onInteractionStart: (details) {
                  //처음 터치 할때 이미지의 좌표를 setting
                  if (_firstTouch) {
                    _firstTouch = false;
                    _setImageLocationInfo();
                  }

                  if (!drawingData.isPanning) {
                    //터치 시작 시 헤더 전송 (지우개 또는 그리기 모드)
                    widget._bluetoothmanager.sendData(
                        "${drawingData.isEraser ? BluetoothHeaderformat.eraserHeader : BluetoothHeaderformat.drawingHeader}\r\n");

                    //모바일 드로잉 관리
                    Offset position =
                        _transformationController.toScene(details.focalPoint);
                    setState(() {
                      if (drawingData.isEraser) {
                        drawingData.eraseLine(position);
                      } else {
                        drawingData.setCurrentLine(position);
                        drawingData.addNewLine();
                      }
                    });
                  }
                },
                onInteractionUpdate: (details) {
                  if (!drawingData.isPanning) {
                    Offset position =
                        _transformationController.toScene(details.focalPoint);

                    // 터치할 때마다 좌표를 블루투스를 통해 전송
                    widget._bluetoothmanager
                        .sendData("${position.dx} ${position.dy}\r\n");

                    //모바일 드로잉 관리리
                    setState(() {
                      if (!drawingData.isEraser) {
                        drawingData.addPointToCurrentLine(position);
                      } else {
                        drawingData.eraseLine(position);
                      }
                    });

                    //debug code
                    // if (kDebugMode) {
                    //   print('touch position : $position');
                    // }
                  }
                },
                onInteractionEnd: (details) {
                  if (!drawingData.isPanning) {
                    if (!drawingData.isEraser) {
                      drawingData.cutCurrentLine();
                    }
                    widget._bluetoothmanager
                        .sendData("${BluetoothHeaderformat.endstring}\r\n");
                  } else {
                    //debug code

                    //getImageInfo();
                  }
                },
                child: Stack(
                  children: [
                    Center(
                      child: Image.memory(
                        widget._pagedata.imageBytes.value!,
                        fit: BoxFit.contain,
                        key: _imageKey,
                      ),
                    ),
                    CustomPaint(
                      painter: DrawingPainter(drawingData.linesData,
                          offset: const Offset(0, -100)),
                      size: Size.infinite,
                    ),
                  ],
                ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              drawingData.changeControlMode();
            });
          },
          child: Icon(_setFloatingButtonIcon()),
        ));
  }
}
