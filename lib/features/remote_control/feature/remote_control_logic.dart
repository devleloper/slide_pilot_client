import 'dart:async';
import 'dart:typed_data';
import 'dart:convert';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:sensors_plus/sensors_plus.dart';

class RemoteControlLogic extends ChangeNotifier {
  FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  final BluetoothDevice server;
  static final int clientID = 0;

  StreamSubscription<Uint8List>? _streamSubscription;
  BluetoothConnection? _bluetoothConnection;

  List<Message> messages = [];
  String _messageBuffer = '';

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();

  bool isConnecting = true;
  bool doubleTapped = false;
  bool condition = true;
  bool isJoystick = false;
  double dx = 0.0;
  double dy = 0.0;

  bool isGyroOn = false;
  bool onHold = false;
  bool leftClick = false;
  bool dragEnabled = false;

  Offset? prevFocalPoint;
  double prevScale = 0;

  RemoteControlLogic({required this.server}) {
    _initialize();
  }

  // Initialize logic for gyroscope and connect to Bluetooth
  void _initialize() {
    // Listen to accelerometer events for gyroscope control
    accelerometerEvents.listen((event) {
      if (isGyroOn) {
        _sendMessage('*#*Offset(${event.x * -1}, ${event.y * -1})*@*');
      }
    });

    // Connect to Bluetooth
    connectToBluetooth();
  }

  // Connect to the Bluetooth device
  Future<void> connectToBluetooth() async {
    _bluetoothConnection = await BluetoothConnection.toAddress(server.address);

    isConnecting = false;
    notifyListeners();

    // Listen to data received via Bluetooth
    _streamSubscription = _bluetoothConnection!.input?.listen(_onDataReceived);

    _streamSubscription!.onDone(() {
      print('Disconnected by remote!');
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    _bluetoothConnection?.finish();
    super.dispose();
  }

  // Close the Bluetooth connection
  void close() {
    _streamSubscription = null;
    _bluetoothConnection?.finish();
    notifyListeners();
    print('We are disconnecting locally!');
  }

  // Presentation control commands
  void present() => _sendMessage("*#*F5*@*");

  void exit() => _sendMessage("*#*esc*@*");

  void presentCurrent() => _sendMessage("*#*SHIFT+F5*@*");

  void goRight() => _sendMessage("*#*RIGHT*@*");

  void goLeft() => _sendMessage("*#*LEFT*@*");

  // Send spotlight command with analytics logging
  void sendSpotlightCommand() {
    _logSpotlightButtonClick();
    _sendMessage("*#*SPOTLIGHT*@*");
  }

  // Log spotlight button click event to Firebase Analytics
  void _logSpotlightButtonClick() {
    _analytics.logEvent(
      name: 'spotlight_button_click',
      parameters: <String, Object>{
        'button': 'spotlight',
        'screen': 'remote_control',
      },
    );
  }

  // Handle data received from Bluetooth
  void _onDataReceived(Uint8List data) {
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });

    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    if (~index != 0) {
      messages.add(Message(
        1,
        backspacesCounter > 0
            ? _messageBuffer.substring(
                0, _messageBuffer.length - backspacesCounter)
            : _messageBuffer + dataString.substring(0, index),
      ));
      _messageBuffer = dataString.substring(index);
      notifyListeners();
    } else {
      _messageBuffer = backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString;
    }
  }

  // Send a message to the Bluetooth device
  void _sendMessage(String text) {
    if (text.isNotEmpty) {
      text = text.trim();
      if (text.isNotEmpty) {
        textEditingController.clear();
        _bluetoothConnection!.output.add(ascii.encode("$text\r\n"));
      }
    }
  }

  // Handle joystick direction changes
  void directionChanged(double degrees, double distance) {
    _sendMessage("*#*JOYSTICK${degrees.toString()} ${distance.toString()}*@*");
  }

  // Send left click mouse command
  void leftClickMouse() {
    _sendMessage("*#*LC*@*");
  }

  // Handle scroll events
  void scroll(DragUpdateDetails dragUpdate) {
    _sendMessage("*#*SCROLL${dragUpdate.delta.dy.toString()}*@*");
  }

  // Handle zoom events
  void zoom(DragUpdateDetails dragUpdate) {
    _sendMessage("*#*ZOOM${dragUpdate.delta.dy.toString()}*@*");
  }

  // Handle scaling and panning events
  void onScale(ScaleUpdateDetails dragUpdate, BuildContext context) {
    condition = false;
    notifyListeners();
    if (dragUpdate.scale != 1) {
      if (prevScale == 0) {
        prevScale = dragUpdate.scale;
        condition = true;
        notifyListeners();
        return;
      }
      _sendMessage("*#*ZOOM${dragUpdate.scale - prevScale}*@*");
      prevScale = dragUpdate.scale;
      condition = true;
      notifyListeners();
      return;
    }
    if (prevFocalPoint == null) {
      prevFocalPoint = dragUpdate.focalPoint;
      condition = true;
      notifyListeners();
      return;
    }
    double halfWidth = MediaQuery.of(context).size.width / 2;
    double halfHeight = MediaQuery.of(context).size.height / 2;
    dx = (dragUpdate.focalPoint.dx - halfWidth) / halfWidth;
    dy = (dragUpdate.focalPoint.dy - halfHeight) / halfHeight;
    dragEnabled = leftClick;
    // Convert Offset to string properly
    String offsetString =
        '(${dragUpdate.focalPoint.dx - prevFocalPoint!.dx}, ${dragUpdate.focalPoint.dy - prevFocalPoint!.dy})';
    _sendMessage("*#*${(leftClick ? 'DRAG' : 'Offset')}$offsetString*@*");
    prevFocalPoint = dragUpdate.focalPoint;
    condition = true;
    notifyListeners();
  }

  // Handle end of scaling and panning
  void onScaleEnd() {
    _sendMessage(dragEnabled ? "*#*DRAGENDED*@*" : "");
    dragEnabled = false;
    leftClick = false;
    prevFocalPoint = null;
    doubleTapped = false;
    prevScale = 0;
    dx = 0;
    dy = 0;
    notifyListeners();
  }

  // Send typed string to Bluetooth device
  void sendStringToType(String text) {
    _sendMessage("*#*TYPE$text*@*");
  }

  // Control accelerometer state
  void accelerometerControl(bool isOn) {
    isGyroOn = isOn;
    notifyListeners();
  }

  // Handle touchpad tap up event
  void handleTapUp(TapUpDetails details) {
    _sendMessage("*#*LC*@*");
  }

  // Handle touchpad double tap event
  void handleDoubleTap() {
    _sendMessage("*#*RC*@*");
  }

  // Handle touchpad pan update event
  void handlePanUpdate(DragUpdateDetails details) {
    int dx = details.delta.dx.round();
    int dy = details.delta.dy.round();
    _sendMessage("*#*Offset(${dx.toString()}, ${dy.toString()})*@*");
  }
}

// Message class to represent messages sent and received
class Message {
  final int whom;
  final String text;

  Message(this.whom, this.text);
}
