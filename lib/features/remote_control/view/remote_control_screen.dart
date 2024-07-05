import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:control_pad_plus/control_pad_plus.dart';
import '../../../theme/theme.dart';
import '../../../widgets/view/custom_action_button.dart';
import '../../../widgets/widgets.dart';
import 'remote_control_logic.dart';

class RemoteControlPage extends StatelessWidget {
  final BluetoothDevice server;

  const RemoteControlPage({super.key, required this.server});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RemoteControlLogic(server: server),
      child: const RemoteControlScreen(),
    );
  }
}

class RemoteControlScreen extends StatelessWidget {
  const RemoteControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Provider.of<RemoteControlLogic>(context);
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: logic.isConnecting
            ? Text('Connecting to ${logic.server.name}...')
            : logic.isConnected
                ? Text('Connected with ${logic.server.name}')
                : Text('Disconnected with ${logic.server.name}'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => logic.close(),
          ),
          IconButton(
            icon: const Icon(
              CupertinoIcons.refresh,
            ),
            onPressed:
                logic.isConnected ? null : () => logic.connectToBluetooth(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            CustomSwitchListTile(
              logic: logic,
              title: 'Gyroscope',
              value: logic.isGyroOn,
              onChanged: (isOn) => logic.accelerometerControl(isOn),
            ),
            if (logic.isJoystick)
              Container(
                color: Colors.white,
                child: JoystickView(
                  interval: const Duration(milliseconds: 50),
                  onDirectionChanged: (degrees, distance) =>
                      logic.directionChanged(degrees, distance),
                ),
              )
            else
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  width: double.infinity,
                  height: double.infinity,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapUp: logic.handleTapUp,
                    onDoubleTap: logic.handleDoubleTap,
                    onPanUpdate: logic.handlePanUpdate,
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          AppPresets().neonShadow,
                        ],
                      ),
                      color: theme.primaryColor,
                      child: Stack(
                        children: [
                          const Positioned(
                            top: 10,
                            left: 10,
                            child: Opacity(
                              opacity: 0.50,
                              child: Icon(
                                color: Colors.white,
                                Icons.rounded_corner,
                                size: 24,
                              ),
                            ),
                          ),
                          const Positioned(
                            top: 10,
                            right: 10,
                            child: Opacity(
                              opacity: 0.50,
                              child: Icon(
                                color: Colors.white,
                                Icons.rounded_corner,
                                size: 24,
                              ),
                            ),
                          ),
                          const Positioned(
                            bottom: 10,
                            left: 10,
                            child: Opacity(
                              opacity: 0.50,
                              child: Icon(
                                color: Colors.white,
                                Icons.rounded_corner,
                                size: 24,
                              ),
                            ),
                          ),
                          const Positioned(
                            bottom: 10,
                            right: 10,
                            child: Opacity(
                              opacity: 0.50,
                              child: Icon(
                                color: Colors.white,
                                Icons.rounded_corner,
                                size: 24,
                              ),
                            ),
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Opacity(
                                  opacity: 0.50,
                                  child: Icon(
                                    color: Colors.white,
                                    CupertinoIcons.hand_draw,
                                    size: 50,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Opacity(
                                  opacity: 0.50,
                                  child: Text(
                                    'Touchpad',
                                    style: GoogleFonts.redHatDisplay(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            CustomScrollActionsRow(logic: logic),
            const SizedBox(height: 16),
            CustomActionButtonsRow(logic: logic),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class CustomScrollActionsRow extends StatelessWidget {
  final RemoteControlLogic logic;

  const CustomScrollActionsRow({super.key, required this.logic});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          CustomScrollActionButton(
            icon: CupertinoIcons.chevron_up_circle,
            tooltip: 'Scroll up',
            onPressed: logic.isConnected
                ? () => logic.scroll(DragUpdateDetails(
                      delta: const Offset(0.0, -1.0),
                      globalPosition: const Offset(0.0, 0.0),
                    ))
                : null,
          ),
          CustomScrollActionButton(
            icon: CupertinoIcons.chevron_down_circle,
            tooltip: 'Scroll down',
            onPressed: logic.isConnected
                ? () => logic.scroll(DragUpdateDetails(
                      delta: const Offset(0.0, 1.0),
                      globalPosition: const Offset(0.0, 0.0),
                    ))
                : null,
          ),
          CustomScrollActionButton(
            icon: CupertinoIcons.zoom_in,
            tooltip: 'Zoom in',
            onPressed: logic.isConnected
                ? () => logic.zoom(DragUpdateDetails(
                      delta: const Offset(0.0, -1.0),
                      globalPosition: const Offset(0.0, 0.0),
                    ))
                : null,
          ),
          CustomScrollActionButton(
            icon: CupertinoIcons.zoom_out,
            tooltip: 'Zoom out',
            onPressed: logic.isConnected
                ? () => logic.zoom(DragUpdateDetails(
                      delta: const Offset(0.0, 1.0),
                      globalPosition: const Offset(0.0, 0.0),
                    ))
                : null,
          ),
          CustomScrollActionButton(
            icon: CupertinoIcons.flag_fill,
            tooltip: 'Present from beginning',
            onPressed: logic.isConnected ? () => logic.present() : null,
          ),
          CustomScrollActionButton(
            icon: CupertinoIcons.forward_fill,
            tooltip: 'Present from current slide',
            onPressed: logic.isConnected ? () => logic.presentCurrent() : null,
          ),
          CustomScrollActionButton(
            icon: CupertinoIcons.fullscreen_exit,
            tooltip: 'Close presentation',
            onPressed: logic.isConnected ? () => logic.exit() : null,
          ),
        ],
      ),
    );
  }
}

class CustomScrollActionButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  const CustomScrollActionButton({
    super.key,
    required this.icon,
    required this.tooltip,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      iconSize: (MediaQuery.of(context).size.width / 8) - 16,
      onPressed: onPressed,
      tooltip: tooltip,
    );
  }
}

class CustomActionButtonsRow extends StatelessWidget {
  final RemoteControlLogic logic;

  const CustomActionButtonsRow({super.key, required this.logic});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        CustomActionButton(
          icon: CupertinoIcons.chevron_back,
          onTap: logic.isConnected ? () => logic.goLeft() : null,
        ),
        CustomActionButton(
          icon: CupertinoIcons.search,
          onTap: logic.isConnected
              ? () => showFeatureUnavailableDialog(context)
              : null,
        ),
        CustomActionButton(
          icon: CupertinoIcons.chevron_forward,
          onTap: logic.isConnected ? () => logic.goRight() : null,
        ),
      ],
    );
  }

  void showFeatureUnavailableDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("SOON..."),
        content: const Text("This feature will be available soon."),
        actions: [
          CupertinoDialogAction(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

class MessageInputField extends StatelessWidget {
  final RemoteControlLogic logic;

  const MessageInputField({super.key, required this.logic});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Flexible(
          child: Container(
            margin: const EdgeInsets.only(left: 16.0),
            child: TextField(
              style: const TextStyle(fontSize: 15.0),
              controller: logic.textEditingController,
              decoration: InputDecoration.collapsed(
                hintText: (logic.isConnecting
                    ? 'Wait until connected...'
                    : logic.isConnected
                        ? 'Type on PC...'
                        : 'BT got disconnected'),
                hintStyle: const TextStyle(color: Colors.grey),
              ),
              enabled: logic.isConnected,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8.0),
          child: IconButton(
            icon: const Icon(Icons.send),
            onPressed: logic.isConnected
                ? () => logic.sendStringToType(logic.textEditingController.text)
                : null,
          ),
        ),
      ],
    );
  }
}

class TouchArea extends StatelessWidget {
  const TouchArea({super.key, required this.dx, required this.dy});
  final double dx, dy;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      width: MediaQuery.of(context).size.width * (4 / 6) - 16,
      height: MediaQuery.of(context).size.height - 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        gradient: SweepGradient(
          center: Alignment(dx, dy),
          tileMode: TileMode.repeated,
          colors: [
            theme.primaryColor,
            theme.primaryColor.withOpacity(0.9),
            theme.primaryColor.withOpacity(0.8),
            theme.primaryColor.withOpacity(0.7),
          ],
        ),
      ),
    );
  }
}
