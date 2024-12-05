import 'package:flutter/material.dart';
import '../../datas/drawingdata.dart';
import 'penmenu_widget.dart';

class DrawingmenuWidget extends StatefulWidget {
  final DrawingData _drawingData;
  final VoidCallback _onTogglePanningMode;
  final void Function(int) _onSwitchDrawingMode;
  final void Function(String) _onSwitchPenColor;
  final void Function(int) _onSwitchPenWidth;
  final bool _penMenuToggle;
  final void Function(bool) _setPenMenuToggle;

  const DrawingmenuWidget({
    super.key,
    required DrawingData drawingData,
    required VoidCallback onTogglePanningMode,
    required void Function(int) onSwitchDrawingMode,
    required void Function(String) onSwitchPenColor,
    required void Function(int) onSwitchPenWidth,
    required bool penMenuToggle,
    required void Function(bool) setPenMenuToggle,
  })  : _drawingData = drawingData,
        _onTogglePanningMode = onTogglePanningMode,
        _onSwitchDrawingMode = onSwitchDrawingMode,
        _onSwitchPenColor = onSwitchPenColor,
        _onSwitchPenWidth = onSwitchPenWidth,
        _penMenuToggle = penMenuToggle,
        _setPenMenuToggle = setPenMenuToggle;

  @override
  State<DrawingmenuWidget> createState() => _DrawingmenuWidgetState();
}

class _DrawingmenuWidgetState extends State<DrawingmenuWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        widget._penMenuToggle
            ? PenmenuWidget(
                drawingData: widget._drawingData,
                onSwitchPenColor: widget._onSwitchPenColor,
                onSwitchPenWidth: widget._onSwitchPenWidth,
              )
            : Container(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
          child: Container(
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      if (widget._drawingData.controlMode != ControlMode.pen) {
                        widget._setPenMenuToggle(false);
                        widget._onSwitchDrawingMode(1);
                      } else {
                        if (widget._drawingData.isPanning) {
                          widget._onSwitchDrawingMode(1);
                        } else {
                          setState(() {
                            widget._setPenMenuToggle(!widget._penMenuToggle);
                          });
                        }
                      }
                    },
                    icon: (widget._drawingData.controlMode == ControlMode.pen)
                        ? Icon(
                            Icons.mode,
                            color: Color(int.parse(
                                '0xFF${widget._drawingData.penColorValue}')),
                            size: 30,
                          )
                        : const Icon(
                            Icons.mode,
                            color: Colors.grey,
                            size: 30,
                          ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (widget._drawingData.controlMode !=
                          ControlMode.brush) {
                        widget._setPenMenuToggle(false);
                        widget._onSwitchDrawingMode(2);
                      } else {
                        if (widget._drawingData.isPanning) {
                          widget._onSwitchDrawingMode(2);
                        } else {
                          setState(() {
                            widget._setPenMenuToggle(!widget._penMenuToggle);
                          });
                        }
                      }
                    },
                    icon: (widget._drawingData.controlMode == ControlMode.brush)
                        ? Icon(
                            Icons.brush,
                            color: Color(int.parse(
                                '0xFF${widget._drawingData.brushColorValue}')),
                            size: 30,
                          )
                        : const Icon(
                            Icons.brush,
                            color: Colors.grey,
                            size: 30,
                          ),
                  ),
                  IconButton(
                    onPressed: () {
                      widget._onSwitchDrawingMode(3);
                      widget._setPenMenuToggle(false);
                    },
                    icon: (widget._drawingData.controlMode == ControlMode.erase)
                        ? Image.asset(
                            'assets/icon_eraser.png',
                            width: 25,
                            color: const Color(0xFFF0782A),
                          )
                        : Image.asset(
                            'assets/icon_eraser.png',
                            width: 25,
                            color: Colors.grey,
                          ),
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      widget._setPenMenuToggle(false);
                      widget._onTogglePanningMode();
                    },
                    backgroundColor: widget._drawingData.isPanning
                        ? const Color(0xFFF23B3C)
                        : const Color(0xFFFFFFFF),
                    shape: const CircleBorder(),
                    child: widget._drawingData.isPanning
                        ? const Icon(
                            Icons.mouse,
                            color: Colors.white,
                          )
                        : const Icon(Icons.mouse),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
