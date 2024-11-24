import 'package:bluetooth_classic/models/device.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:bluetooth_classic/bluetooth_classic.dart';

import 'drawingnote_screen.dart';

class BluetoothConnectingScreen extends StatefulWidget {
  const BluetoothConnectingScreen({super.key});

  @override
  State<BluetoothConnectingScreen> createState() =>
      _BluetoothConnectingScreenState();
}

class _BluetoothConnectingScreenState extends State<BluetoothConnectingScreen> {
  //bluetooth 관련 변수 선언
  String _platformVersion = 'Unknown';
  final _bluetoothClassicPlugin = BluetoothClassic();
  List<Device> _devices = [];
  List<Device> _discoveredDevices = [];
  bool _scanning = false;
  int _deviceStatus = Device.disconnected;

  //final Uint8List _data = Uint8List(0);
  final List<String> _receivedInput = [];

  //bluetooth 관련 함수 선언 (DeviceStatus 변경, 데이터 receive)
  @override
  void initState() {
    super.initState();
    initPlatformState();

    _bluetoothClassicPlugin.onDeviceStatusChanged().listen((event) {
      setState(() {
        _deviceStatus = event;
      });
    });
    _bluetoothClassicPlugin.onDeviceDataReceived().listen((event) {
      setState(() {
        //_receivedInput.add(utf8.decode(event));
        //_data = Uint8List.fromList([..._data, ...event]);
      });
    });
  }

  //기기 OS version 받아오기
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _bluetoothClassicPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });

    _getDevices();
  }

  //paired device 가져와서 _devices에 저장
  Future<void> _getDevices() async {
    var res = await _bluetoothClassicPlugin.getPairedDevices();
    setState(() {
      _devices = res;
    });
  }

  //bluetooth device 스캔 해서 _discoveredDevices에 저장
  Future<void> _scan() async {
    if (_scanning) {
      await _bluetoothClassicPlugin.stopScan();
      setState(() {
        _scanning = false;
      });
    } else {
      await _bluetoothClassicPlugin.startScan();
      _bluetoothClassicPlugin.onDeviceDiscovered().listen(
        (event) {
          setState(() {
            _discoveredDevices = [..._discoveredDevices, event];
          });
        },
      );
      setState(() {
        _scanning = true;
      });
    }
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
              Text("Device status is $_deviceStatus"),
              ElevatedButton(
                  onPressed: _deviceStatus == 2
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DrawingScreen(
                                      bluetoothClassic: _bluetoothClassicPlugin,
                                    )), //클릭시 이동
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _deviceStatus == 2 ? Colors.blue : null,
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
