import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:purifier/uuids.dart';

class Connector extends ChangeNotifier {
  static const String deviceId = "80:7D:3A:B8:2F:76";

  bool connected = false;
  bool isScanning = true;

  double ph = 7;
  int o2 = 23;
  ErrorType error = ErrorType.noError;
  int time = 120;

  FlutterReactiveBle ble = FlutterReactiveBle();
  final clock = QualifiedCharacteristic(
      characteristicId: CLOCK, serviceId: TIME, deviceId: deviceId);
  final schedule = QualifiedCharacteristic(
      characteristicId: SCHEDULE, serviceId: TIME, deviceId: deviceId);
  final phCharacteristic = QualifiedCharacteristic(
      characteristicId: PH, serviceId: SENSORS, deviceId: deviceId);
  final o2Characteristic = QualifiedCharacteristic(
      characteristicId: O2, serviceId: SENSORS, deviceId: deviceId);
  final errorCharacteristic = QualifiedCharacteristic(
      characteristicId: CODE, serviceId: ERROR, deviceId: deviceId);

  Future<void> connect({re = false}) async {
    int preScan = 2;
    if (re) {
      preScan = 10;
      isScanning = true;
      notifyListeners();
    }
    permissions();
    ble
        .connectToAdvertisingDevice(
      id: deviceId,
      withServices: [TIME, ERROR, SENSORS],
      prescanDuration: Duration(seconds: preScan),
      connectionTimeout: Duration(seconds: 10),
    )
        .listen((event) {
      if (event.connectionState == DeviceConnectionState.disconnected) {
        disconnected();
      }
      if (event.connectionState == DeviceConnectionState.connected) {
        final currentTime = DateTime.now();
        ble.writeCharacteristicWithoutResponse(clock, value: [
          currentTime.year - 2000,
          currentTime.month,
          currentTime.day,
          currentTime.hour,
          currentTime.minute,
          currentTime.second,
        ]);
        ble.readCharacteristic(schedule).then((value) {
          time = value[0] * 60 + value[1];
        });
        ble.subscribeToCharacteristic(errorCharacteristic).listen((value) {
          error = errorType(value[0]);
          notifyListeners();
        });
        ble.subscribeToCharacteristic(phCharacteristic).listen((value) {
          ph = value[0] / 10;
          notifyListeners();
        });
        ble.subscribeToCharacteristic(o2Characteristic).listen((value) {
          o2 = value[0];
          notifyListeners();
        });
        isScanning = false;
        connected = true;
        notifyListeners();
      }
    }).onDone(() {
      isScanning = false;
      notifyListeners();
    });
  }

  void permissions() async {
    await Permission.bluetooth.request();
    await Permission.location.request();
  }

  void setTime(int t) {
    time = t;
    notifyListeners();
  }

  void disconnected() {
    connected = false;
    notifyListeners();
  }

  void sendTime() {
    ble.writeCharacteristicWithResponse(schedule,
        value: [time ~/ 60, time % 60]);
  }
}

enum ErrorType { noError, phError, unknownError }

ErrorType errorType(int code) {
  switch (code) {
    case 0:
      return ErrorType.noError;
    case 1:
      return ErrorType.phError;
    default:
      return ErrorType.unknownError;
  }
}
