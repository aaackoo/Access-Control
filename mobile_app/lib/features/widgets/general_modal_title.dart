import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/constants/ac_text_styles.dart';
import 'package:flutter/material.dart';

class GeneralModalTitle extends StatelessWidget {
  const GeneralModalTitle({
    super.key,
    required this.text,
    this.icon = Icons.edit_outlined,
  });

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: ACColors.primary),
        const SizedBox(width: 8),
        Text(
          text,
          style: ACTextStyles.bodyText(
            ACColors.text,
          ),
        ),
      ],
    );
  }
}
