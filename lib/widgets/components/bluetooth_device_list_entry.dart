import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothDeviceListEntry extends ListTile {
  BluetoothDeviceListEntry({
    super.key,
    required BluetoothDevice device,
    final int? rssi,
    super.onTap,
    super.onLongPress,
    super.enabled,
  }) : super(
          leading: const Icon(
            CupertinoIcons.device_desktop,
          ),
          title: Text(
            device.name ?? "Unknown device",
            style: const TextStyle(
              fontFamily: 'RedHatDisplayRegular',
              fontSize: 16,
              letterSpacing: 1,
            ),
          ),
          subtitle: Text(
            device.address.toString(),
            style: const TextStyle(
              fontFamily: 'RedHatDisplayRegular',
              fontSize: 16,
              letterSpacing: 1,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (rssi != null)
                Container(
                  margin: const EdgeInsets.all(8.0),
                  child: DefaultTextStyle(
                    style: () {
                      if (rssi >= -35) {
                        return TextStyle(color: Colors.greenAccent[700]);
                      } else if (rssi >= -45) {
                        return TextStyle(
                          color: Color.lerp(Colors.greenAccent[700],
                              Colors.lightGreen, -(rssi + 35) / 10)!,
                        );
                      } else if (rssi >= -55) {
                        return TextStyle(
                          color: Color.lerp(Colors.lightGreen, Colors.lime[600],
                              -(rssi + 45) / 10)!,
                        );
                      } else if (rssi >= -65) {
                        return TextStyle(
                          color: Color.lerp(Colors.lime[600], Colors.amber,
                              -(rssi + 55) / 10)!,
                        );
                      } else if (rssi >= -75) {
                        return TextStyle(
                          color: Color.lerp(Colors.amber,
                              Colors.deepOrangeAccent, -(rssi + 65) / 10)!,
                        );
                      } else if (rssi >= -85) {
                        return TextStyle(
                          color: Color.lerp(Colors.deepOrangeAccent,
                              Colors.redAccent, -(rssi + 75) / 10)!,
                        );
                      } else {
                        return const TextStyle(color: Colors.redAccent);
                      }
                    }(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(rssi.toString()),
                        const Text(
                          'dBm',
                          style: TextStyle(
                            fontFamily: 'RedHatDisplayRegular',
                            fontSize: 16,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(width: 4),
              if (device.isBonded)
                const Icon(
                  CupertinoIcons.link,
                ),
            ],
          ),
        );
}
