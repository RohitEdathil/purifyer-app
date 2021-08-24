import 'package:flutter/foundation.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:purifier/uuids.dart';

class Connector extends ChangeNotifier {
  bool connected = false;

  double ph = 7;
  int o2 = 23;
  ErrorType error = ErrorType.noError;
  int time = 120;
  BluetoothCharacteristic? scheduleCharacteristic;

  Future<void> connect() async {
    final bluetooth = FlutterBlue.instance;
    print(await bluetooth.connectedDevices);
    await bluetooth.startScan(
      timeout: Duration(seconds: 10),
      withServices: [TIME, SENSORS, ERROR],
    );
    bluetooth.scanResults.listen((results) async {
      if (results.isNotEmpty) {
        final device = results[0].device;
        await device.connect(timeout: Duration(seconds: 10));

        device.state.listen((state) async {
          if (state == BluetoothDeviceState.disconnected) {
            disconnected();
          }
        });

        device.discoverServices().then((services) {
          services.forEach((service) {
            // Time Service
            if (service.uuid == TIME) {
              service.characteristics.forEach((characteristic) async {
                // Clock Syncing
                if (characteristic.uuid == CLOCK) {
                  final time = DateTime.now().toUtc();
                  await characteristic.write([
                    time.year,
                    time.month,
                    time.day,
                    time.hour,
                    time.minute,
                    time.second,
                  ]);
                }
                // Schedule Characteristic
                if (characteristic.uuid == SCHEDULE) {
                  scheduleCharacteristic = characteristic;
                  final current = await characteristic.read();
                  time = current[0] * 60 + current[1];
                }
              });
            }

            // Sensors Service
            if (service.uuid == SENSORS) {
              service.characteristics.forEach((characteristic) {
                // Ph Characteristic
                if (characteristic.uuid == PH) {
                  characteristic.value.listen((value) async {
                    ph = value[0] / 10;
                    notifyListeners();
                  });
                }
                // O2 Characteristic
                if (characteristic.uuid == O2) {
                  characteristic.value.listen((value) async {
                    o2 = value[0];
                    notifyListeners();
                  });
                }
              });
            }

            // Error Service
            if (service.uuid == ERROR) {
              service.characteristics.forEach((characteristic) {
                // Error Characteristic
                if (characteristic.uuid == CODE) {
                  characteristic.value.listen((value) async {
                    error = errorType(value[0]);
                  });
                }
              });
            }
          });
        });
        connected = true;
        bluetooth.stopScan();
        notifyListeners();
      }
    });
    bluetooth.stopScan();
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
    scheduleCharacteristic?.write([time ~/ 60, time % 60]);
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
