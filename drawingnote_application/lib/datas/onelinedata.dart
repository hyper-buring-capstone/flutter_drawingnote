//선 하나의 정보를 담는 클래스
import 'package:flutter/material.dart';

enum StrokeSize { ss, s, m, l, ll }

class OneLineData {
  late final List<Offset?> _points;
  late final int _color;
  late final StrokeSize _strokeSize; // 선 굵기
  late final double _strokeWidth; //실제 선 굵기 값

  OneLineData({
    required points,
    required color,
    required strokeSize,
  }) {
    _points = points;
    _color = color;
    _strokeSize = strokeSize;

    if (_strokeSize == StrokeSize.ss) {
      //small small
      _strokeWidth = 3.0;
    } else if (_strokeSize == StrokeSize.s) {
      //small
      _strokeWidth = 5.0;
    } else if (_strokeSize == StrokeSize.m) {
      //medium
      _strokeWidth = 8.0;
    } else if (_strokeSize == StrokeSize.l) {
      //large
      _strokeWidth = 12.0;
    } else {
      //large large
      _strokeWidth = 15.0;
    }
  }

  List<Offset?> get points => _points;
  int get color => _color;
  double get strokeWidth => _strokeWidth;
}
