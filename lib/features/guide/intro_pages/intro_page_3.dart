import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
              style: GoogleFonts.redHatDisplay(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Follow these steps to connect your device to the PC for controlling your presentations:',
              style: GoogleFonts.redHatDisplay(
                fontSize: 16,
                color: Colors.white,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 32),
            Column(
              children: [
                // 1
                Text(
                  'Step 1: Press the "Discovery PC" button on your Android device.',
                  style: GoogleFonts.redHatDisplay(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 16),
                Image.asset('assets/guide/client/connect_1.jpg'),
                const SizedBox(height: 16),
                Text(
                  'Then select your PC from the list and wait for the pairing message to appear on both devices. Accept the pairing on both devices. (You can also do this manually in Android Bluetooth settings)',
                  style: GoogleFonts.redHatDisplay(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.start,
                ),

                const SizedBox(height: 16),
                Image.asset('assets/guide/client/connect_2.jpg'),

                // 3
                const SizedBox(height: 32),
                Text(
                  'Step 2: Once paired, press the "Connect to paired PC to control" button on your Android device.',
                  style: GoogleFonts.redHatDisplay(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 16),
                Image.asset('assets/guide/client/connect_3.jpg'),
                const SizedBox(height: 16),
                Text(
                  'Then select your PC from the list to establish the connection.',
                  style: GoogleFonts.redHatDisplay(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 16),
                Image.asset('assets/guide/client/connect_4.jpg'),

                // 3
                const SizedBox(height: 32),
                Text(
                  'Step 3: Once you are connected to the device, you can control it, also make sure that the server is switched to Connected mode',
                  style: GoogleFonts.redHatDisplay(
                    fontSize: 16,
                    color: Colors.white,
                  ),
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
