import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'RedHatDisplaySemiBold',
              fontSize: 16,
              letterSpacing: 1,
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
