import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_pilot_client/theme/theme.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import '../../../widgets/widgets.dart';
import '../../features.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final GlobalKey _helpButtonKey = GlobalKey();
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  String _name = "...";
  bool _isFirstTime = true;
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    super.initState();
    _checkAndShowTutorial();

    // Get the current Bluetooth state and update _bluetoothState variable
    FlutterBluetoothSerial.instance.state.then(
      (state) {
        setState(() {
          _bluetoothState = state;
        });
      },
    );

    // Check if Bluetooth is enabled, keep checking until it is enabled
    Future.doWhile(() async {
      final isEnabled = await FlutterBluetoothSerial.instance.isEnabled;
      if (isEnabled == true) {
        return false; // Exit loop if Bluetooth is enabled
      }
      await Future.delayed(const Duration(milliseconds: 0xDD));
      return true; // Continue loop if Bluetooth is not enabled
    }).then((_) {});

    // Get the Bluetooth device name and update _name variable
    FlutterBluetoothSerial.instance.name.then((name) {
      setState(() {
        _name = name ?? "...";
      });
    });

    // Subscribe to Bluetooth state changes and update _bluetoothState variable
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
      });
    });
  }

  // Check if the tutorial needs to be shown, and show it if necessary
  Future<void> _checkAndShowTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    _isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (_isFirstTime) {
      _createTutorial();
      await prefs.setBool('isFirstTime', false);
    }
  }

  // Log help button click event
  void _logHelpButtonClick() {
    _analytics.logEvent(
      name: 'help_button_click',
      parameters: <String, Object>{
        'button': 'help',
        'screen': 'home',
      },
    );
  }

  @override
  void dispose() {
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: const BottomAppBar(
        child: Opacity(
          opacity: 0.50,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Version 1.0.0',
                style: TextStyle(
                  fontFamily: 'RedHatDisplaySemiBold',
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Developed by Devlet Boltaev in Blism Solutions',
                style: TextStyle(
                  fontFamily: 'RedHatDisplaySemiBold',
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Row(
          children: [
            SvgPicture.asset(
              'assets/brand/logo_outlined.svg',
              width: 22,
              height: 22,
            ),
            const SizedBox(width: 16),
            const Text(
              'Slide Pilot',
              style: TextStyle(
                fontFamily: 'RedHatDisplaySemiBold',
                fontSize: 18,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            key: _helpButtonKey,
            icon: const Icon(
              CupertinoIcons.question_circle_fill,
            ),
            onPressed: () {
              _logHelpButtonClick();
              _showDocumentationDialog(context);
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          const SizedBox(height: 16),
          CustomSwitchListTile(
            title: 'Enable Bluetooth',
            value: _bluetoothState.isEnabled,
            onChanged: (bool value) {
              future() async {
                if (value) {
                  await FlutterBluetoothSerial.instance.requestEnable();
                } else {
                  await FlutterBluetoothSerial.instance.requestDisable();
                }
              }

              future().then((_) {
                setState(() {});
              });
            },
          ),
          const SizedBox(height: 16),
          Visibility(
            visible: _bluetoothState.isEnabled,
            child: ListTile(
              title: Text(
                "Device Name: $_name",
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Visibility(
            visible: _bluetoothState.isEnabled,
            child: ListTile(
              title: CustomTextButton(
                onTap: _bluetoothState.isEnabled
                    ? () async {
                        final BluetoothDevice? selectedDevice =
                            await Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                          return const DiscoveryPage();
                        }));

                        if (selectedDevice != null) {
                          print('Discovery -> selected ' +
                              selectedDevice.address);
                        } else {
                          print('Discovery -> no device selected');
                        }
                      }
                    : null,
                title: 'Discovery PC',
              ),
            ),
          ),
          const SizedBox(height: 16),
          Visibility(
            visible: _bluetoothState.isEnabled,
            child: ListTile(
              title: CustomTextButton(
                onTap: _bluetoothState.isEnabled
                    ? () async {
                        final BluetoothDevice? selectedDevice =
                            await Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                          return const SelectBondedDevicePage(
                              checkAvailability: true);
                        }));

                        if (selectedDevice != null) {
                          print(
                              'Connect -> selected ' + selectedDevice.address);
                          _startRemoteConnection(context, selectedDevice);
                        } else {
                          print('Connect -> no device selected');
                        }
                      }
                    : null,
                title: 'Connect to paired PC to control',
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // Start remote connection to the device
  void _startRemoteConnection(BuildContext context, BluetoothDevice server) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return RemoteControlPage(server: server);
    }));
  }

  // Show documentation dialog
  void _showDocumentationDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Guide"),
        content: const Text("Would you like to read the guide?"),
        actions: [
          CupertinoDialogAction(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            child: const Text("Open"),
            onPressed: () {
              Navigator.of(context).pop();
              _navigateToOnboarding(context);
            },
          ),
        ],
      ),
    );
  }

  // Navigate to the onboarding screen
  void _navigateToOnboarding(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const OnboardingScreen(),
      ),
    );
  }

  // Create and show tutorial
  Future<void> _createTutorial() async {
    final targets = [
      TargetFocus(
        identify: 'helpButton',
        keyTarget: _helpButtonKey,
        alignSkip: Alignment.bottomCenter,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) => const Text(
              'You can always go back and read the guide again 😊',
              style: TextStyle(
                fontFamily: 'RedHatDisplaySemiBold',
                fontSize: 16,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    ];

    final tutorial = TutorialCoachMark(
      targets: targets,
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      tutorial.show(context: context);
    });
  }
}

// CustomTextButton widget for consistent button styling
class CustomTextButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const CustomTextButton({
    super.key,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 68,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [AppPresets().neonShadow],
      ),
      child: Material(
        color: theme.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          onTap: onTap,
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'RedHatDisplayRegular',
                fontSize: 16,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
