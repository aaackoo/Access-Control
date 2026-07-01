import 'package:access_control/core/constants/ac_colors.dart';
import 'package:flutter/material.dart';

class AccessKeyItemsSection extends StatelessWidget {
  const AccessKeyItemsSection({
    super.key,
    required this.ids,
    required this.icon,
    required this.label,
    required this.emptyLabel,
    required this.chipColor,
  });

  final List<String> ids;
  final IconData icon;
  final String label;
  final String emptyLabel;
  final Color chipColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 8),
            Text(
              '$label (${ids.length})',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (ids.isEmpty)
          Text(emptyLabel, style: const TextStyle(color: ACColors.textDim))
        else
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: ids
                .map(
                  (id) => Chip(
                    label: Text(
                      '${id.substring(0, 8)}...',
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: chipColor,
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}
