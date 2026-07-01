import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/constants/ac_text_styles.dart';
import 'package:flutter/material.dart';

class StatRow extends StatelessWidget {
  const StatRow({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final int value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, size: 20, color: ACColors.accent),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: ACTextStyles.bodyText(
                ACColors.text,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: ACColors.backgroundAccent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value.toString(),
              style: ACTextStyles.bodyText(
                ACColors.accent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
