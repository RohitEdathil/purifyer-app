import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

// Service UUIDs
final SENSORS = Uuid.parse('5383b89a-3522-4d06-902b-d81eb6f1fe80');
final ERROR = Uuid.parse('45585d0d-7ca0-4dfb-beee-635a12ad0a1c');
final TIME = Uuid.parse('4dece2b8-eb84-4ec2-b107-55b2ba01ccf3');

// Characteristic UUIDs
final SCHEDULE = Uuid.parse('c872dd7d-b16e-4001-b183-2a92b3881a51');
final CLOCK = Uuid.parse('18c4523c-bc22-43cb-8c8d-f35feda7f258');
final O2 = Uuid.parse('54aed7c2-99d4-4551-b5aa-9ef9a31c61f5');
final PH = Uuid.parse('c0b7d202-cf73-4913-9c61-f4b50eb98678');
final CODE = Uuid.parse('364e6a2c-ed70-405f-bed9-8413bfbf2ea0');
final LIGHT_ON = Uuid.parse('a8b1030a-6d47-11ec-90d6-0242ac120003');
final AUTO = Uuid.parse('6719db7c-a03e-11ec-b909-0242ac120002');
