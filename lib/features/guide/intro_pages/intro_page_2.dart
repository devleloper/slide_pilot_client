import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../feature/onboarding_screen.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

  // Function to launch URLs
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
              style:
                  theme.textTheme.headlineMedium?.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'To ensure the proper functioning of Slide Pilot, please install the following software on your PC:',
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 16),
            CustomTextGuideButton(
              icon: CupertinoIcons.arrow_down_circle_fill,
              title: 'Download All in One Archive',
              onTap: () =>
                  _launchURL('https://blism.uz/slidepilot/home#downloads'),
            ),
            const SizedBox(height: 16),
            Text(
              'blism.uz/slidepilot/home',
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 32),
            Text(
              'Instructions to launch the server:',
              style:
                  theme.textTheme.headlineMedium?.copyWith(color: Colors.white),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                Text(
                  'Step 1: After successful installation of all programs, start the server (slide_pilot_server.jar)',
                  style:
                      theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 16),
                Image.asset('assets/guide/server/start_server_1.jpg'),
                const SizedBox(height: 32),
                Text(
                  'Step 2: Run the server by clicking on the “Start” button. You should see a message indicating that the server is running and waiting for connections.',
                  style:
                      theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
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
