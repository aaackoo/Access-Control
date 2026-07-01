import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/constants/ac_text_styles.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:flutter/material.dart';

class NfcScanningSheet extends StatelessWidget {
  const NfcScanningSheet({super.key, required this.onCancel});

  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: ACColors.backgroundDimmed,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: ACColors.primaryShade.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 32),
          const Icon(Icons.nfc, size: 64, color: ACColors.primary),
          const SizedBox(height: 20),
          Text(
            context.l10n.nfcScanPrompt,
            style: ACTextStyles.heading(ACColors.text),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.nfcScanPrompt,
            style: ACTextStyles.smallerBodyText(ACColors.primaryShade),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          TextButton(
            onPressed: onCancel,
            child: Text(
              context.l10n.cancel,
              style: ACTextStyles.buttonText(ACColors.accent),
            ),
          ),
        ],
      ),
    );
  }
}
