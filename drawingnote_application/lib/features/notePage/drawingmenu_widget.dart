import 'package:flutter/material.dart';
import '../../datas/drawingdata.dart';

class DrawingmenuWidget extends StatefulWidget {
  final DrawingData _drawingData;
  final VoidCallback _onTogglePanningMode;
  final void Function(int) _onSwitchDrawingMode;

  const DrawingmenuWidget({
    super.key,
    required DrawingData drawingData,
    required VoidCallback onTogglePanningMode,
    required void Function(int) onSwitchDrawingMode,
  })  : _drawingData = drawingData,
        _onTogglePanningMode = onTogglePanningMode,
        _onSwitchDrawingMode = onSwitchDrawingMode;

  @override
  State<DrawingmenuWidget> createState() => _DrawingmenuWidgetState();
}

class _DrawingmenuWidgetState extends State<DrawingmenuWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  widget._onSwitchDrawingMode(1);
                },
                icon: (widget._drawingData.controlMode == ControlMode.pen)
                    ? const Icon(
                        Icons.mode,
                        color: Color(0xFF9EC6E0),
                        size: 30,
                      )
                    : const Icon(
                        Icons.mode,
                        color: Colors.black,
                        size: 30,
                      ),
              ),
              IconButton(
                onPressed: () {
                  widget._onSwitchDrawingMode(2);
                },
                icon: (widget._drawingData.controlMode == ControlMode.brush)
                    ? const Icon(
                        Icons.brush,
                        color: Color(0xFF9EC6E0),
                        size: 30,
                      )
                    : const Icon(
                        Icons.brush,
                        color: Colors.black,
                        size: 30,
                      ),
              ),
              IconButton(
                onPressed: () {
                  widget._onSwitchDrawingMode(3);
                },
                icon: (widget._drawingData.controlMode == ControlMode.erase)
                    ? Image.asset(
                        'assets/icon_eraser.png',
                        width: 25,
                        color: const Color(0xFF9EC6E0),
                      )
                    : Image.asset(
                        'assets/icon_eraser.png',
                        width: 25,
                      ),
              ),
              FloatingActionButton(
                onPressed: widget._onTogglePanningMode,
                backgroundColor: widget._drawingData.isPanning
                    ? const Color(0xFF034373)
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
    );
  }
}
