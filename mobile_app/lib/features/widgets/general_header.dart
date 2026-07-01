import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/constants/ac_text_styles.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum HeaderType {
  account,
  company,
  area,
  building,
  device,
  accessKey,
}

class GeneralHeader extends StatelessWidget {
  const GeneralHeader({
    super.key,
    required this.async,
    required this.icon,
    required this.type,
  });

  final AsyncValue<List<dynamic>> async;
  final IconData icon;
  final HeaderType type;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: ACColors.backgroundDimmed,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: ACColors.accent,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: async.when(
              data: (items) => Text(
                _totalLabel(items.length, context),
                style: ACTextStyles.appBarTitle(
                  ACColors.text,
                ),
              ),
              loading: () => Text(
                context.l10n.loading,
                style: ACTextStyles.appBarTitle(
                  ACColors.text,
                ),
              ),
              error: (_, __) => Text(
                context.l10n.errorLoadingData,
                style: ACTextStyles.appBarTitle(
                  ACColors.error,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _totalLabel(int count, BuildContext context) {
    final l10n = context.l10n;
    switch (type) {
      case HeaderType.account:
        return l10n.totalAccountsCount(count);
      case HeaderType.company:
        return l10n.totalCompaniesCount(count);
      case HeaderType.area:
        return l10n.totalAreasCount(count);
      case HeaderType.building:
        return l10n.totalBuildingsCount(count);
      case HeaderType.device:
        return l10n.totalDevicesCount(count);
      case HeaderType.accessKey:
        return l10n.totalAccessKeysCount(count);
    }
  }
}
