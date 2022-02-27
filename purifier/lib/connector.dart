import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:purifier/uuids.dart';

class Connector extends ChangeNotifier {
  static const String deviceId = "C8:C9:A3:FA:57:EE";

  bool connected = false;
  bool isScanning = true;

  double ph = 7;
  int o2 = 23;
  ErrorType error = ErrorType.noError;
  int time = 120;
  int valve = 0;
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
  final valveCharacteristic = QualifiedCharacteristic(
      characteristicId: VALVE, serviceId: SENSORS, deviceId: deviceId);
  void reconnect() {
    isScanning = true;
    notifyListeners();
    connect();
  }

  Future<void> connect() async {
    print("Connect Called");
    permissions();
    ble
        .connectToAdvertisingDevice(
      id: deviceId,
      withServices: [TIME, ERROR, SENSORS],
      prescanDuration: Duration(seconds: 5),
    )
        .listen((event) {
      if (event.connectionState == DeviceConnectionState.disconnected) {
        disconnected();
      }
      if (event.connectionState == DeviceConnectionState.connected) {
        print("Connected");
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
        ble
            .readCharacteristic(phCharacteristic)
            .then((value) => ph = value[0] / 10);
        ble.readCharacteristic(o2Characteristic).then((value) => o2 = value[0]);
        ble
            .readCharacteristic(errorCharacteristic)
            .then((value) => error = errorType(value[0]));
        ble.subscribeToCharacteristic(errorCharacteristic).listen((value) {
          error = errorType(value[0]);
          notifyListeners();
        });
        ble
            .readCharacteristic(valveCharacteristic)
            .then((value) => valve = value[0]);
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
      print("Scan Ended");
      isScanning = false;
      notifyListeners();
    });
  }

  void permissions() async {
    if (!await Permission.bluetooth.isGranted) {
      await Permission.bluetooth.request();
    }
    if (!await Permission.location.isGranted) {
      await Permission.location.request();
    }
  }

  void setTime(int t) {
    time = t;
    notifyListeners();
  }

  void toggleValve() {
    valve = valve == 0 ? 1 : 0;
    ble.writeCharacteristicWithResponse(valveCharacteristic, value: [valve]);
    notifyListeners();
  }

  void disconnected() {
    print("Disconnected");
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
