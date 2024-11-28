import 'package:flutter/foundation.dart';

///page의 데이터 관리 모델
///[pageNumber] : 현재 페이지 번호
///[imageBytes] : 현재 페이지의 배경 이미지 데이터
class Pagedata {
  String? pageNumber; //현재 페이지 번호
  final ValueNotifier<Uint8List?> imageBytes =
      ValueNotifier<Uint8List?>(null); //배경 이미지 데이터
  //TODO 선 데이터 추가
}
