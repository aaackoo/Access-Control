import 'package:access_control/core/constants/ac_extensions.dart';
import 'package:access_control/features/widgets/general_info_row.dart';
import 'package:access_control/features/widgets/info_banner.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:access_control/models/device.dart';
import 'package:flutter/material.dart';

class DeviceInfoBanner extends StatelessWidget {
  const DeviceInfoBanner({super.key, required this.device});

  final Device device;

  @override
  Widget build(BuildContext context) {
    return InfoBanner(
      title: context.l10n.deviceInfo,
      rows: [
        GeneralInfoRow(
          icon: Icons.fingerprint,
          label: context.l10n.id,
          value: '${device.id.substring(0, 8)}...',
        ),
        const SizedBox(height: 4),
        GeneralInfoRow(
          icon: Icons.admin_panel_settings,
          label: context.l10n.type,
          value: device.deviceType.label,
        ),
        const SizedBox(height: 4),
        GeneralInfoRow(
          icon: Icons.calendar_today,
          label: context.l10n.createdAt,
          value: device.createdUtc.formatted,
        ),
      ],
    );
  }
}
