import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../services/httpmanager.dart';
import '../../services/bluetoothmanager.dart';
import '../../datas/pagedata.dart';
import '../../datas/drawingdata.dart';
import 'paired_bluetooth_devices_widget.dart';
import 'on_connect_widget.dart';
import 'main_icons.dart';

class ConnectionPage extends StatefulWidget {
  const ConnectionPage({super.key});

  @override
  State<ConnectionPage> createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  late final Httpmanager _httpmanager;
  late final Bluetoothmanager _bluetoothmanager;
  late final Pagedata _pagedata;
  late final DrawingData _drawingData;

  //bluetooth 관련 함수 선언 (DeviceStatus 변경, 데이터 receive)
  @override
  void initState() {
    super.initState();

    //service manager 객체 생성
    _pagedata = Pagedata();
    _drawingData = DrawingData();

    _httpmanager = Httpmanager(
      pagedata: _pagedata,
      drawingdata: _drawingData,
    );
    _bluetoothmanager = Bluetoothmanager(
      httpmanager: _httpmanager,
      pagedata: _pagedata,
    );

    _bluetoothmanager.requestPermission();

    //httpmanager의 ip주소 변경 감지하여 UI 업데이트
    _httpmanager.ipAddress.addListener(() {
      if (kDebugMode) {
        print('ipAddress changed : ${_httpmanager.ipAddress.value}');
      }
      setState(() {});
    });

    //bluetoothmanager의 deviceStatus 변경 감지하여 UI 업데이트
    _bluetoothmanager.deviceStatus.addListener(() {
      setState(() {});
    });

    _bluetoothmanager.getDevices().then((_) {
      setState(() {});
    }); //페어링된 디바이스 목록 가져오기
  }

  //화면 구성
  @override
  Widget build(BuildContext context) {
    Widget? controlWidget;

    //미연결 상태
    if (_bluetoothmanager.deviceIsNotConnected()) {
      controlWidget = PairedBluetoothDevicesWidget(
        bluetoothmanager: _bluetoothmanager,
      );
    }
    //연결 중
    else if (_bluetoothmanager.deviceIsConnecting()) {
      controlWidget = const Text(
        '연결 중...',
        style: TextStyle(
          fontSize: 30,
          fontFamily: 'title_font',
        ),
      );
    }
    //서버 데이터 받아오는 중
    else if (_bluetoothmanager.deviceIsConnected() &&
        _httpmanager.isIpAddressNull()) {
      controlWidget = controlWidget = const Text(
        '서버 정보 수신 중...',
        style: TextStyle(
          fontSize: 30,
          fontFamily: 'title_font',
        ),
      );
      //연결 준비 완료
    } else if (_bluetoothmanager.deviceIsConnected() &&
        !_httpmanager.isIpAddressNull()) {
      controlWidget = OnConnectWidget(
        httpmanager: _httpmanager,
        bluetoothmanager: _bluetoothmanager,
        pagedata: _pagedata,
        drawingData: _drawingData,
      );
    } else {
      controlWidget = const Text('Error');
    }

    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const MainIcons(),
          controlWidget,
        ],
      ),
    );
  }
}
