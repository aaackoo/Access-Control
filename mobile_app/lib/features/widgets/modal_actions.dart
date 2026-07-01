import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:flutter/material.dart';

PopupMenuItem<void> editMenuItem({
  required VoidCallback onTap,
  required BuildContext context,
}) {
  return PopupMenuItem(
    onTap: onTap,
    child: Row(
      children: [
        const Icon(Icons.edit_outlined, size: 18),
        const SizedBox(width: 8),
        Text(context.l10n.edit),
      ],
    ),
  );
}

PopupMenuItem<void> deleteMenuItem({
  required VoidCallback onTap,
  required BuildContext context,
}) {
  return PopupMenuItem(
    onTap: onTap,
    child: Row(
      children: [
        const Icon(Icons.delete, size: 18, color: ACColors.error),
        const SizedBox(width: 8),
        Text(
          context.l10n.delete,
          style: const TextStyle(color: ACColors.error),
        ),
      ],
    ),
  );
}

class ModalActions extends StatelessWidget {
  const ModalActions({
    super.key,
    required this.isLoading,
    required this.onCancel,
    required this.onSubmit,
  });

  final bool isLoading;
  final VoidCallback onCancel;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: isLoading ? null : onCancel,
          child: Text(context.l10n.cancel),
        ),
        ElevatedButton(
          onPressed: isLoading ? null : onSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: ACColors.primary,
            foregroundColor: Colors.white,
          ),
          child: Text(context.l10n.save),
        ),
      ],
    );
  }
}
