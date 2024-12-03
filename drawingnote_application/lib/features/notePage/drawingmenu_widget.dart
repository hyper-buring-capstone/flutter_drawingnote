import 'package:flutter/material.dart';
import '../../datas/drawingdata.dart';

class DrawingmenuWidget extends StatefulWidget {
  final DrawingData _drawingData;

  const DrawingmenuWidget({
    super.key,
    required DrawingData drawingData,
  }) : _drawingData = drawingData;

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
          color: const Color(0xFF9DC5DF),
          borderRadius: BorderRadius.circular(40),
          boxShadow: const [],
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
                  color: Colors.white,
                  size: 30,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.brush,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.clear,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              FloatingActionButton(
                onPressed: () {
                  widget._drawingData.switchPanningMode();
                },
                backgroundColor: const Color(0xFFFFFFFF),
                shape: const CircleBorder(),
                child: widget._drawingData.isPanning
                    ? const Icon(
                        Icons.mouse,
                        color: Color(0xFF034373),
                      )
                    : const Icon(
                        Icons.mouse,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
