import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/constants/ac_text_styles.dart';
import 'package:access_control/features/user_profile/widgets/stats_row.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompanyStatsCard extends StatelessWidget {
  const CompanyStatsCard({super.key, required this.statsAsync});

  final AsyncValue<Map<String, int>> statsAsync;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.companyStatisticsTitle,
              style: ACTextStyles.appBarTitle(
                ACColors.text,
              ),
            ),
            const SizedBox(height: 12),
            statsAsync.when(
              data: (stats) {
                return Column(
                  children: [
                    StatRow(
                      label: context.l10n.areas,
                      value: stats['areas_count'] ?? 0,
                      icon: Icons.location_city,
                    ),
                    StatRow(
                      label: context.l10n.buildings,
                      value: stats['buildings_count'] ?? 0,
                      icon: Icons.apartment,
                    ),
                    StatRow(
                      label: context.l10n.devices,
                      value: stats['devices_count'] ?? 0,
                      icon: Icons.devices,
                    ),
                    StatRow(
                      label: context.l10n.accessKeys,
                      value: stats['access_keys_count'] ?? 0,
                      icon: Icons.admin_panel_settings,
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
