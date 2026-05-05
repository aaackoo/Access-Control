import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/constants/ac_text_styles.dart';
import 'package:access_control/models/account.dart';
import 'package:flutter/material.dart';

class UserProfileHeader extends StatelessWidget {
  const UserProfileHeader({super.key, required this.user});

  final Account user;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: ACColors.backgroundAccent,
          child: Text(
            user.email[0].toUpperCase(),
            style: ACTextStyles.headlineTitle(
              ACColors.text,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.email,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Chip(
                label: Text(
                  accountRoleToString(context, user.role),
                  style: ACTextStyles.bodyText(
                    ACColors.textDim,
                  ),
                ),
                backgroundColor: ACColors.backgroundAccent,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
