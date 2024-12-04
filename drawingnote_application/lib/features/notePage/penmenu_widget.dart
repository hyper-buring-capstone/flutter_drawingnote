import 'package:drawingnote_application/datas/onelinedata.dart';
import 'package:flutter/material.dart';

import '../../datas/drawingdata.dart';

class PenmenuWidget extends StatefulWidget {
  final DrawingData _drawingData;
  final void Function(String) _onSwitchPenColor;
  final void Function(int) _onSwitchPenWidth;

  const PenmenuWidget({
    super.key,
    required DrawingData drawingData,
    required void Function(String) onSwitchPenColor,
    required void Function(int) onSwitchPenWidth,
  })  : _drawingData = drawingData,
        _onSwitchPenColor = onSwitchPenColor,
        _onSwitchPenWidth = onSwitchPenWidth;

  @override
  State<PenmenuWidget> createState() => _PenmenuWidgetState();
}

class _PenmenuWidgetState extends State<PenmenuWidget> {
  @override
  Widget build(BuildContext context) {
    //pen 모드
    if (widget._drawingData.controlMode == ControlMode.pen) {
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
            child: Row(
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          widget._onSwitchPenColor('000000');
                        },
                        icon: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xff000000),
                          ),
                          height: 30,
                          width: 30,
                          child: widget._drawingData.penColorValue == '000000'
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          widget._onSwitchPenColor('E61B1B');
                        },
                        icon: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xffE61B1B),
                          ),
                          height: 30,
                          width: 30,
                          child: widget._drawingData.penColorValue == 'E61B1B'
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          widget._onSwitchPenColor('FF5400');
                        },
                        icon: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xffFF5400),
                          ),
                          height: 30,
                          width: 30,
                          child: widget._drawingData.penColorValue == 'FF5400'
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          widget._onSwitchPenColor('FFE600');
                        },
                        icon: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xffFFE600),
                          ),
                          height: 30,
                          width: 30,
                          child: widget._drawingData.penColorValue == 'FFE600'
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          widget._onSwitchPenColor('25E600');
                        },
                        icon: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xff25E600),
                          ),
                          height: 30,
                          width: 30,
                          child: widget._drawingData.penColorValue == '25E600'
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          widget._onSwitchPenColor('004DE6');
                        },
                        icon: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xff004DE6),
                          ),
                          height: 30,
                          width: 30,
                          child: widget._drawingData.penColorValue == '004DE6'
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          widget._onSwitchPenColor('FF80FF');
                        },
                        icon: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xffFF80FF),
                          ),
                          height: 30,
                          width: 30,
                          child: widget._drawingData.penColorValue == 'FF80FF'
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        widget._onSwitchPenWidth(0);
                      },
                      icon: (widget._drawingData.penStrokeSize == StrokeSize.ss)
                          ? Container(
                              height: 22,
                              width: 3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.black,
                              ),
                            )
                          : Container(
                              height: 22,
                              width: 3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.grey,
                              ),
                            ),
                    ),
                    IconButton(
                      onPressed: () {
                        widget._onSwitchPenWidth(1);
                      },
                      icon: (widget._drawingData.penStrokeSize == StrokeSize.s)
                          ? Container(
                              height: 25,
                              width: 5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.black,
                              ),
                            )
                          : Container(
                              height: 25,
                              width: 5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.grey,
                              ),
                            ),
                    ),
                    IconButton(
                      onPressed: () {
                        widget._onSwitchPenWidth(2);
                      },
                      icon: (widget._drawingData.penStrokeSize == StrokeSize.m)
                          ? Container(
                              height: 25,
                              width: 8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.black,
                              ),
                            )
                          : Container(
                              height: 25,
                              width: 8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.grey,
                              ),
                            ),
                    ),
                    IconButton(
                      onPressed: () {
                        widget._onSwitchPenWidth(3);
                      },
                      icon: (widget._drawingData.penStrokeSize == StrokeSize.l)
                          ? Container(
                              height: 25,
                              width: 10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.black,
                              ),
                            )
                          : Container(
                              height: 25,
                              width: 10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.grey,
                              ),
                            ),
                    ),
                    IconButton(
                      onPressed: () {
                        widget._onSwitchPenWidth(4);
                      },
                      icon: (widget._drawingData.penStrokeSize == StrokeSize.ll)
                          ? Container(
                              height: 25,
                              width: 12,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.black,
                              ),
                            )
                          : Container(
                              height: 25,
                              width: 12,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.grey,
                              ),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    //brush 모드
    else if (widget._drawingData.controlMode == ControlMode.brush) {
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
            child: Row(
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          widget._onSwitchPenColor('000000');
                        },
                        icon: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xff000000),
                          ),
                          height: 30,
                          width: 30,
                          child: widget._drawingData.brushColorValue == '000000'
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          widget._onSwitchPenColor('E61B1B');
                        },
                        icon: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xffE61B1B),
                          ),
                          height: 30,
                          width: 30,
                          child: widget._drawingData.brushColorValue == 'E61B1B'
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          widget._onSwitchPenColor('FF5400');
                        },
                        icon: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xffFF5400),
                          ),
                          height: 30,
                          width: 30,
                          child: widget._drawingData.brushColorValue == 'FF5400'
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          widget._onSwitchPenColor('FFE600');
                        },
                        icon: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xffFFE600),
                          ),
                          height: 30,
                          width: 30,
                          child: widget._drawingData.brushColorValue == 'FFE600'
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          widget._onSwitchPenColor('25E600');
                        },
                        icon: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xff25E600),
                          ),
                          height: 30,
                          width: 30,
                          child: widget._drawingData.brushColorValue == '25E600'
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          widget._onSwitchPenColor('004DE6');
                        },
                        icon: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xff004DE6),
                          ),
                          height: 30,
                          width: 30,
                          child: widget._drawingData.brushColorValue == '004DE6'
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          widget._onSwitchPenColor('FF80FF');
                        },
                        icon: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xffFF80FF),
                          ),
                          height: 30,
                          width: 30,
                          child: widget._drawingData.brushColorValue == 'FF80FF'
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        widget._onSwitchPenWidth(0);
                      },
                      icon:
                          (widget._drawingData.brushStrokeSize == StrokeSize.ss)
                              ? Container(
                                  height: 22,
                                  width: 3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.black,
                                  ),
                                )
                              : Container(
                                  height: 22,
                                  width: 3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.grey,
                                  ),
                                ),
                    ),
                    IconButton(
                      onPressed: () {
                        widget._onSwitchPenWidth(1);
                      },
                      icon:
                          (widget._drawingData.brushStrokeSize == StrokeSize.s)
                              ? Container(
                                  height: 25,
                                  width: 5,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.black,
                                  ),
                                )
                              : Container(
                                  height: 25,
                                  width: 5,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.grey,
                                  ),
                                ),
                    ),
                    IconButton(
                      onPressed: () {
                        widget._onSwitchPenWidth(2);
                      },
                      icon:
                          (widget._drawingData.brushStrokeSize == StrokeSize.m)
                              ? Container(
                                  height: 25,
                                  width: 8,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.black,
                                  ),
                                )
                              : Container(
                                  height: 25,
                                  width: 8,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.grey,
                                  ),
                                ),
                    ),
                    IconButton(
                      onPressed: () {
                        widget._onSwitchPenWidth(3);
                      },
                      icon:
                          (widget._drawingData.brushStrokeSize == StrokeSize.l)
                              ? Container(
                                  height: 25,
                                  width: 10,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.black,
                                  ),
                                )
                              : Container(
                                  height: 25,
                                  width: 10,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.grey,
                                  ),
                                ),
                    ),
                    IconButton(
                      onPressed: () {
                        widget._onSwitchPenWidth(4);
                      },
                      icon:
                          (widget._drawingData.brushStrokeSize == StrokeSize.ll)
                              ? Container(
                                  height: 25,
                                  width: 12,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: Colors.black,
                                  ),
                                )
                              : Container(
                                  height: 25,
                                  width: 12,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: Colors.grey,
                                  ),
                                ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
