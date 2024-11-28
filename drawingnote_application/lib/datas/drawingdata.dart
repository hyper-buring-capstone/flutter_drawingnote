import 'package:flutter/material.dart';

enum ControlMode { draw, erase, pan }

/// 모바일 화면 그림 데이터 관리 클래스
class DrawingData {
  List<List<Offset?>> linesData = [];
  List<Offset?> currentLine = [];
  bool isEraser = false; // 지우개 모드 변수
  bool isPanning = false; // 화면 이동 모드 변수

  ControlMode controlMode = ControlMode.pan;

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
  void changeControlMode() {
    controlMode =
        ControlMode.values[(controlMode.index + 1) % ControlMode.values.length];

    if (controlMode == ControlMode.draw) {
      isEraser = false;
      isPanning = false;
    } else if (controlMode == ControlMode.erase) {
      isEraser = true;
      isPanning = false;
    } else if (controlMode == ControlMode.pan) {
      isEraser = false;
      isPanning = true;
    }
  }

  //--------------------------------------------------------------------------------
  // lineData 관련 함수
  //--------------------------------------------------------------------------------

  ///currentLine을 lineData에 초과
  void addNewLine() {
    linesData.add(currentLine);
  }

  ///line 삭제 함수
  ///poisiton 주변의 line을 삭제한다
  ///removingDistance : 삭제가 작용하는 범위
  void eraseLine(Offset position) {
    linesData.removeWhere((line) => line.any((point) =>
        point != null && (point - position).distance < removingDistance));
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
