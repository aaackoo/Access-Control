import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/constants/ac_extensions.dart';
import 'package:access_control/core/constants/ac_text_styles.dart';
import 'package:access_control/features/widgets/general_info_row.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:access_control/models/account.dart';
import 'package:flutter/material.dart';

class AccountInfoCard extends StatelessWidget {
  const AccountInfoCard({super.key, required this.account});

  final Account account;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.accountInfo,
              style: ACTextStyles.appBarTitle(ACColors.text),
            ),
            const SizedBox(height: 16),
            GeneralInfoRow(
              icon: Icons.fingerprint,
              label: context.l10n.accountId,
              value: account.id,
            ),
            const SizedBox(height: 16),
            GeneralInfoRow(
              icon: Icons.email,
              label: context.l10n.email,
              value: account.email,
            ),
            const Divider(),
            GeneralInfoRow(
              icon: Icons.business,
              label: context.l10n.companyId,
              value: account.companyId,
            ),
            const Divider(),
            GeneralInfoRow(
              icon: Icons.update,
              label: context.l10n.lastModified,
              value: account.updatedUtc.formattedWithTime,
            ),
            const Divider(),
            GeneralInfoRow(
              icon: Icons.calendar_today,
              label: context.l10n.createdAt,
              value: account.createdUtc.formattedWithTime,
            ),
          ],
        ),
      ),
    );
  }
}
