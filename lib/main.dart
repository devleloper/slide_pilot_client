import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:slide_pilot_client/features/onboarding/onboarding.dart';
import 'package:slide_pilot_client/firebase_options.dart';
import 'features/features.dart';
import 'theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await requestPermissions();
  runApp(SlidePilotApp());
}

Future<void> requestPermissions() async {
  await [
    Permission.bluetooth,
    Permission.bluetoothScan,
    Permission.bluetoothConnect,
    Permission.location,
  ].request();
}

class SlidePilotApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isFirstTime = true;
    return MaterialApp(
      home: const OnboardingScreen(),
      debugShowCheckedModeBanner: false,
      theme: themeData(),
    );
  }
}
