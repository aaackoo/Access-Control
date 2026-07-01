import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/constants/ac_text_styles.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:flutter/material.dart';

class GeneralErrorState extends StatelessWidget {
  const GeneralErrorState({
    super.key,
    required this.error,
    this.onRetry,
    this.customTitle,
  });

  final Object error;
  final VoidCallback? onRetry;
  final String? customTitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            customTitle ?? context.l10n.error,
            style: ACTextStyles.bodyText(
              ACColors.text,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: ACTextStyles.smallerBodyText(
              ACColors.error,
            ),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) const SizedBox(height: 16),
          if (onRetry != null)
            ElevatedButton(
              onPressed: onRetry,
              child: Text(context.l10n.refresh),
            ),
        ],
      ),
    );
  }
}
