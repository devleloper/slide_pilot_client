import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_pilot_client/features/guide/guide.dart';
import 'package:slide_pilot_client/models/view/firebase_options.dart';
import 'features/home/home.dart';
import 'theme/theme.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

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
    final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeData(),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
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
