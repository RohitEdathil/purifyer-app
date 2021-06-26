import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

String HOST = "wss://purifier-websocket.herokuapp.com/";

class Connector extends ChangeNotifier {
  ConnectionMode mode = ConnectionMode.bluetooth;
  WebSocket? ws;
  bool connected = false;

  Future<bool> connect_ws() async {
    try {
      ws = await WebSocket.connect(HOST);
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
