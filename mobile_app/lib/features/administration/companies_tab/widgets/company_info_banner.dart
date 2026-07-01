import 'package:access_control/core/constants/ac_extensions.dart';
import 'package:access_control/features/widgets/general_info_row.dart';
import 'package:access_control/features/widgets/info_banner.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:access_control/models/company.dart';
import 'package:flutter/material.dart';

class CompanyInfoBanner extends StatelessWidget {
  const CompanyInfoBanner({super.key, required this.company});

  final Company company;

  @override
  Widget build(BuildContext context) {
    return InfoBanner(
      title: context.l10n.companyInfo,
      rows: [
        GeneralInfoRow(
          icon: Icons.fingerprint,
          label: context.l10n.id,
          value: '${company.id.substring(0, 8)}...',
        ),
        const SizedBox(height: 4),
        GeneralInfoRow(
          icon: Icons.calendar_today,
          label: context.l10n.createdAt,
          value: company.createdUtc.formatted,
        ),
      ],
    );
  }
}
