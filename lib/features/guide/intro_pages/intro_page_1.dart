import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:slide_pilot_client/theme/theme.dart';
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

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      color: theme.primaryColor,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            Text(
              'First: Setting up an Android device 📱',
              style: GoogleFonts.redHatDisplay(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'To ensure the proper functioning of the Slide Pilot app, please grant the necessary permissions listed below. This will allow the app to seamlessly connect and control your presentations.',
              style: GoogleFonts.redHatDisplay(
                fontSize: 16,
                color: Colors.white,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 32),
            CustomTextGuideButton(
              icon: isBluetoothGranted
                  ? CupertinoIcons.checkmark_alt_circle_fill
                  : CupertinoIcons.bluetooth,
              title: isBluetoothGranted
                  ? 'Bluetooth Permission Granted'
                  : 'Grant Bluetooth Permission',
              onTap: () => _requestPermission(Permission.bluetooth, () {
                setState(() {
                  isBluetoothGranted = true;
                });
              }),
            ),
            const SizedBox(height: 16),
            CustomTextGuideButton(
              icon: isBluetoothConnectGranted
                  ? CupertinoIcons.checkmark_alt_circle_fill
                  : CupertinoIcons.bluetooth,
              title: isBluetoothConnectGranted
                  ? 'Bluetooth Connect Permission Granted'
                  : 'Grant Bluetooth Connect Permission',
              onTap: () => _requestPermission(Permission.bluetoothConnect, () {
                setState(() {
                  isBluetoothConnectGranted = true;
                });
              }),
            ),
            const SizedBox(height: 16),
            CustomTextGuideButton(
              icon: isBluetoothScanGranted
                  ? CupertinoIcons.checkmark_alt_circle_fill
                  : CupertinoIcons.bluetooth,
              title: isBluetoothScanGranted
                  ? 'Bluetooth Scan Permission Granted'
                  : 'Grant Bluetooth Scan Permission',
              onTap: () => _requestPermission(Permission.bluetoothScan, () {
                setState(() {
                  isBluetoothScanGranted = true;
                });
              }),
            ),
            const SizedBox(height: 16),
            CustomTextGuideButton(
              icon: isLocationGranted
                  ? CupertinoIcons.checkmark_alt_circle_fill
                  : CupertinoIcons.location_solid,
              title: isLocationGranted
                  ? 'Location Permission Granted'
                  : 'Grant Coarse Location Permission',
              onTap: () => _requestPermission(Permission.location, () {
                setState(() {
                  isLocationGranted = true;
                });
              }),
            ),
          ],
        ),
      ),
    );
  }
}
