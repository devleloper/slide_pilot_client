import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../features.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

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
              'Second: PC setup 🖥',
              style: GoogleFonts.redHatDisplay(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'To ensure the proper functioning of Slide Pilot, please install the following software on your PC:',
              style: GoogleFonts.redHatDisplay(
                fontSize: 16,
                color: Colors.white,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 16),
            CustomTextGuideButton(
              icon: CupertinoIcons.arrow_down_circle_fill,
              title: 'Download All in One Archive',
              onTap: () =>
                  _launchURL('https://example.com/all_in_one_archive.zip'),
            ),
            const SizedBox(height: 32),
            Text(
              'Instructions to launch the server:',
              style: GoogleFonts.redHatDisplay(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                Text(
                  'Step 1: After successful installation of all programs, start the server (slide_pilot_server.jar)',
                  style: GoogleFonts.redHatDisplay(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 16),
                Image.asset('assets/guide/server/start_server_1.jpg'),
                const SizedBox(height: 32),
                Text(
                  'Step 2: Run the server by clicking on the “Start” button. You should see a message indicating that the server is running and waiting for connections.',
                  style: GoogleFonts.redHatDisplay(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 16),
                Image.asset('assets/guide/server/start_server_2.jpg'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
