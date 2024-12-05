import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'drawingpainter.dart';
import 'drawingmenu_widget.dart';
import '../../datas/onelinedata.dart';
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
  final DrawingData _drawingData;

  const NotePage({
    super.key,
    required bluetoothmanager,
    required httpmanager,
    required pagedata,
    required drawingData,
  })  : _bluetoothmanager = bluetoothmanager,
        _httpmanager = httpmanager,
        _pagedata = pagedata,
        _drawingData = drawingData;

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final TransformationController _transformationController =
      TransformationController();

  final GlobalKey _imageKey = GlobalKey();
  Offset? _imagePositionTopLeft;
  Offset? _imagePositionBottomRight;

  bool _allowToDraw = false; //이미지 안에서 선 긋기 시작할 떄만 허용
  bool _penMenuToggle = false;

  @override
  void initState() {
    super.initState();

    if (!widget._httpmanager.isImageBytesNull()) {
      _afterRenderingImage();
    }

    widget._pagedata.imageBytes.addListener(() {
      if (mounted) {
        setState(() {});

        if (!widget._httpmanager.isImageBytesNull()) {
          _afterRenderingImage();
        }
      }
    });

    widget._pagedata.noteState.addListener(() {
      if (mounted) {
        if (widget._pagedata.noteState.value == false) {
          widget._pagedata.noteState.value = true;
          widget._pagedata.imageBytes.value = null;
          widget._drawingData.clearLinesData();
        }
      }
    });

    //진입 시 none으로 초기화
    if (widget._drawingData.controlMode != ControlMode.none) {
      widget._drawingData.changeControlMode(0);
    }
  }

  Offset _convertToRelativePosition(Offset position) {
    double scaleNumber = 10000;

    if (_imagePositionTopLeft != null && _imagePositionBottomRight != null) {
      double relativeX = scaleNumber *
          (position.dx - _imagePositionTopLeft!.dx) /
          (_imagePositionBottomRight!.dx - _imagePositionTopLeft!.dx);
      double relativeY = scaleNumber *
          (position.dy - _imagePositionTopLeft!.dy) /
          (_imagePositionBottomRight!.dy - _imagePositionTopLeft!.dy);

      return Offset(relativeX, relativeY);
    }

    return Offset.zero;
  }

  @override
  void dispose() {
    widget._pagedata.imageBytes.removeListener(() {});
    super.dispose();
  }

  //image 랜더링 후 실행하는 함수
  // 이미지 로딩 완료 후 _setImageLocationInfo 호출

  void _afterRenderingImage() {
    widget._drawingData.clearLinesData();

    final imageProvider = MemoryImage(widget._pagedata.imageBytes.value!);
    final ImageStream imageStream =
        imageProvider.resolve(const ImageConfiguration());

    imageStream.addListener(
      ImageStreamListener(
        (ImageInfo imageInfo, bool synchronousCall) {
          if (kDebugMode) {
            print("Image loaded successfully!");
          }

          // 이미지 렌더링 완료 후 좌표 설정
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            _setImageLocationInfo();

            await widget._httpmanager.fetchLineData(
                _imagePositionTopLeft!, _imagePositionBottomRight!);

            setState(() {});
          });
        },
        onError: (exception, stackTrace) {
          if (kDebugMode) {
            print("Error loading image: $exception");
          }
        },
      ),
    );
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
    }
  }

  //Position을 받아서 이미지 내에 있는지 확인하는 함수
  bool _isPositionWithinImage(Offset position) {
    if (_imagePositionTopLeft != null && _imagePositionBottomRight != null) {
      return position.dx > _imagePositionTopLeft!.dx &&
          position.dx < _imagePositionBottomRight!.dx &&
          position.dy > _imagePositionTopLeft!.dy &&
          position.dy < _imagePositionBottomRight!.dy;
    }
    return false;
  }

  //panning mode switch
  void _switchPanningMode() {
    setState(() {
      widget._drawingData.switchPanningMode();
    });
  }

  //drawing mode switch
  void _switchDrawingMode(int mode) {
    setState(() {
      widget._drawingData.isPanning = false;
      widget._drawingData.changeControlMode(mode);
    });

    //블루투스 전송
    if (widget._drawingData.controlMode == ControlMode.pen) {
      widget._bluetoothmanager.sendData(
          "${BluetoothHeaderformat.colorHeader}${BluetoothHeaderformat.seperator}FF${widget._drawingData.penColorValue}\r\n"); //color 전송
      widget._bluetoothmanager.sendData(
          "${BluetoothHeaderformat.widthHeader}${BluetoothHeaderformat.seperator}${widget._drawingData.penStrokeSize.name}\r\n"); //width 전송
    } else if (widget._drawingData.controlMode == ControlMode.brush) {
      widget._bluetoothmanager.sendData(
          "${BluetoothHeaderformat.colorHeader}${BluetoothHeaderformat.seperator}4D${widget._drawingData.brushColorValue}\r\n"); //color 전송
      widget._bluetoothmanager.sendData(
          "${BluetoothHeaderformat.widthHeader}${BluetoothHeaderformat.seperator}${widget._drawingData.brushStrokeSize.name}\r\n"); //width 전송
    }
  }

  //색 변경
  void _switchPenColor(String color) {
    setState(() {
      if (widget._drawingData.controlMode == ControlMode.pen) {
        widget._drawingData.penColorValue = color;
        widget._drawingData.penColor = int.parse('0xFF$color');
      } else if (widget._drawingData.controlMode == ControlMode.brush) {
        widget._drawingData.brushColorValue = color;
        widget._drawingData.penColor = int.parse('0x4D$color');
      }
    });

    //블루투스 전송
    if (widget._drawingData.controlMode == ControlMode.pen) {
      widget._bluetoothmanager.sendData(
          "${BluetoothHeaderformat.colorHeader}${BluetoothHeaderformat.seperator}FF${widget._drawingData.penColorValue}\r\n"); //color 전송
    } else if (widget._drawingData.controlMode == ControlMode.brush) {
      widget._bluetoothmanager.sendData(
          "${BluetoothHeaderformat.colorHeader}${BluetoothHeaderformat.seperator}4D${widget._drawingData.brushColorValue}\r\n"); //color 전송
    }
  }

  //굵기 변경
  void _switchPenWidth(int widthMode) {
    StrokeSize newStrokeSize = StrokeSize.m;

    switch (widthMode) {
      case 0:
        newStrokeSize = StrokeSize.ss;
        break;
      case 1:
        newStrokeSize = StrokeSize.s;
        break;
      case 2:
        newStrokeSize = StrokeSize.m;
        break;
      case 3:
        newStrokeSize = StrokeSize.l;
        break;
      case 4:
        newStrokeSize = StrokeSize.ll;
        break;
    }

    if (widget._drawingData.controlMode == ControlMode.pen) {
      setState(() {
        widget._drawingData.penStrokeSize = newStrokeSize;
      });
    } else if (widget._drawingData.controlMode == ControlMode.brush) {
      setState(() {
        widget._drawingData.brushStrokeSize = newStrokeSize;
      });
    }

    //블루투스 전송
    if (widget._drawingData.controlMode == ControlMode.pen) {
      widget._bluetoothmanager.sendData(
          "${BluetoothHeaderformat.widthHeader}${BluetoothHeaderformat.seperator}${widget._drawingData.penStrokeSize.name}\r\n"); //width 전송
    } else if (widget._drawingData.controlMode == ControlMode.brush) {
      widget._bluetoothmanager.sendData(
          "${BluetoothHeaderformat.widthHeader}${BluetoothHeaderformat.seperator}${widget._drawingData.brushStrokeSize.name}\r\n"); //width 전송
    }
  }

  //penMenuToggle 변경 함수
  void setPenMenuToggle(bool value) {
    setState(() {
      _penMenuToggle = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: widget._httpmanager.isImageBytesNull()
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                InteractiveViewer(
                  panEnabled: widget._drawingData.isPanning,
                  scaleEnabled: widget._drawingData.isPanning,
                  transformationController: _transformationController,
                  minScale: 0.1,
                  maxScale: 4.0,
                  onInteractionStart: (details) {
                    if (!widget._drawingData.isPanning) {
                      setPenMenuToggle(false);

                      //모바일 드로잉 관리
                      Offset position =
                          _transformationController.toScene(details.focalPoint);

                      //이미지 안에서 시작할때만 draw를 허용
                      if (_isPositionWithinImage(position) &&
                          widget._drawingData.controlMode != ControlMode.none) {
                        _allowToDraw = true;
                      }

                      if (_allowToDraw) {
                        //터치 시작 시 헤더 전송 (지우개 또는 그리기 모드)
                        widget._bluetoothmanager.sendData(
                            "${widget._drawingData.isEraser ? BluetoothHeaderformat.eraserHeader : BluetoothHeaderformat.drawingHeader}\r\n");

                        setState(() {
                          if (widget._drawingData.isEraser) {
                            widget._drawingData.eraseLine(position);
                          } else {
                            widget._drawingData.setCurrentLine(position);
                            widget._drawingData.addNewLine();
                          }
                        });
                      }
                    }
                  },
                  onInteractionUpdate: (details) {
                    if (!widget._drawingData.isPanning && _allowToDraw) {
                      Offset position =
                          _transformationController.toScene(details.focalPoint);

                      //position이 이미지를 벗어나면 선을 cut
                      if (!_isPositionWithinImage(position)) {
                        if (!widget._drawingData.isEraser) {
                          widget._drawingData.cutCurrentLine();
                        }
                        widget._bluetoothmanager
                            .sendData("${BluetoothHeaderformat.endstring}\r\n");

                        _allowToDraw = false;
                      } else {
                        // 터치할 때마다 좌표를 블루투스를 통해 전송
                        Offset relativePosition =
                            _convertToRelativePosition(position); //상대좌표로 변환

                        widget._bluetoothmanager.sendData(
                            "${relativePosition.dx} ${relativePosition.dy}\r\n");

                        //모바일 드로잉 관리
                        setState(() {
                          if (!widget._drawingData.isEraser) {
                            widget._drawingData.addPointToCurrentLine(position);
                          } else {
                            widget._drawingData.eraseLine(position);
                          }
                        });
                      }
                    } else if (widget._drawingData.isPanning) {
                      Offset topLeft =
                          _transformationController.toScene(Offset.zero);
                      Offset bottomRight = _transformationController.toScene(
                        Offset(MediaQuery.of(context).size.width,
                            MediaQuery.of(context).size.height),
                      );

                      topLeft = _convertToRelativePosition(topLeft);
                      bottomRight = _convertToRelativePosition(bottomRight);

                      //panning 데이터 전송
                      widget._bluetoothmanager.sendData(
                          "${BluetoothHeaderformat.panningHeader}&&${topLeft.dx} ${topLeft.dy}, ${bottomRight.dx} ${bottomRight.dy}\r\n");
                    }
                  },
                  onInteractionEnd: (details) {
                    if (!widget._drawingData.isPanning && _allowToDraw) {
                      if (!widget._drawingData.isEraser) {
                        widget._drawingData.cutCurrentLine();
                      }
                      widget._bluetoothmanager
                          .sendData("${BluetoothHeaderformat.endstring}\r\n");
                    }
                    //panning 모드일 때 좌표 전송
                    else if (widget._drawingData.isPanning) {
                      Offset topLeft =
                          _transformationController.toScene(Offset.zero);
                      Offset bottomRight = _transformationController.toScene(
                        Offset(MediaQuery.of(context).size.width,
                            MediaQuery.of(context).size.height),
                      );

                      topLeft = _convertToRelativePosition(topLeft);
                      bottomRight = _convertToRelativePosition(bottomRight);

                      // if (kDebugMode) {
                      //   print('Top Left: $topLeft');
                      //   print('Bottom Right: $bottomRight');
                      // }

                      //panning 데이터 전송
                      widget._bluetoothmanager.sendData(
                          "${BluetoothHeaderformat.panningHeader}&&${topLeft.dx} ${topLeft.dy}, ${bottomRight.dx} ${bottomRight.dy}\r\n");
                    }

                    if (_allowToDraw) {
                      _allowToDraw = false;
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
                        painter: DrawingPainter(widget._drawingData.linesData,
                            offset: const Offset(0, -100)),
                        size: Size.infinite,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 0,
                  top: 0,
                  child: DrawingmenuWidget(
                    drawingData: widget._drawingData,
                    onTogglePanningMode: _switchPanningMode,
                    onSwitchDrawingMode: _switchDrawingMode,
                    onSwitchPenColor: _switchPenColor,
                    onSwitchPenWidth: _switchPenWidth,
                    penMenuToggle: _penMenuToggle,
                    setPenMenuToggle: setPenMenuToggle,
                  ),
                )
              ],
            ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     setState(() {
      //       widget._drawingData.changeControlMode();
      //     });
      //   },
      //   child: Icon(_setFloatingButtonIcon()),
      // ),
    );
  }
}
