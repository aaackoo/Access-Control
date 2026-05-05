import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/constants/ac_text_styles.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:flutter/material.dart';

class DemoAccountButton extends StatelessWidget {
  const DemoAccountButton({
    super.key,
    required this.email,
    required this.password,
    required this.role,
    required this.emailController,
    required this.passwordController,
  });

  final String email;
  final String password;
  final String role;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        emailController.text = email;
        passwordController.text = password;
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: ACColors.accent),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    email,
                    style: ACTextStyles.smallerBodyText(ACColors.text),
                  ),
                  Text(
                    '${context.l10n.passwordLabel}: $password',
                    style: ACTextStyles.inputFormBody(ACColors.text),
                  ),
                ],
              ),
            ),
            Text(
              role,
              style: ACTextStyles.inputFormBody(ACColors.text),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.touch_app,
              color: ACColors.text.withAlpha(153),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
