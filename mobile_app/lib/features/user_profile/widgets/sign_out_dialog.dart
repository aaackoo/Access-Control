import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/constants/ac_text_styles.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignOutDialog extends StatelessWidget {
  const SignOutDialog({super.key, required this.onConfirm});

  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final dialogWidth =
        screenSize.width * 0.9 > 500 ? 500.0 : screenSize.width * 0.9;

    return AlertDialog(
      title: Text(
        context.l10n.signOut,
        style: ACTextStyles.bodyText(
          ACColors.text,
        ),
      ),
      content: SizedBox(
        width: dialogWidth,
        child: Text(
          context.l10n.signOutContent,
          style: ACTextStyles.bodyText(
            ACColors.textDim,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(
            context.l10n.cancel,
            style: ACTextStyles.bodyText(
              ACColors.text,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: ACColors.backgroundAccent,
          ),
          child: Text(
            context.l10n.signOut,
            style: ACTextStyles.bodyText(
              ACColors.text,
            ),
          ),
        ),
      ],
    );
  }
}
