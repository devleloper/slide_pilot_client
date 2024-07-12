import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/theme.dart';

class CustomTextButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final Color textColor;
  final Color buttonColor;
  final BoxShadow buttonShadow;

  const CustomTextButton({
    Key? key,
    required this.title,
    this.onTap,
    required this.textColor,
    required this.buttonColor,
    required this.buttonShadow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 68,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [buttonShadow],
      ),
      child: Material(
        color: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          onTap: onTap,
          child: Center(
            child: Text(
              title,
              style: GoogleFonts.redHatDisplay(
                fontSize: 16,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
