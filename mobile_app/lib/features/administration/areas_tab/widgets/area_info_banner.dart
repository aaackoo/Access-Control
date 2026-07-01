import 'package:access_control/core/constants/ac_extensions.dart';
import 'package:access_control/features/widgets/general_info_row.dart';
import 'package:access_control/features/widgets/info_banner.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:access_control/models/area.dart';
import 'package:flutter/material.dart';

class AreaInfoBanner extends StatelessWidget {
  const AreaInfoBanner({super.key, required this.area});

  final Area area;

  @override
  Widget build(BuildContext context) {
    return InfoBanner(
      title: context.l10n.areaInfo,
      rows: [
        GeneralInfoRow(
          icon: Icons.fingerprint,
          label: context.l10n.id,
          value: '${area.id.substring(0, 8)}...',
        ),
        const SizedBox(height: 4),
        GeneralInfoRow(
          icon: Icons.calendar_today,
          label: context.l10n.createdAt,
          value: area.createdUtc.formatted,
        ),
      ],
    );
  }
}
