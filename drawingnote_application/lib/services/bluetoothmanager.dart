import 'package:bluetooth_classic/models/device.dart';
import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';

import 'package:drawingnote_application/services/httpmanager.dart';
import '../datas/bluetoothheaderFormat.dart';
import '../datas/pagedata.dart';

class Bluetoothmanager {
  //bluetooth 관련 변수 선언
  final _bluetoothClassicPlugin = BluetoothClassic();
  List<Device> _devices = []; //페어링된 디바이스 목록

  final ValueNotifier<int> deviceStatus = ValueNotifier<int>(Device
      .disconnected); //디바이스 연결 상태 (0:disconnected, 1:connectiong, 2:connected)
  // int _deviceStatus = Device
  //     .disconnected; //디바이스 연결 상태 (0:disconnected, 1:connectiong, 2:connected)
  String _deviceStatusString = 'Disconnected'; //디바이스 연결 상태 메세지
  final String _serviceUUID =
      "00001101-0000-1000-8000-00805f9b34fb"; //bluetooth service UUID

  Uint8List data = Uint8List(0); //수신한 data

  late final Httpmanager _httpmanager; //선언한 httpmananger, http 통신 연동에 필요
  late final Pagedata _pagedata; //선언한 pagedata, 페이지 데이터 관리에 필요

  //--------------------------------------------------------------------------------
  // Constructor
  //--------------------------------------------------------------------------------

  //bluetooth event Listner 연결
  Bluetoothmanager({
    required httpmanager,
    required pagedata,
  })  : _httpmanager = httpmanager,
        _pagedata = pagedata {
    //device 연결 상태 변경 event
    _bluetoothClassicPlugin.onDeviceStatusChanged().listen((event) {
      deviceStatus.value = event;
      if (deviceStatus.value == 0) {
        //미연결
        _deviceStatusString = 'Disconnected';
      } else if (deviceStatus.value == 1) {
        //연결 중
        _deviceStatusString = 'Connecting';
      } else if (deviceStatus.value == 2) {
        //연결
        _deviceStatusString = 'Server Data Receiving';
      }
    });

    //data 수신 event
    _bluetoothClassicPlugin.onDeviceDataReceived().listen((event) {
      data = Uint8List.fromList([...event]);
      String decoded = utf8.decode(data);

      String? header;
      String? body;

      if (kDebugMode) {
        print('received data: $decoded');
      }

      //format 안맞는 수신 데이터는 무시
      List<String> parts = decoded.split('&&');
      if (parts.length == 2) {
        header = parts[0];
        body = parts[1];
        body = body.replaceAll('%0A', '').replaceAll('\n', ''); //개행문자 제거
      }

      //header에 따른 처리
      if (header == BluetoothHeaderformat.receiveIp) {
        //IP 수신한 경우 httpmanager에 저장
        _httpmanager.ipAddress.value = body;
      } else if (header == BluetoothHeaderformat.receivePagenumber) {
        //페이지 번호 수신한 경우 httpmanager에 저장, image 요청
        _pagedata.pageNumber = body;
        _httpmanager.fetchImage();
        //TODO 나중에 pagedata에 선 데이터도 받아야 됨
      } else if (header == BluetoothHeaderformat.receiveNoteOffHeader) {
        //노트 꺼짐 수신한 경우
        if (body == BluetoothHeaderformat.receiveNoteOffBody) {
          _pagedata.noteState.value = false;
        }
      }
    });
  }

  //--------------------------------------------------------------------------------
  // getter
  //--------------------------------------------------------------------------------
  BluetoothClassic get bluetoothClassicPlugin => _bluetoothClassicPlugin;
  List<Device> get devices => _devices;
  String get deviceStatusString => _deviceStatusString;

  //--------------------------------------------------------------------------------
  // 연결 상태 관련 함수
  //--------------------------------------------------------------------------------

  ///페어링된 device 목록 가져와서 _devices에 저장
  Future<void> getDevices() async {
    var res = await _bluetoothClassicPlugin.getPairedDevices();

    _devices = res;
  }

  //device 연결 상태 확인
  bool deviceIsConnected() {
    return deviceStatus.value == 2;
  }

  ///device 연결 함수
  Future<void> connectDevice(String address) async {
    await _bluetoothClassicPlugin.connect(address, _serviceUUID);
  }

  //--------------------------------------------------------------------------------
  // 블루투스 전송 함수
  //--------------------------------------------------------------------------------

  ///블루투스로 data 전송
  ///
  ///[data] : 전송할 data
  ///await로 사용해야 함
  Future<void> sendData(String data) async {
    await _bluetoothClassicPlugin.write(data);
  }

  //--------------------------------------------------------------------------------
  // 기타 함수
  //--------------------------------------------------------------------------------

  ///permission 요청 함수
  Future<void> requestPermission() async {
    await _bluetoothClassicPlugin.initPermissions();
  }
}
