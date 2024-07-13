import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

enum DeviceAvailability {
  no,
  maybe,
  yes,
}

class DeviceWithAvailability {
  BluetoothDevice device;
  DeviceAvailability availability;
  int? rssi;

  DeviceWithAvailability(this.device, this.availability, [this.rssi]);
}

class SelectBondedDeviceLogic extends ChangeNotifier {
  List<DeviceWithAvailability> devices = <DeviceWithAvailability>[];
  StreamSubscription<BluetoothDiscoveryResult>? _discoveryStreamSubscription;
  bool isDiscovering = false;

  SelectBondedDeviceLogic(bool checkAvailability) {
    isDiscovering = checkAvailability;
    if (isDiscovering) {
      _startDiscovery();
    }

    FlutterBluetoothSerial.instance.getBondedDevices().then((bondedDevices) {
      devices = bondedDevices
          .map((device) => DeviceWithAvailability(
              device,
              checkAvailability
                  ? DeviceAvailability.maybe
                  : DeviceAvailability.yes))
          .toList();
      notifyListeners();
    });
  }

  void _startDiscovery() {
    _discoveryStreamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      for (var device in devices) {
        if (device.device == r.device) {
          device.availability = DeviceAvailability.yes;
          device.rssi = r.rssi;
        }
      }
      notifyListeners();
    });

    _discoveryStreamSubscription!.onDone(() {
      isDiscovering = false;
      notifyListeners();
    });
  }

  void restartDiscovery() {
    isDiscovering = true;
    notifyListeners();
    _startDiscovery();
  }

  void cancelDiscovery() {
    _discoveryStreamSubscription?.cancel();
    notifyListeners();
  }

  void selectDevice(BuildContext context, BluetoothDevice device) {
    Navigator.of(context).pop(device);
  }

  @override
  void dispose() {
    _discoveryStreamSubscription?.cancel();
    super.dispose();
  }
}
