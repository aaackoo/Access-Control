import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/constants/ac_text_styles.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.lock_outline,
          size: 64,
          color: ACColors.accent,
        ),
        const SizedBox(height: 16),
        Text(
          context.l10n.loginTitle,
          style: ACTextStyles.headlineTitle(ACColors.text),
        ),
        const SizedBox(height: 8),
        Text(
          context.l10n.loginSubtitle,
          style: ACTextStyles.bodyText(ACColors.textDim),
        ),
      ],
    );
  }
}
