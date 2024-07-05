import 'dart:async';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:sensors_plus/sensors_plus.dart';

class RemoteControlLogic extends ChangeNotifier {
  final BluetoothDevice server;
  static final int clientID = 0;

  StreamSubscription<Uint8List>? _streamSubscription;
  BluetoothConnection? _bluetoothConnection;

  List<Message> messages = [];
  String _messageBuffer = '';

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();

  bool isConnecting = true;
  bool isConnected = false;
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

  void _initialize() {
    accelerometerEvents.listen((event) {
      if (isGyroOn) {
        _sendMessage('*#*Offset(${event.x * -1}, ${event.y * -1})*@*');
      }
    });

    if (server.isConnected) {
      isConnected = true;
      isConnecting = false;
    }

    connectToBluetooth();
  }

  Future<void> connectToBluetooth() async {
    if (!isConnected) {
      _bluetoothConnection =
          await BluetoothConnection.toAddress(server.address);

      isConnecting = false;
      isConnected = true;
      notifyListeners();

      _streamSubscription =
          _bluetoothConnection!.input?.listen(_onDataReceived);

      _streamSubscription!.onDone(() {
        print('Disconnected by remote!');
        isConnected = false;
        notifyListeners();
      });
    }
  }

  @override
  void dispose() {
    if (isConnected) {
      _streamSubscription?.cancel();
      _bluetoothConnection!.finish();
    }
    super.dispose();
  }

  void close() {
    if (isConnected) {
      _streamSubscription = null;
      _bluetoothConnection!.finish();
      isConnected = false;
      notifyListeners();
      print('We are disconnecting locally!');
    }
  }

  void present() => _sendMessage("*#*F5*@*");

  void exit() => _sendMessage("*#*esc*@*");

  void presentCurrent() => _sendMessage("*#*SHIFT+F5*@*");

  void goRight() => _sendMessage("*#*RIGHT*@*");

  void goLeft() => _sendMessage("*#*LEFT*@*");

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

  void _sendMessage(String text) {
    if (text.isNotEmpty) {
      text = text.trim();
      if (text.isNotEmpty) {
        textEditingController.clear();
        _bluetoothConnection!.output.add(ascii.encode("$text\r\n"));
      }
    }
  }

  void directionChanged(double degrees, double distance) {
    _sendMessage("*#*JOYSTICK${degrees.toString()} ${distance.toString()}*@*");
  }

  void leftClickMouse() {
    _sendMessage("*#*LC*@*");
  }

  void scroll(DragUpdateDetails dragUpdate) {
    _sendMessage("*#*SCROLL${dragUpdate.delta.dy.toString()}*@*");
  }

  void zoom(DragUpdateDetails dragUpdate) {
    _sendMessage("*#*ZOOM${dragUpdate.delta.dy.toString()}*@*");
  }

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
    // Here we convert Offset to string properly
    String offsetString =
        '(${dragUpdate.focalPoint.dx - prevFocalPoint!.dx}, ${dragUpdate.focalPoint.dy - prevFocalPoint!.dy})';
    _sendMessage("*#*${(leftClick ? 'DRAG' : 'Offset')}$offsetString*@*");
    prevFocalPoint = dragUpdate.focalPoint;
    condition = true;
    notifyListeners();
  }

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

  void sendStringToType(String text) {
    _sendMessage("*#*TYPE$text*@*");
  }

  void accelerometerControl(bool isOn) {
    isGyroOn = isOn;
    notifyListeners();
  }

  // Methods for touchpad functionality
  void handleTapUp(TapUpDetails details) {
    _sendMessage("*#*LC*@*");
  }

  void handleDoubleTap() {
    _sendMessage("*#*RC*@*");
  }

  void handlePanUpdate(DragUpdateDetails details) {
    int dx = details.delta.dx.round();
    int dy = details.delta.dy.round();
    _sendMessage("*#*Offset(${dx.toString()}, ${dy.toString()})*@*");
  }

  void sendPointerCommand() {
    _sendMessage("*#*POINTER*@*");
  }
}

class Message {
  final int whom;
  final String text;

  Message(this.whom, this.text);
}
