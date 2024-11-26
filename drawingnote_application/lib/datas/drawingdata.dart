import 'package:flutter/material.dart';

/// 모바일 화면 그림 데이터 관리 클래스
class DrawingData {
  List<List<Offset?>> linesData = [];
  List<Offset?> currentLine = [];
  bool _isEraser = false; // 지우개 모드 변수
  bool _isPanning = false; // 화면 이동 모드 변수

  final removingDistance = 5.0;

  bool get isEraser => _isEraser;
  bool get isPanning => _isPanning;

  set isEraser(bool value) {
    _isEraser = value;
  }

  set isPanning(bool value) {
    _isPanning = value;
  }

  void switchEraserMode() {
    _isEraser = !_isEraser;
  }

  void switchPanningMode() {
    _isPanning = !_isPanning;
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
