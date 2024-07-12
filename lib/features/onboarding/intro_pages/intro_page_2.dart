import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_pilot_client/theme/theme.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

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
              height: 400,
              width: 400,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  AppPresets().neonShadow,
                ],
              ),
              child: Image.asset(
                'assets/guide/1.jpg',
                fit: BoxFit.contain,
              ),
            ),
            Text(
              'This is small guide how to use this application and effectiverly control your awesome presentations!',
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
