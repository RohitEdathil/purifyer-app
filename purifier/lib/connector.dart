import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

class Connector extends ChangeNotifier {
  ConnectionMode mode = ConnectionMode.bluetooth;
  WebSocket? ws;
  bool connected = false;

  Future<bool> connect_ws(String host, String port) async {
    print(Uri.parse("ws://$host${port != '' ? ":$port" : ''}").port);
    try {
      ws = await WebSocket.connect(
        'ws://$host${port != '' ? ":$port" : ''}',
      );
      send({"register": "client"});
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  void send(Object object) {
    ws?.add(jsonEncode(object));
  }
}

enum ConnectionMode { bluetooth, websocket }
