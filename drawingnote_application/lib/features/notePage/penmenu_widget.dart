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
                      icon: widget._drawingData.penColorValue == '000000'
                          ? Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xff000000),
                                border: Border.all(
                                  color: Colors.yellowAccent,
                                  width: 2,
                                ),
                              ),
                              height: 30,
                              width: 30,
                            )
                          : Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xff000000),
                              ),
                              height: 30,
                              width: 30,
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
                    icon: Container(
                      height: 25,
                      width: 3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.black,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      widget._onSwitchPenWidth(1);
                    },
                    icon: Container(
                      height: 25,
                      width: 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.black,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      widget._onSwitchPenWidth(2);
                    },
                    icon: Container(
                      height: 25,
                      width: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.black,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      widget._onSwitchPenWidth(3);
                    },
                    icon: Container(
                      height: 25,
                      width: 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.black,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      widget._onSwitchPenWidth(4);
                    },
                    icon: Container(
                      height: 25,
                      width: 12,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.black,
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
}
