import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/constants/ac_text_styles.dart';
import 'package:access_control/core/providers/devices_providers.dart';
import 'package:access_control/features/administration/devices_tab/edit_device_modal.dart';
import 'package:access_control/features/administration/devices_tab/widgets/device_details_dialog.dart';
import 'package:access_control/features/widgets/modal_actions.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:access_control/models/device.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeviceListTile extends ConsumerWidget {
  const DeviceListTile({super.key, required this.device});

  final Device device;

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
          builder: (context) => DeviceDetailsDialog(device: device),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: device.deviceType.color,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: device.deviceType.color.withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child:
                    Icon(device.deviceType.icon, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      device.name,
                      style: ACTextStyles.bodyText(ACColors.text),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.category,
                          size: 16,
                          color: ACColors.textDim,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          device.deviceType.label,
                          style: ACTextStyles.smallerBodyText(ACColors.textDim),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: ACColors.success,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          context.l10n.online,
                          style: ACTextStyles.smallerBodyText(ACColors.success),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                itemBuilder: (context) => [
                  editMenuItem(
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => EditDeviceModal(device: device),
                    ),
                    context: context,
                  ),
                  deleteMenuItem(
                    onTap: () async {
                      await ref
                          .read(devicesNotifierProvider.notifier)
                          .deleteDevice(device.id);
                      ref.invalidate(
                        devicesForBuildingProvider(device.buildingId),
                      );
                    },
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
