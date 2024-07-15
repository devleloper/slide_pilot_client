import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

// Enum to represent device availability status
enum DeviceAvailability {
  no,
  maybe,
  yes,
}

// Class to represent a device with its availability status and RSSI
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

  // Constructor to initialize and start device discovery if needed
  SelectBondedDeviceLogic(bool checkAvailability) {
    isDiscovering = checkAvailability;
    if (isDiscovering) {
      _startDiscovery();
    }

    // Get bonded devices and update their availability status
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

  // Start Bluetooth device discovery
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

  // Restart device discovery
  void restartDiscovery() {
    isDiscovering = true;
    notifyListeners();
    _startDiscovery();
  }

  // Cancel ongoing device discovery
  void cancelDiscovery() {
    _discoveryStreamSubscription?.cancel();
    notifyListeners();
  }

  // Handle device selection
  void selectDevice(BuildContext context, BluetoothDevice device) {
    Navigator.of(context).pop(device);
  }

  @override
  void dispose() {
    _discoveryStreamSubscription?.cancel();
    super.dispose();
  }
}
