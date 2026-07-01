import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/constants/ac_text_styles.dart';
import 'package:access_control/core/navigation/routes/routes.dart';
import 'package:access_control/models/account.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AccountTile extends StatelessWidget {
  const AccountTile({
    super.key,
    required this.account,
  });

  final Account account;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: () {
          context.push(Routes.accountDetailPath(account.id));
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: ACColors.accent,
                child: Text(
                  account.email[0].toUpperCase(),
                  style: ACTextStyles.appBarTitle(ACColors.text),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.email,
                      style: ACTextStyles.bodyText(ACColors.text),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: account.role.color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        accountRoleToString(context, account.role),
                        style: ACTextStyles.smallerBodyText(ACColors.text),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: ACColors.accent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
