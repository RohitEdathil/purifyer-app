import 'package:flutter/foundation.dart';
import 'package:flutter_blue/flutter_blue.dart';

class Connector extends ChangeNotifier {
  bool connected = false;
  double ph = 7;
  int o2 = 23;
  int time = 120;
  ErrorType error = ErrorType.noError;

  Future<bool> connect() async {
    final bluetooth = FlutterBlue.instance;
    bluetooth.startScan(timeout: Duration(seconds: 10));
    bluetooth.scanResults.listen((results) {
      print(results);
    });
    return false;
  }

  void setTime(int t) {
    time = t;
    notifyListeners();
  }

  void sendTime() {
    print("*Sends time*");
  }
}

enum ErrorType { noError, phError, otherError }
