import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroPage5 extends StatelessWidget {
  const IntroPage5({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      color: theme.primaryColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Get Started! 🎉',
              style: GoogleFonts.redHatDisplay(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'You are now ready to start using Slide Pilot and take control of your presentations. Enjoy! 😃',
              style: GoogleFonts.redHatDisplay(
                fontSize: 16,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
