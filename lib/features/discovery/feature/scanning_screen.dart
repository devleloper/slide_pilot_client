import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:provider/provider.dart';
import '../../../widgets/widgets.dart';
import 'scanning_logic.dart';

class DiscoveryPage extends StatelessWidget {
  final bool start;

  const DiscoveryPage({super.key, this.start = true});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ScanningLogic(start),
      child: DiscoveryScreen(),
    );
  }
}

class DiscoveryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scanningLogic = Provider.of<ScanningLogic>(context);
    final results = scanningLogic.results;

    return Scaffold(
      appBar: AppBar(
        title: scanningLogic.isDiscovering
            ? const Text('Scanning for devices')
            : const Text('Devices detected'),
        actions: <Widget>[
          scanningLogic.isDiscovering
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
                  onPressed: scanningLogic.restartDiscovery,
                )
        ],
      ),
      body: ListView.builder(
        itemCount: results.length,
        itemBuilder: (BuildContext context, index) {
          BluetoothDiscoveryResult result = results[index];
          return BluetoothDeviceListEntry(
            device: result.device,
            rssi: result.rssi,
            onTap: () => scanningLogic.handleDeviceTap(context, result),
          );
        },
      ),
    );
  }
}
