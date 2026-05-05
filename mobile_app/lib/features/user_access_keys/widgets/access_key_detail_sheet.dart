import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/constants/ac_extensions.dart';
import 'package:access_control/core/constants/ac_text_styles.dart';
import 'package:access_control/features/user_access_keys/widgets/detail_section.dart';
import 'package:access_control/features/user_access_keys/widgets/device_row.dart';
import 'package:access_control/features/widgets/general_info_row.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:access_control/models/access_key.dart';
import 'package:access_control/models/account_key_assignment.dart';
import 'package:access_control/models/area.dart';
import 'package:access_control/models/building.dart';
import 'package:access_control/models/device.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AccessKeyDetailSheet extends StatelessWidget {
  const AccessKeyDetailSheet({
    super.key,
    required this.keyDetail,
  });

  final Map<String, dynamic> keyDetail;

  @override
  Widget build(BuildContext context) {
    final accessKey = keyDetail['key'] as AccessKey;
    final assignment = keyDetail['assignment'] as AccountKeyAssignment;
    final area = keyDetail['area'] as Area;
    final building = keyDetail['building'] as Building;
    final devices = keyDetail['devices'] as List<Device>;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: ACGradients.accentPrimaryGradient,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.credit_card,
                        color: ACColors.text,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            accessKey.name,
                            style: ACTextStyles.bodyText(
                              ACColors.text,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(
                        Icons.close,
                        color: ACColors.text,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    DetailSection(
                      title: context.l10n.keyInfoTitle,
                      icon: Icons.info_outline,
                      children: [
                        GeneralInfoRow(
                          label: context.l10n.createdAt,
                          value: accessKey.createdUtc.formattedWithTime,
                        ),
                        GeneralInfoRow(
                          label: context.l10n.lastModified,
                          value: accessKey.updatedUtc.formattedWithTime,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    DetailSection(
                      title: context.l10n.accessValidity,
                      icon: Icons.calendar_today,
                      children: [
                        GeneralInfoRow(
                          label: context.l10n.validFrom,
                          value: assignment.validFromUtc?.toLocal().formatted ??
                              '—',
                        ),
                        GeneralInfoRow(
                          label: context.l10n.validTo,
                          value:
                              assignment.validToUtc?.toLocal().formatted ?? '—',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    DetailSection(
                      title: context.l10n.locationInfoTitle,
                      icon: Icons.location_on,
                      children: [
                        GeneralInfoRow(
                          label: context.l10n.area,
                          value: '${area.name} (${area.location})',
                        ),
                        GeneralInfoRow(
                          label: context.l10n.building,
                          value: building.name,
                        ),
                        GeneralInfoRow(
                          label: context.l10n.address,
                          value: building.address,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    DetailSection(
                      title: '${context.l10n.devices} (${devices.length})',
                      icon: Icons.door_front_door,
                      children: devices
                          .map((device) => DeviceRow(device: device))
                          .toList(),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
