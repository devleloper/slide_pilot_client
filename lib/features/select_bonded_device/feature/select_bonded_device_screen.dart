import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/widgets.dart';
import 'select_bonded_device_logic.dart';

class SelectBondedDevicePage extends StatelessWidget {
  final bool checkAvailability;

  const SelectBondedDevicePage({super.key, this.checkAvailability = true});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SelectBondedDeviceLogic(checkAvailability),
      child: const SelectBondedDeviceScreen(),
    );
  }
}

class SelectBondedDeviceScreen extends StatelessWidget {
  const SelectBondedDeviceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Provider.of<SelectBondedDeviceLogic>(context);
    final devices = logic.devices;

    List<BluetoothDeviceListEntry> list = devices.map((device) {
      return BluetoothDeviceListEntry(
        device: device.device,
        rssi: device.rssi,
        enabled: device.availability == DeviceAvailability.yes,
        onTap: () {
          logic.selectDevice(context, device.device);
        },
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select device'),
        actions: <Widget>[
          logic.isDiscovering
              ? FittedBox(
                  child: Container(
                      margin: const EdgeInsets.all(16.0),
                      child: const CupertinoActivityIndicator(
                        color: Colors.white,
                      )))
              : IconButton(
                  icon: const Icon(
                    CupertinoIcons.refresh,
                  ),
                  onPressed: logic.restartDiscovery,
                )
        ],
      ),
      body: ListView(children: list),
    );
  }
}
