import 'package:bluetooth_classic/models/device.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:bluetooth_classic/bluetooth_classic.dart';

import '../notePage/note_page.dart';

class ConnectionPage extends StatefulWidget {
  const ConnectionPage({super.key});

  @override
  State<ConnectionPage> createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  //bluetooth 관련 변수 선언
  final _bluetoothClassicPlugin = BluetoothClassic();
  List<Device> _devices = [];
  int _deviceStatus = Device.disconnected;
  String _deviceStatusString = 'Disconnected';

  Uint8List _data = Uint8List(0);
  String? ipAddress = '1';

  //bluetooth 관련 함수 선언 (DeviceStatus 변경, 데이터 receive)
  @override
  void initState() {
    super.initState();

    _getDevices();

    _bluetoothClassicPlugin.onDeviceStatusChanged().listen((event) {
      setState(() {
        _deviceStatus = event;
        if (_deviceStatus == 0) {
          _deviceStatusString = 'Disconnected';
        } else if (_deviceStatus == 1) {
          _deviceStatusString = 'Connecting';
        } else if (_deviceStatus == 2) {
          _deviceStatusString = 'Server Data Receiving';
        }
      });
    });
    _bluetoothClassicPlugin.onDeviceDataReceived().listen((event) {
      _data = Uint8List.fromList([...event]);
      String decoded = utf8.decode(_data);
      String? header;
      String? body;

      List<String> parts = decoded.split(':');
      if (parts.length >= 2) {
        header = parts[0];
        body = parts[1];
      }

      //header에 따른 처리
      if (header == 'SERVERIP') {
        ipAddress = body;
      }
    });
  }

  //paired device 가져와서 _devices에 저장
  Future<void> _getDevices() async {
    var res = await _bluetoothClassicPlugin.getPairedDevices();
    setState(() {
      _devices = res;
    });
  }

  //화면 구성
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () async {
                  await _bluetoothClassicPlugin.initPermissions();
                },
                child: const Text("Check Permissions"),
              ),
              (_deviceStatus == 2 && ipAddress != null)
                  ? const Text('Ready to connect')
                  : Text(_deviceStatusString),
              ElevatedButton(
                  onPressed: (_deviceStatus == 2 && ipAddress != null)
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotePage(
                                      bluetoothClassic: _bluetoothClassicPlugin,
                                      ipAddress: ipAddress!,
                                    )), //클릭시 이동
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (_deviceStatus == 2 && ipAddress != null)
                        ? Colors.blue
                        : null,
                  ),
                  child: const Text("Start")),
            ],
          ),
          Column(
            children: [
              const Text("페어링된 블루투스 기기 목록"),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          for (var device in _devices)
                            TextButton(
                                onPressed: () async {
                                  await _bluetoothClassicPlugin.connect(
                                      device.address,
                                      "00001101-0000-1000-8000-00805f9b34fb");
                                },
                                child: Text(device.name ?? device.address))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
