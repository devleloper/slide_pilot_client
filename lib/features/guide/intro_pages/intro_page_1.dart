import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../features.dart';

class IntroPage1 extends StatefulWidget {
  const IntroPage1({super.key});

  @override
  _IntroPage1State createState() => _IntroPage1State();
}

class _IntroPage1State extends State<IntroPage1> {
  bool isBluetoothGranted = false;
  bool isBluetoothConnectGranted = false;
  bool isBluetoothScanGranted = false;
  bool isLocationGranted = false;
  bool isNotificationGranted = false;

  // Request permission and update state when granted
  Future<void> _requestPermission(
      Permission permission, Function onGranted) async {
    final status = await permission.request();
    if (status.isGranted) {
      onGranted();
    } else if (status.isDenied) {
      // Permission denied
    } else if (status.isPermanentlyDenied) {
      // Permission permanently denied, open settings
      await openAppSettings();
    }
  }

  void _showLocationPermissionDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Column(
          children: [
            Icon(CupertinoIcons.location_solid,
                size: 40, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            const Text('Location Permission Required'),
          ],
        ),
        content: const Text(
            'This app collects location data to enable seamless connection and control of your presentations even when the app is closed or not in use.'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Deny'),
          ),
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop();
              _requestPermission(Permission.location, () {
                setState(() {
                  isLocationGranted = true;
                });
              });
            },
            child: const Text(
              'Allow',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      color: theme.primaryColor,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              Text(
                'First: Setting up an Android device 📱',
                style: theme.textTheme.headlineMedium
                    ?.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'To ensure the proper functioning of the Slide Pilot app, please grant the necessary permissions listed below. This will allow the app to seamlessly connect and control your presentations.',
                style:
                    theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 32),
              CustomTextGuideButton(
                icon: isBluetoothConnectGranted
                    ? CupertinoIcons.checkmark_alt_circle_fill
                    : CupertinoIcons.bluetooth,
                title: isBluetoothConnectGranted
                    ? 'Permission Granted'
                    : 'Grant Bluetooth Permission',
                onTap: () =>
                    _requestPermission(Permission.bluetoothConnect, () {
                  setState(() {
                    isBluetoothConnectGranted = true;
                  });
                }),
              ),
              const SizedBox(height: 16),
              CustomTextGuideButton(
                icon: isLocationGranted
                    ? CupertinoIcons.checkmark_alt_circle_fill
                    : CupertinoIcons.location_solid,
                title: isLocationGranted
                    ? 'Permission Granted'
                    : 'Grant Location Permission',
                onTap: _showLocationPermissionDialog,
              ),
              const SizedBox(height: 16),
              CustomTextGuideButton(
                icon: isNotificationGranted
                    ? CupertinoIcons.checkmark_alt_circle_fill
                    : CupertinoIcons.bell_solid,
                title: isNotificationGranted
                    ? 'Permission Granted'
                    : 'Grant Notification Permission',
                onTap: () => _requestPermission(Permission.notification, () {
                  setState(() {
                    isNotificationGranted = true;
                  });
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
