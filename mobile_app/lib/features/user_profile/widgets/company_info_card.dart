import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/constants/ac_extensions.dart';
import 'package:access_control/core/constants/ac_text_styles.dart';
import 'package:access_control/features/widgets/general_info_row.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:access_control/models/company.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompanyInfoCard extends StatelessWidget {
  const CompanyInfoCard({super.key, required this.companyAsync});

  final AsyncValue<Company?> companyAsync;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.companyInfoTitle,
              style: ACTextStyles.appBarTitle(
                ACColors.text,
              ),
            ),
            const SizedBox(height: 12),
            companyAsync.when(
              data: (company) {
                if (company == null) {
                  return Text(context.l10n.noCompanyFound);
                }
                return Column(
                  children: [
                    GeneralInfoRow(
                      label: context.l10n.companyName,
                      value: company.name,
                    ),
                    GeneralInfoRow(
                      label: context.l10n.companyCreatedDate,
                      value: company.createdUtc.formattedWithTime,
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Text(
                '${context.l10n.unknownError}: $error',
                style: ACTextStyles.bodyText(ACColors.error),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
