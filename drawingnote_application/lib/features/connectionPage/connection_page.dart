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

    //TODO 나중에 따로 페이지 만들어야 됨
    //_bluetoothmanager.requestPermission();

    _bluetoothmanager.getDevices().then((_) {
      setState(() {});
    }); //페어링된 디바이스 목록 가져오기
  }

  //화면 구성
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Stack(
              children: [
                const MainIcons(),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: TextButton(
                    onPressed: () {
                      _bluetoothmanager.requestPermission();
                    },
                    child: const Text("Permissions"),
                  ),
                ),
              ],
            ),
            (_bluetoothmanager.deviceIsNotConnected())
                ? PairedBluetoothDevicesWidget(
                    bluetoothmanager: _bluetoothmanager,
                  )
                : OnConnectWidget(
                    httpmanager: _httpmanager,
                    bluetoothmanager: _bluetoothmanager,
                    pagedata: _pagedata,
                    drawingData: _drawingData,
                  ),
          ],
        ),
      ),
    );
  }
}
