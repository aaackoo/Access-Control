import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/constants/ac_text_styles.dart';
import 'package:access_control/models/account.dart';
import 'package:flutter/material.dart';

class AccountProfileCard extends StatelessWidget {
  const AccountProfileCard({super.key, required this.account});

  final Account account;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: ACColors.secondary,
                child: Text(
                  account.email[0].toUpperCase(),
                  style: ACTextStyles.headlineTitle(ACColors.text),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    account.email,
                    style: ACTextStyles.appBarTitle(ACColors.text),
                  ),
                  const SizedBox(height: 8),
                  _AccountRoleBadge(role: account.role),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccountRoleBadge extends StatelessWidget {
  const _AccountRoleBadge({required this.role});

  final AccountRole role;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: role.color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        accountRoleToString(context, role),
        style: ACTextStyles.smallerBodyText(ACColors.text),
      ),
    );
  }
}
