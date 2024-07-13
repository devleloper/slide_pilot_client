import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
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

    FlutterBluetoothSerial.instance.state.then(
      (state) {
        setState(() {
          _bluetoothState = state;
        });
      },
    );

    Future.doWhile(() async {
      final isEnabled = await FlutterBluetoothSerial.instance.isEnabled;
      if (isEnabled == true) {
        return false;
      }
      await Future.delayed(const Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {});

    FlutterBluetoothSerial.instance.name.then((name) {
      setState(() {
        _name = name ?? "...";
      });
    });

    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
      });
    });
  }

  Future<void> _checkAndShowTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    _isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (_isFirstTime) {
      _createTutorial();
      await prefs.setBool('isFirstTime', false);
    }
  }

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
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Version 1.0.0',
              style: GoogleFonts.redHatDisplay(
                color: Colors.black.withOpacity(0.5),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Developed by Devlet Boltaev in Blism Solutions',
              style: GoogleFonts.redHatDisplay(
                color: Colors.black.withOpacity(0.5),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
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
            Text(
              'Slide Pilot',
              style: GoogleFonts.redHatDisplay(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
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
              style: GoogleFonts.redHatDisplay(
                fontSize: 16,
              ),
            )),
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

  void _startRemoteConnection(BuildContext context, BluetoothDevice server) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return RemoteControlPage(server: server);
    }));
  }

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

  void _navigateToOnboarding(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const OnboardingScreen(),
      ),
    );
  }

  Future<void> _createTutorial() async {
    final targets = [
      TargetFocus(
        identify: 'helpButton',
        keyTarget: _helpButtonKey,
        alignSkip: Alignment.bottomCenter,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) => Text(
              'You can always go back and read the guide again 😊',
              style: GoogleFonts.redHatDisplay(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
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

// CustomTextButton

class CustomTextButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const CustomTextButton({
    Key? key,
    required this.title,
    this.onTap,
  }) : super(key: key);

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
              style: GoogleFonts.redHatDisplay(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
