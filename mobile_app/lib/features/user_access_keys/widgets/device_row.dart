import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/constants/ac_text_styles.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:access_control/models/device.dart';
import 'package:flutter/material.dart';

class DeviceRow extends StatelessWidget {
  const DeviceRow({super.key, required this.device});

  final Device device;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: ACColors.backgroundAccent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.door_front_door,
              color: ACColors.accent,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              device.name,
              style: ACTextStyles.smallerBodyText(ACColors.text),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              context.l10n.active,
              style: ACTextStyles.smallerBodyText(ACColors.success),
            ),
          ),
        ],
      ),
    );
  }
}
