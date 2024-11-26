import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Httpmanager {
  static const String _port = '8080'; //port 번호

  late final String _ipAddress;
  Uint8List? _imageBytes;

  Httpmanager({
    required ipAddress,
  }) : _ipAddress = ipAddress;

  Uint8List? get imageBytes => _imageBytes;

  //TODO get 요청에 page 번호 반영
  /// image 요청 함수
  ///
  /// 요청 성공 시 [imageBytes]에 jpg의 이진 데이터 저장
  /// 실패 시 오류 메세지 출력 (debug mode 한정)
  /// [pageNumber] : 페이지 번호 (default: 0)
  Future<void> fetchImage({int? pageNumber = 0}) async {
    //print('이미지 요청: http://$ipAddress:$port/image');

    // 이미지 요청
    try {
      http.get(Uri.parse('http://$_ipAddress:$_port/image')).then((response) {
        if (response.statusCode == 200) {
          _imageBytes = response.bodyBytes;

          if (kDebugMode) {
            print('이미지 요청 성공');
          }
        } else {
          if (kDebugMode) {
            print('이미지 요청 실패: ${response.statusCode}');
          }
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('이미지 요청 실패: $e');
      }
    }
  }
}
