import 'package:flutter/material.dart';
import '../../datas/drawingdata.dart';

class DrawingmenuWidget extends StatefulWidget {
  final DrawingData _drawingData;
  final VoidCallback _onTogglePanningMode;

  const DrawingmenuWidget({
    super.key,
    required DrawingData drawingData,
    required VoidCallback onTogglePanningMode,
  })  : _drawingData = drawingData,
        _onTogglePanningMode = onTogglePanningMode;

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
                onPressed: () {},
                icon: const Icon(
                  Icons.mode,
                  color: Colors.black,
                  size: 30,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.brush,
                  color: Colors.black,
                  size: 30,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Image.asset('assets/icon_eraser.png', width: 25),
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
