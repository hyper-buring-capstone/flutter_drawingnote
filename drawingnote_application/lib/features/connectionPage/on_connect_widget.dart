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
  void enter() {
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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: enter,
          child: const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "시작",
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'title_font',
                fontSize: 80,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            widget._bluetoothmanager.disconnectDevice();
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text('연결 종료',
                style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'title_font',
                    color: Colors.red[300])),
          ),
        ),
      ],
    );
  }
}
