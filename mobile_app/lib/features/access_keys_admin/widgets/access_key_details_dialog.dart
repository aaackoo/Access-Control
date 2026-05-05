import 'package:access_control/core/constants/ac_extensions.dart';
import 'package:access_control/features/access_keys_admin/widgets/access_key_items_section.dart';
import 'package:access_control/features/widgets/general_detail_row.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:access_control/models/access_key.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AccessKeyDetailsDialog extends StatelessWidget {
  const AccessKeyDetailsDialog({super.key, required this.accessKey});

  final AccessKey accessKey;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final dialogWidth =
        screenSize.width * 0.9 > 500 ? 500.0 : screenSize.width * 0.9;

    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.admin_panel_settings),
          const SizedBox(width: 8),
          Expanded(child: Text(accessKey.name)),
        ],
      ),
      content: SizedBox(
        width: dialogWidth,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GeneralDetailRow(label: context.l10n.id, value: accessKey.id),
              GeneralDetailRow(label: context.l10n.name, value: accessKey.name),
              GeneralDetailRow(
                label: context.l10n.state,
                value: accessKey.isDeleted
                    ? context.l10n.inactive
                    : context.l10n.active,
              ),
              GeneralDetailRow(
                label: context.l10n.createdAt,
                value: accessKey.createdUtc.formattedWithTime,
              ),
              GeneralDetailRow(
                label: context.l10n.lastModified,
                value: accessKey.updatedUtc.formattedWithTime,
              ),
              const SizedBox(height: 16),
              AccessKeyItemsSection(
                ids: accessKey.deviceIds,
                icon: Icons.devices,
                label: context.l10n.devices,
                emptyLabel: context.l10n.noDevices,
                chipColor: Colors.blue.shade100,
              ),
            ],
          ),
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
