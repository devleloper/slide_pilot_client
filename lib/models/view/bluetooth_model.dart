import 'dart:async';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothDeviceModel {
  BluetoothDevice device;
  int? rssi;

  BluetoothDeviceModel({required this.device, this.rssi});
}

class BluetoothDeviceRepository {
  final StreamController<List<BluetoothDiscoveryResult>> _controller =
      StreamController.broadcast();
  Stream<List<BluetoothDiscoveryResult>> get devicesStream =>
      _controller.stream;
  List<BluetoothDiscoveryResult> _devices = [];

  void startDiscovery() {
    FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      _devices.add(r);
      _controller.add(_devices);
    });
  }

  void stopDiscovery() {
    _controller.close();
  }
}
