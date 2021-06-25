import 'dart:io';
import 'package:flutter/foundation.dart';

class Connector extends ChangeNotifier {
  ConnectionMode mode = ConnectionMode.bluetooth;
  WebSocket? ws;
  bool connected = false;

  Future<bool> connect_ws(String host, String port) async {
    print("$host $port");
    try {
      ws = await WebSocket.connect(
        'ws://$host:$port',
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}

enum ConnectionMode { bluetooth, websocket }
