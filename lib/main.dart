import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_pilot_client/features/onboarding/onboarding.dart';
import 'package:slide_pilot_client/firebase_options.dart';
import 'features/home/home.dart';
import 'theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeFirebase();
  await _requestPermissions();
  runApp(SlidePilotApp());
}

Future<void> _initializeFirebase() async {
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    // Handle Firebase initialization error
    debugPrint('Firebase initialization error: $e');
  }
}

Future<void> _requestPermissions() async {
  try {
    await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();
  } catch (e) {
    // Handle permission request error
    debugPrint('Permission request error: $e');
  }
}

class SlidePilotApp extends StatelessWidget {
  const SlidePilotApp({super.key});

  Future<bool> _isFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen = prefs.getBool('seen') ?? false;
    if (!seen) {
      await prefs.setBool('seen', true);
    }
    return !seen;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeData(),
      home: FutureBuilder<bool>(
        future: _isFirstTime(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          } else {
            bool isFirstTime = snapshot.data ?? true;
            return isFirstTime ? const OnboardingScreen() : const HomePage();
          }
        },
      ),
    );
  }
}
