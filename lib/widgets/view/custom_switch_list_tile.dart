import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../features/features.dart';

class CustomSwitchListTile extends StatelessWidget {
  const CustomSwitchListTile({
    super.key,
    this.logic,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final RemoteControlLogic? logic;
  final String title;
  final bool value;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.redHatDisplay(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          CupertinoSwitch(
            activeColor: theme.primaryColor,
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
