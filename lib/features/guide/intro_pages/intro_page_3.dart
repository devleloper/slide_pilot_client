import 'package:flutter/material.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      color: theme.primaryColor,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            Text(
              'Third: Establishing a connection 🔗',
              style:
                  theme.textTheme.headlineMedium?.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Follow these steps to connect your device to the PC for controlling your presentations:',
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 32),
            Column(
              children: [
                Text(
                  'Step 1: Press the "Discovery PC" button on your Android device.',
                  style:
                      theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 16),
                Image.asset('assets/guide/client/connect_1.jpg'),
                const SizedBox(height: 16),
                Text(
                  'Then select your PC from the list and wait for the pairing message to appear on both devices. Accept the pairing on both devices. (You can also do this manually in Android Bluetooth settings)',
                  style:
                      theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 16),
                Image.asset('assets/guide/client/connect_2.jpg'),
                const SizedBox(height: 32),
                Text(
                  'Step 2: Once paired, press the "Connect to paired PC to control" button on your Android device.',
                  style:
                      theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 16),
                Image.asset('assets/guide/client/connect_3.jpg'),
                const SizedBox(height: 16),
                Text(
                  'Then select your PC from the list to establish the connection.',
                  style:
                      theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 16),
                Image.asset('assets/guide/client/connect_4.jpg'),
                const SizedBox(height: 32),
                Text(
                  'Step 3: Once you are connected to the device, you can control it, also make sure that the server is switched to Connected mode',
                  style:
                      theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 16),
                Image.asset('assets/guide/server/start_server_3.jpg'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
