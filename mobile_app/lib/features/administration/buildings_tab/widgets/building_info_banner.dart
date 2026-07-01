import 'package:access_control/core/constants/ac_extensions.dart';
import 'package:access_control/features/widgets/general_info_row.dart';
import 'package:access_control/features/widgets/info_banner.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:access_control/models/building.dart';
import 'package:flutter/material.dart';

class BuildingInfoBanner extends StatelessWidget {
  const BuildingInfoBanner({super.key, required this.building});

  final Building building;

  @override
  Widget build(BuildContext context) {
    return InfoBanner(
      title: context.l10n.buildingInfo,
      rows: [
        GeneralInfoRow(
          icon: Icons.fingerprint,
          label: context.l10n.id,
          value: '${building.id.substring(0, 8)}...',
        ),
        const SizedBox(height: 4),
        GeneralInfoRow(
          icon: Icons.vpn_key,
          label: context.l10n.keys,
          value: building.accessKeyIds.length.toString(),
        ),
        const SizedBox(height: 4),
        GeneralInfoRow(
          icon: Icons.calendar_today,
          label: context.l10n.createdAt,
          value: building.createdUtc.formatted,
        ),
      ],
    );
  }
}
