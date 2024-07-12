import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:slide_pilot_client/theme/theme.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [AppPresets().neonShadow],
              ),
              child: SvgPicture.asset(
                'assets/brand/logo_color.svg',
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Welcome to Slide Pilot!',
              style: GoogleFonts.redHatDisplay(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Discover how to effortlessly navigate through slides, highlight key points with the Spotlight feature, and control the cursor with precision. Whether you’re in a boardroom or a classroom, Slide Pilot puts you in command of your presentation, making it a breeze to impress your audience.',
              style: GoogleFonts.redHatDisplay(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
