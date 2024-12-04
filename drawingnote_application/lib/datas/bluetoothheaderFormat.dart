//bluetooth 송수신 시의 header format을 정의

class BluetoothHeaderformat {
  //랩탑 -> 모바일 수신
  //SERVERIP&&102.10.43.12
  static String receiveIp = 'HEADER:SERVERIP'; //서버 IP 수신
  static String receivePagenumber = 'HEADER:PAGE'; //페이지 번호 수신
  static String receiveNoteOffHeader = 'HEADER:NOTESTATE'; //노트 꺼짐 수신
  static String receiveNoteOffBody = 'OFF'; //노트 꺼짐 수신
  //HEADER:NOTESTATE&&OFF

  //모바일 -> 랩탑 송신
  static String drawingHeader = "HEADER:DRAWING"; //drawing data 송신
  //static String drawigHeader = "HEADER:DRAWING (panweight) (pancolor HEXCODE rgba)" //펜 변경 구현 후
  static String eraserHeader = "HEADER:ERASER"; //지우개 data 송신
  static String panningHeader = "HEADER:PANNING"; //화면 이동 데이터 포멧
  static String widthHeader = "HEADER:WIDTH"; //펜 굵기 변경 데이터 포멧
  static String colorHeader = "HEADER:COLOR"; //펜 색상 변경 데이터 포멧
  static String endstring = "END"; //송신 종료
  static String seperator = "&&"; //데이터 구분자
}
