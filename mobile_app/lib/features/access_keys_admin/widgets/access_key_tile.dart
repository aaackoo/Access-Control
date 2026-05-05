import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/constants/ac_text_styles.dart';
import 'package:access_control/core/navigation/routes/routes.dart';
import 'package:access_control/core/providers/access_keys_providers.dart';
import 'package:access_control/features/access_keys_admin/widgets/access_key_details_dialog.dart';
import 'package:access_control/features/widgets/modal_actions.dart';
import 'package:access_control/features/widgets/status_badge.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:access_control/models/access_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AccessKeyTile extends ConsumerWidget {
  const AccessKeyTile({super.key, required this.accessKey});

  final AccessKey accessKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => showDialog(
          context: context,
          builder: (context) => AccessKeyDetailsDialog(accessKey: accessKey),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: ACGradients.accentPrimaryGradient,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: ACColors.backgroundAccent,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.credit_card,
                  color: ACColors.text,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      accessKey.name,
                      style: ACTextStyles.bodyText(ACColors.text),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.devices,
                          size: 16,
                          color: ACColors.textDim,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${accessKey.deviceIds.length} zariadení',
                          style: ACTextStyles.smallerBodyText(ACColors.textDim),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    StatusBadge(
                      isActive: !accessKey.isDeleted,
                      activeLabel: context.l10n.active,
                      inactiveLabel: context.l10n.inactive,
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                itemBuilder: (context) => [
                  editMenuItem(
                    onTap: () => context.push(
                      Routes.editAccessKeyPath(accessKey.id),
                      extra: accessKey,
                    ),
                    context: context,
                  ),
                  deleteMenuItem(
                    onTap: () async => ref
                        .read(accessKeysNotifierProvider.notifier)
                        .deleteAccessKey(accessKey.id),
                    context: context,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
