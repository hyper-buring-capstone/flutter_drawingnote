import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../notePage/note_page.dart';
import '../../services/httpmanager.dart';
import '../../services/bluetoothmanager.dart';
import '../../datas/pagedata.dart';
import '../../datas/drawingdata.dart';
import 'paired_bluetooth_devices_widget.dart';

class OnConnectWidget extends StatefulWidget {
  final Httpmanager _httpmanager;
  final Bluetoothmanager _bluetoothmanager;
  final Pagedata _pagedata;
  final DrawingData _drawingData;

  const OnConnectWidget(
      {super.key,
      required httpmanager,
      required bluetoothmanager,
      required pagedata,
      required drawingData})
      : _httpmanager = httpmanager,
        _bluetoothmanager = bluetoothmanager,
        _pagedata = pagedata,
        _drawingData = drawingData;

  @override
  State<OnConnectWidget> createState() => _OnConnectWidgetState();
}

class _OnConnectWidgetState extends State<OnConnectWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        (widget._bluetoothmanager.deviceIsConnected() &&
                !widget._httpmanager.isIpAddressNull())
            ? const Text('Ready to connect')
            : Text(widget._bluetoothmanager.deviceStatusString),
        ElevatedButton(
            onPressed: (widget._bluetoothmanager.deviceIsConnected() &&
                    !widget._httpmanager.isIpAddressNull())
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotePage(
                          bluetoothmanager: widget._bluetoothmanager,
                          httpmanager: widget._httpmanager,
                          pagedata: widget._pagedata,
                          drawingData: widget._drawingData,
                        ),
                      ), //클릭시 이동
                    );
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: (widget._bluetoothmanager.deviceIsConnected() &&
                      !widget._httpmanager.isIpAddressNull())
                  ? Colors.blue
                  : null,
            ),
            child: const Text("Start")),
      ],
    );
  }
}
