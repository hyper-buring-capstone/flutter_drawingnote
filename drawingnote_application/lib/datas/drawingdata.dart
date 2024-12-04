import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'onelinedata.dart';

enum ControlMode { none, pen, brush, erase }

/// 모바일 화면 그림 데이터 관리 클래스
class DrawingData {
  List<OneLineData> linesData = [];
  List<Offset?> currentLine = [];
  bool isEraser = false; // 지우개 모드 변수
  bool isPanning = false; // 화면 이동 모드 변수

  StrokeSize penStrokeSize = StrokeSize.ll; //펜 굵기
  int penColor = 0x4D000000; //펜 색깔

  ControlMode controlMode = ControlMode.none;

  final removingDistance = 5.0;

  void switchEraserMode() {
    isEraser = !isEraser;
  }

  void switchPanningMode() {
    isPanning = !isPanning;
  }

  /// controlMode 변경 함수
  ///
  /// controlMode : draw, erase, pan
  /// draw : 그리기 모드
  /// erase : 지우개 모드
  /// pan : 화면 이동 모드
  void changeControlMode(int controlModeValue) {
    switch (controlModeValue) {
      case 0:
        controlMode = ControlMode.none;
        isEraser = false;
        break;
      case 1:
        controlMode = ControlMode.pen;
        isEraser = false;
        break;
      case 2:
        controlMode = ControlMode.brush;
        isEraser = false;
        break;
      default:
        controlMode = ControlMode.erase;
        isEraser = true;
        break;
    }
  }

  //--------------------------------------------------------------------------------
  // lineData 관련 함수
  //--------------------------------------------------------------------------------

  ///currentLine을 lineData에 초과
  void addNewLine() {
    linesData.add(OneLineData(
      points: currentLine,
      color: penColor,
      strokeSize: penStrokeSize,
    ));
  }

  ///line 삭제 함수
  ///poisiton 주변의 line을 삭제한다
  ///removingDistance : 삭제가 작용하는 범위
  void eraseLine(Offset position) {
    linesData.removeWhere((line) => line.points.any((point) =>
        point != null && (point - position).distance < removingDistance));
  }

  ///lineData 초기화
  void clearLinesData() {
    linesData = [];
  }

  ///http 요청으로 받은 값으로 lineData 초기화
  ///
  ///fetchedLinesData : http 요청으로 받은 lineData
  ///topLeft : 이미지의 좌상단 좌표
  ///bottomRight : 이미지의 우하단 좌표
  void setLineData(
    String fetchedLinesData,
    Offset? topLeft,
    Offset? bottomRight,
  ) {
    //빈 문자열 오는 경우 예외 처리
    if (fetchedLinesData == '') {
      if (kDebugMode) {
        print('fetchedLinesData is empty');
      }
      clearLinesData();
      return;
    }

    List<OneLineData> newLinesData = [];
    List<String> fetchedLines = fetchedLinesData.split('&');

    for (var s in fetchedLines) {
      final json = jsonDecode(s);
      final points = json['data'] as List;

      List<Offset?> decodedLineData =
          points.map((e) => Offset(e[0].toDouble(), e[1].toDouble())).toList();

      //절대 좌표로 변환
      decodedLineData = _convertToAbsolutePosition(
        decodedLineData,
        topLeft!,
        bottomRight!,
      );
      List<Offset?> newLine = [];
      newLine.addAll(decodedLineData);
      newLine.add(null);

      newLinesData.add(OneLineData(
          points: newLine,
          color: 0xFF000000, //임시로 넣은 값, json['color']
          strokeSize:
              StrokeSize.l //임시로 넣은 값, StrokeSize.values[json['strokeSize']]
          ));
    }
    if (kDebugMode) {
      print('newLinesData : $newLinesData');
    }

    linesData = newLinesData;
  }

  ///List<Offset>을 받아서 스마트폰의 절대 좌표로 scaling
  List<Offset?> _convertToAbsolutePosition(
    List<Offset?> line,
    Offset topLeft,
    Offset bottomRight,
  ) {
    double scaleNumber = 10000;

    List<Offset?> newLine = [];
    for (var point in line) {
      if (point != null) {
        double absoluteX = topLeft.dx +
            (point.dx * (bottomRight.dx - topLeft.dx) / scaleNumber);
        double absoluteY = topLeft.dy +
            (point.dy * (bottomRight.dy - topLeft.dy) / scaleNumber);
        newLine.add(Offset(absoluteX, absoluteY));
      } else {
        newLine.add(null);
      }
    }

    return newLine;
  }

  //--------------------------------------------------------------------------------
  // current line 관련 함수
  //--------------------------------------------------------------------------------

  ///currentLine 초기화
  void setCurrentLine(Offset? point) {
    currentLine = [point];
  }

  ///currentLine에 point 추가
  void addPointToCurrentLine(Offset? point) {
    currentLine.add(point);
  }

  ///currentLine 끊기 (끝에 null 추가)
  void cutCurrentLine() {
    currentLine.add(null);
  }
}
