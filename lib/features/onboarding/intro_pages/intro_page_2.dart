import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:slide_pilot_client/theme/theme.dart';
import '../../../widgets/components/custom_text_button.dart';

class IntroPage2 extends StatefulWidget {
  const IntroPage2({super.key});

  @override
  _IntroPage2State createState() => _IntroPage2State();
}

class _IntroPage2State extends State<IntroPage2> {
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            CustomTextButton(
              title: isBluetoothGranted
                  ? 'Bluetooth Permission Granted'
                  : 'Grant Bluetooth Permission',
              onTap: () => _requestPermission(Permission.bluetooth, () {
                setState(() {
                  isBluetoothGranted = true;
                });
              }),
              buttonShadow: AppPresets().whiteShadow,
              buttonColor: Colors.white,
              textColor: theme.primaryColor,
            ),
            const SizedBox(height: 16),
            CustomTextButton(
              title: isBluetoothConnectGranted
                  ? 'Bluetooth Connect Permission Granted'
                  : 'Grant Bluetooth Connect Permission',
              onTap: () => _requestPermission(Permission.bluetoothConnect, () {
                setState(() {
                  isBluetoothConnectGranted = true;
                });
              }),
              buttonShadow: AppPresets().whiteShadow,
              buttonColor: Colors.white,
              textColor: theme.primaryColor,
            ),
            const SizedBox(height: 16),
            CustomTextButton(
              title: isBluetoothScanGranted
                  ? 'Bluetooth Scan Permission Granted'
                  : 'Grant Bluetooth Scan Permission',
              onTap: () => _requestPermission(Permission.bluetoothScan, () {
                setState(() {
                  isBluetoothScanGranted = true;
                });
              }),
              buttonShadow: AppPresets().whiteShadow,
              buttonColor: Colors.white,
              textColor: theme.primaryColor,
            ),
            const SizedBox(height: 16),
            CustomTextButton(
              title: isLocationGranted
                  ? 'Location Permission Granted'
                  : 'Grant Coarse Location Permission',
              onTap: () => _requestPermission(Permission.location, () {
                setState(() {
                  isLocationGranted = true;
                });
              }),
              buttonShadow: AppPresets().whiteShadow,
              buttonColor: Colors.white,
              textColor: theme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
