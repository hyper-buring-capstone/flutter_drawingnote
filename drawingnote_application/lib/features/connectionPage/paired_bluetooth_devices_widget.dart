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
    return Column(
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
                    for (var device in _bluetoothmanager.devices)
                      TextButton(
                          onPressed: () {
                            _bluetoothmanager.connectDevice(device.address);
                          },
                          child: Text(device.name ?? device.address))
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
