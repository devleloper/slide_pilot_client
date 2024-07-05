import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

class DiscoveryLogic extends ChangeNotifier {
  StreamSubscription<BluetoothDiscoveryResult>? _streamSubscription;
  List<BluetoothDiscoveryResult> results = <BluetoothDiscoveryResult>[];
  bool isDiscovering = false;

  DiscoveryLogic(bool start) {
    isDiscovering = start;
    if (isDiscovering) {
      _startDiscovery();
    }
  }

  Future<void> _restartDiscovery() async {
    final status = await Permission.bluetoothScan.status;
    if (status.isGranted) {
      results.clear();
      isDiscovering = true;
      notifyListeners();
      _startDiscovery();
    } else {
      await Permission.bluetoothScan.request();
    }
  }

  void _startDiscovery() {
    _streamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      results.add(r);
      notifyListeners();
    });

    _streamSubscription!.onDone(() {
      isDiscovering = false;
      notifyListeners();
    });
  }

  void cancelDiscovery() {
    _streamSubscription?.cancel();
    notifyListeners();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  Future<void> handleDeviceTap(
      BuildContext context, BluetoothDiscoveryResult result) async {
    bool? bonded = false;
    try {
      if (result.device.isBonded) {
        await FlutterBluetoothSerial.instance
            .removeDeviceBondWithAddress(result.device.address);
      } else {
        bonded = await FlutterBluetoothSerial.instance
            .bondDeviceAtAddress(result.device.address);
      }

      if (!context.mounted) return;

      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(bonded == true ? 'Pairing' : 'Unpairing'),
            content: Text(
                '${bonded == true ? 'Pairing' : 'Unpairing'} with ${result.device.name} has succeeded.'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

      results[results.indexOf(result)] = BluetoothDiscoveryResult(
          device: BluetoothDevice(
            name: result.device.name ?? '',
            address: result.device.address,
            type: result.device.type,
            bondState: bonded == true
                ? BluetoothBondState.bonded
                : BluetoothBondState.none,
          ),
          rssi: result.rssi);
      notifyListeners();
    } catch (ex) {
      if (!context.mounted) return;
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text('Error occurred while bonding'),
            content: Text(ex.toString()),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void restartDiscovery() {
    _restartDiscovery();
  }
}
