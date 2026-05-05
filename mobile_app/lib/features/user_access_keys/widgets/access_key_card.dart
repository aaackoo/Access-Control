import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/constants/ac_text_styles.dart';
import 'package:access_control/features/user_access_keys/widgets/access_key_detail_sheet.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:access_control/models/access_key.dart';
import 'package:access_control/models/account_key_assignment.dart';
import 'package:access_control/models/area.dart';
import 'package:access_control/models/building.dart';
import 'package:access_control/models/device.dart';
import 'package:flutter/material.dart';

class AccessKeyCard extends StatelessWidget {
  const AccessKeyCard({
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
    final deviceCount = keyDetail['deviceCount'] as int;
    final isActive = assignment.isActive;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          _showKeyDetails(context, keyDetail);
        },
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
                      style: ACTextStyles.bodyText(
                        ACColors.text,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: isActive ? ACColors.success : ACColors.error,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isActive
                              ? context.l10n.active
                              : context.l10n.inactive,
                          style: TextStyle(
                            fontSize: 11,
                            color: isActive ? ACColors.success : ACColors.error,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: ACColors.textDim,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${building.name} • ${area.location}',
                            style: ACTextStyles.smallerBodyText(
                              ACColors.textDim,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.nfc,
                          size: 16,
                          color: ACColors.textDim,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            context.l10n.deviceCountLabel(deviceCount),
                            style: ACTextStyles.smallerBodyText(
                              ACColors.textDim,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.door_front_door,
                          size: 16,
                          color: ACColors.success,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            _getUnlocksDescription(context, devices),
                            style: ACTextStyles.smallerBodyText(
                              devices.isEmpty
                                  ? ACColors.textDim
                                  : ACColors.success,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getUnlocksDescription(BuildContext context, List<Device> devices) {
    if (devices.isEmpty) return context.l10n.noDevices;

    if (devices.length == 1) {
      return '${context.l10n.unlocks}: ${devices.first.name}';
    } else if (devices.length <= 3) {
      return '${context.l10n.unlocks}: ${devices.map((d) => d.name).join(', ')}';
    } else {
      return '${context.l10n.unlocks}: ${devices.take(2).map((d) => d.name).join(', ')} ${context.l10n.and} ${devices.length - 2} ${context.l10n.more}';
    }
  }

  void _showKeyDetails(BuildContext context, Map<String, dynamic> keyDetail) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AccessKeyDetailSheet(keyDetail: keyDetail),
    );
  }
}
