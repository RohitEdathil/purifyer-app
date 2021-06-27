import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

String HOST = "wss://purifier-websocket.herokuapp.com/";

class Connector extends ChangeNotifier {
  ConnectionMode mode = ConnectionMode.bluetooth;
  WebSocket? ws;
  bool connected = false;
  double ph = 7;
  int o2 = 23;
  int time = 120;
  ErrorType error = ErrorType.noError;
  Future<bool> connect_ws() async {
    try {
      ws = await WebSocket.connect(HOST);
      send(["register", "client"]);
      send(["request", "all"]);
      ws?.listen(handle);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  void setTime(int i) {
    time = i;
    notifyListeners();
  }

  void updateTime() {
    send([
      'set',
      'time',
      {'hours': time ~/ 60, 'minutes': time % 60}
    ]);
  }

  void send(Object object) {
    if (ws != null && ws?.readyState == WebSocket.open) {
      ws?.add(jsonEncode(object));
    } else {
      connected = false;
      print('WebSocket not connected, message message not sent');
    }
  }

  void handle(dynamic e) {
    List data = List.from(jsonDecode(e));
    switch (data[0]) {
      case 'update':
        ph = double.parse(data[1]["ph"]);
        o2 = int.parse(data[1]["o2"]);
        break;
      case 'time':
        time = data[1]["hours"] * 60 + data[1]["minutes"];
        break;
      case 'error':
        if (data[1] == 'no-error') {
          error = ErrorType.noError;
        } else if (data[1] == 'ph-error') {
          error = ErrorType.phError;
        } else {
          error = ErrorType.otherError;
        }
        break;
      default:
        print("Unknown Message");
    }
    notifyListeners();
  }
}

enum ConnectionMode { bluetooth, websocket }
enum ErrorType { noError, phError, otherError }
