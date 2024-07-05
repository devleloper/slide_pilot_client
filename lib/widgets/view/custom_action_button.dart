import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class CustomActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const CustomActionButton({
    Key? key,
    required this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [AppPresets().neonShadow],
      ),
      child: Material(
        color: theme.primaryColor,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Center(
            child: Icon(icon, size: 32, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
