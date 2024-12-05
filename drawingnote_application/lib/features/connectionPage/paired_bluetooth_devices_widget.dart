import 'package:flutter/material.dart';
import '../../services/bluetoothmanager.dart';

class PairedBluetoothDevicesWidget extends StatefulWidget {
  final Bluetoothmanager _bluetoothmanager;

  const PairedBluetoothDevicesWidget({
    super.key,
    required Bluetoothmanager bluetoothmanager,
  }) : _bluetoothmanager = bluetoothmanager;

  @override
  State<PairedBluetoothDevicesWidget> createState() =>
      _PairedBluetoothDevicesWidgetState();
}

class _PairedBluetoothDevicesWidgetState
    extends State<PairedBluetoothDevicesWidget> {
  bool _permissionCheck = false;

  @override
  Widget build(BuildContext context) {
    if (_permissionCheck == false) {
      return Center(
        child: GestureDetector(
          onTap: () {
            widget._bluetoothmanager.requestPermission().then((_) {
              widget._bluetoothmanager.getDevices().then((_) {
                setState(() {
                  _permissionCheck = true;
                });
              });
            });
          },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              '블루투스 기기 검색',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          const Text('연결할 기기를 선택하세요',
              style: TextStyle(
                fontSize: 20,
              )),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  for (var device in widget._bluetoothmanager.devices)
                    TextButton(
                        onPressed: () {
                          widget._bluetoothmanager
                              .connectDevice(device.address);
                        },
                        child: Text(device.name ?? device.address,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
