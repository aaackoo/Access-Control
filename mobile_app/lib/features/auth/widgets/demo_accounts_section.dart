import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/constants/ac_text_styles.dart';
import 'package:access_control/features/auth/widgets/demo_accounts_button.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:flutter/material.dart';

class DemoAccountsSection extends StatelessWidget {
  const DemoAccountsSection({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    final demoAccounts = [
      {'email': 'a.supej@icloud.com', 'role': context.l10n.companyOwner},
      {'email': 'TBA', 'role': context.l10n.manager},
      {'email': 'TBA', 'role': context.l10n.user},
    ];

    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: ACColors.text,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                '${context.l10n.demoAccountsTitle}:',
                style: ACTextStyles.bodyText(ACColors.text),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: screenHeight * 0.18,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: demoAccounts.length,
              itemBuilder: (context, index) {
                final account = demoAccounts[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index < demoAccounts.length - 1 ? 8.0 : 0,
                  ),
                  child: DemoAccountButton(
                    email: account['email'] as String,
                    password: 'abcdef',
                    role: account['role'] as String,
                    emailController: emailController,
                    passwordController: passwordController,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
