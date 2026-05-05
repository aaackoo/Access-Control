import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/constants/ac_text_styles.dart';
import 'package:flutter/material.dart';

class GeneralInfoRow extends StatelessWidget {
  const GeneralInfoRow({
    super.key,
    this.icon,
    required this.label,
    required this.value,
  });

  final IconData? icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null)
            Icon(
              icon,
              size: 20,
              color: ACColors.accent,
            ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$label:',
              style: ACTextStyles.bodyText(ACColors.text),
              softWrap: true,
            ),
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              value,
              style: ACTextStyles.bodyText(ACColors.textDim),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
