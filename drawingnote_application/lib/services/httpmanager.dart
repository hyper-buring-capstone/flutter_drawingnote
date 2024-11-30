import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../datas/pagedata.dart';
import '../datas/drawingdata.dart';

class Httpmanager {
  static const String _port = '8080'; //port 번호

  final ValueNotifier<String?> ipAddress = ValueNotifier<String?>(null);

  late final Pagedata _pagedata;
  late final DrawingData _drawingData;

  Httpmanager({
    required Pagedata pagedata,
    required DrawingData drawingdata,
    String? ipAddressData,
  }) {
    ipAddress.value = ipAddressData;
    _pagedata = pagedata;
    _drawingData = drawingdata;
  }

  //--------------------------------------------------------------------------------
  // getter
  //--------------------------------------------------------------------------------

  //Uint8List? get imageBytes => _imageBytes;

  //--------------------------------------------------------------------------------
  // data field 관련 함수
  //--------------------------------------------------------------------------------

  /// imageBytes가 null인지 확인
  bool isImageBytesNull() {
    return _pagedata.imageBytes.value == null;
  }

  /// IP 주소가 null인지 확인
  bool isIpAddressNull() {
    return ipAddress.value == null;
  }

  //--------------------------------------------------------------------------------
  // http 요청 함수
  //--------------------------------------------------------------------------------

  /// image 요청 함수
  ///
  /// 요청 성공 시 [imageBytes]에 jpg의 이진 데이터 저장
  /// 실패 시 오류 메세지 출력 (debug mode 한정)
  /// [pageNumber] : 페이지 번호
  Future<void> fetchImage() async {
    // 페이지 번호가 null이면 요청하지 않음
    if (_pagedata.pageNumber == null) {
      return;
    }

    // 이미지 요청
    try {
      await http
          .get(Uri.parse(
              'http://${ipAddress.value}:$_port/images/${_pagedata.pageNumber!}'))
          .then((response) {
        if (response.statusCode == 200) {
          _pagedata.imageBytes.value = response.bodyBytes;

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

  /// LineData 요청 함수
  ///
  /// 요청 성공 시 [imageBy]에 jpg의 이진 데이터 저장
  /// 실패 시 오류 메세지 출력 (debug mode 한정)
  /// [pageNumber] : 페이지 번호
  Future<void> fetchLineData() async {
    // 페이지 번호가 null이면 요청하지 않음
    if (_pagedata.pageNumber == null) {
      return;
    }

    // 이미지 요청
    try {
      await http
          .get(Uri.parse(
              'http://${ipAddress.value}:$_port/lines/${_pagedata.pageNumber!}'))
          .then((response) {
        if (response.statusCode == 200) {
          //_pagedata.imageBytes.value = response.bodyBytes;
          if (kDebugMode) {
            print('line body : ${response.body}');
          }

          if (kDebugMode) {
            print('선 데이터 요청 성공');
          }
        } else {
          if (kDebugMode) {
            print('선 데이터 요청 실패: ${response.statusCode}');
          }
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('선 데이터 요청 실패: $e');
      }
    }
  }
}
