import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:purifier/uuids.dart';

class Connector extends ChangeNotifier {
  static const String deviceId = "E0:5A:1B:75:E4:E6";

  // Global states
  bool connected = false;
  bool isScanning = true;

  // Initial values
  double ph = 7;
  int o2 = 23;
  ErrorType error = ErrorType.noError;
  int time = 120;
  int light = 0;
  int auto = 0;

  // Initializes library
  FlutterReactiveBle ble = FlutterReactiveBle();

  // Initializes Characteristics
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
  final lightCharacteristic = QualifiedCharacteristic(
      characteristicId: LIGHT_ON, serviceId: SENSORS, deviceId: deviceId);
  final autoCharacteristic = QualifiedCharacteristic(
      characteristicId: AUTO, serviceId: SENSORS, deviceId: deviceId);

  /// Reconnects to the GATT Server
  void reconnect() {
    isScanning = true;
    notifyListeners();
    connect();
  }

  /// Connects to the Server
  Future<void> connect() async {
    print("Connect Called");
    // Requests for permission if doesn't already have
    permissions();

    // Connects to the server
    ble
        .connectToDevice(
      id: deviceId,
      connectionTimeout: Duration(seconds: 10),
    )
        // Listens for events
        .listen((event) {
      // Updates states on disconnected
      if (event.connectionState == DeviceConnectionState.disconnected) {
        disconnected();
      }

      // Things to do on getting connected
      if (event.connectionState == DeviceConnectionState.connected) {
        print("Connected");

        // Fetches current time
        final currentTime = DateTime.now();

        // Sends the current time to device
        ble.writeCharacteristicWithoutResponse(clock, value: [
          currentTime.year - 2000,
          currentTime.month,
          currentTime.day,
          currentTime.hour,
          currentTime.minute,
          currentTime.second,
        ]);

        // Reads the current start time for "Lights On"
        ble.readCharacteristic(schedule).then((value) {
          time = value[0] * 60 + value[1];
        });

        // Reads the current pH
        ble
            .readCharacteristic(phCharacteristic)
            .then((value) => ph = value[0] / 10);

        // Reads the current o2 level
        ble.readCharacteristic(o2Characteristic).then((value) => o2 = value[0]);

        // Reads for the current error state
        ble
            .readCharacteristic(errorCharacteristic)
            .then((value) => error = errorType(value[0]));

        // Reads the current light state
        ble
            .readCharacteristic(lightCharacteristic)
            .then((value) => light = value[0]);

        // Reads if mode is auto
        ble
            .readCharacteristic(autoCharacteristic)
            .then((value) => auto = value[0]);

        // Starts listening for errors
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
    if (!await Permission.bluetoothConnect.isGranted) {
      await Permission.bluetoothConnect.request();
    }
  }

  void setTime(int t) {
    time = t;
    notifyListeners();
  }

  void toggleLight() {
    light = light == 0 ? 1 : 0;
    ble.writeCharacteristicWithResponse(lightCharacteristic, value: [light]);
    notifyListeners();
  }

  void toggleAuto() {
    auto = auto == 0 ? 1 : 0;
    ble.writeCharacteristicWithResponse(autoCharacteristic, value: [auto]);
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
