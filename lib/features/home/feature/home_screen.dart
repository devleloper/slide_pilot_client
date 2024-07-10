import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../../../widgets/components/custom_text_button.dart';
import '../../../widgets/widgets.dart';
import '../../features.dart';
import 'package:url_launcher/url_launcher.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPage createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  final GlobalKey _helpButtonKey = GlobalKey();
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  String _name = "...";
  bool _isFirstTime = true;

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

  @override
  void dispose() {
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: BottomAppBar(
      //   child: Column(
      //     children: [
      //       Text(
      //         'Developed by Devlet Boltaev in Blism Solutions',
      //         style: GoogleFonts.redHatDisplay(
      //           color: Colors.black.withOpacity(0.5),
      //           fontSize: 12,
      //           fontWeight: FontWeight.w600,
      //         ),
      //       ),
      //       const SizedBox(
      //         height: 16,
      //       ),
      //       Text(
      //         'Version 1.0.0',
      //         style: GoogleFonts.redHatDisplay(
      //           color: Colors.black.withOpacity(0.5),
      //           fontSize: 12,
      //           fontWeight: FontWeight.w600,
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      appBar: AppBar(
        title: Row(
          children: [
            SvgPicture.asset(
              'assets/logo.svg',
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
            onPressed: () => _showDocumentationDialog(context),
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
          // Visibility(
          //   visible: _bluetoothState.isEnabled,
          //   child: ListTile(
          //     title: Text(
          //       'Devices discovery and connection',
          //       style: GoogleFonts.redHatDisplay(
          //         fontSize: 16,
          //       ),
          //     ),
          //   ),
          // ),
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
        title: const Text("Documentation"),
        content: const Text("Do you want to open the documentation?"),
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
              _launchURL();
            },
          ),
        ],
      ),
    );
  }

  void _launchURL() async {
    const url = 'https://devleloper.medium.com/slide-pilot-guide-3853df2f19f9';
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
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
              'Read the application documentation for better understanding and experience',
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
