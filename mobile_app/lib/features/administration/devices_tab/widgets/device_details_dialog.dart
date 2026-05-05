import 'package:access_control/core/constants/ac_extensions.dart';
import 'package:access_control/features/widgets/general_detail_row.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:access_control/models/device.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DeviceDetailsDialog extends StatelessWidget {
  const DeviceDetailsDialog({super.key, required this.device});

  final Device device;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final dialogWidth =
        screenSize.width * 0.9 > 500 ? 500.0 : screenSize.width * 0.9;

    return AlertDialog(
      title: Row(
        children: [
          Icon(device.deviceType.icon),
          const SizedBox(width: 8),
          Text(device.name),
        ],
      ),
      content: SizedBox(
        width: dialogWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GeneralDetailRow(label: context.l10n.id, value: device.id),
            GeneralDetailRow(label: context.l10n.name, value: device.name),
            GeneralDetailRow(
              label: context.l10n.type,
              value: device.deviceType.label,
            ),
            GeneralDetailRow(
              label: context.l10n.state,
              value: context.l10n.online,
            ),
            GeneralDetailRow(
              label: context.l10n.createdAt,
              value: device.createdUtc.formattedWithTime,
            ),
            GeneralDetailRow(
              label: context.l10n.lastModified,
              value: device.updatedUtc.formattedWithTime,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(context.l10n.close),
        ),
      ],
    );
  }
}
