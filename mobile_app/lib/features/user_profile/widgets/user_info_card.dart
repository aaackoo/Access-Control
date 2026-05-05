import 'package:access_control/core/constants/ac_extensions.dart';
import 'package:access_control/features/user_profile/widgets/user_profile_header.dart';
import 'package:access_control/features/widgets/general_info_row.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:access_control/models/account.dart';
import 'package:flutter/material.dart';

class UserInfoCard extends StatelessWidget {
  const UserInfoCard({super.key, required this.user});

  final Account user;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserProfileHeader(user: user),
            const SizedBox(height: 16),
            GeneralInfoRow(
              label: context.l10n.createdAt,
              value: user.createdUtc.formattedWithTime,
            ),
            GeneralInfoRow(
              label: context.l10n.lastModified,
              value: user.updatedUtc.formattedWithTime,
            ),
          ],
        ),
      ),
    );
  }
}
