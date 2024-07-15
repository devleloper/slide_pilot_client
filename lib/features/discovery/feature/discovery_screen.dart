import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:provider/provider.dart';
import '../../../widgets/widgets.dart';
import 'discovery_logic.dart';

// Entry point for the discovery page, initiates DiscoveryLogic.
class DiscoveryPage extends StatelessWidget {
  final bool start;

  const DiscoveryPage({super.key, this.start = true});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DiscoveryLogic(start),
      child: const DiscoveryScreen(),
    );
  }
}

// UI for displaying discovered Bluetooth devices.
class DiscoveryScreen extends StatelessWidget {
  const DiscoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Provider.of<DiscoveryLogic>(context);
    final results = logic.results;

    return Scaffold(
      appBar: AppBar(
        title: logic.isDiscovering
            ? const Text('Discovering devices')
            : const Text('Discovered devices'),
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
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: results.length,
        itemBuilder: (BuildContext context, index) {
          BluetoothDiscoveryResult result = results[index];
          return BluetoothDeviceListEntry(
            device: result.device,
            rssi: result.rssi,
            onTap: () => logic.handleDeviceTap(context, result),
          );
        },
      ),
    );
  }
}
