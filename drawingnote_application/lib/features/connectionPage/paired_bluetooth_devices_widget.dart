import 'package:flutter/material.dart';
import '../../services/bluetoothmanager.dart';

class PairedBluetoothDevicesWidget extends StatelessWidget {
  final Bluetoothmanager _bluetoothmanager;

  const PairedBluetoothDevicesWidget({
    super.key,
    required Bluetoothmanager bluetoothmanager,
  }) : _bluetoothmanager = bluetoothmanager;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          const Text('연결할 기기를 선택하세요',
              style: TextStyle(
                fontFamily: 'title_font',
                fontSize: 20,
              )),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  for (var device in _bluetoothmanager.devices)
                    TextButton(
                        onPressed: () {
                          _bluetoothmanager.connectDevice(device.address);
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
