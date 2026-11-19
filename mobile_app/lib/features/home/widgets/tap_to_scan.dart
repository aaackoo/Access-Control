import 'dart:async';
import 'dart:io';

import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/constants/ac_text_styles.dart';
import 'package:access_control/core/nfc_device_manager.dart';
import 'package:access_control/core/providers/supabase_database_provider.dart';
import 'package:access_control/features/home/widgets/nfc_scanning_sheet.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:access_control/models/unlock_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TapToScan extends ConsumerWidget {
  const TapToScan({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    final dialogWidth =
        screenSize.width * 0.9 > 500 ? 500.0 : screenSize.width * 0.9;

    return GestureDetector(
      onTap: () async {
        final NfcReadResult result;

        if (Platform.isAndroid) {
          final nfcFuture = NfcDeviceManager.readDeviceId(
            alertMessage: context.l10n.nfcScanPrompt,
            scanningCompletedMessage: context.l10n.scanningCompleted,
          );
          var sheetDismissed = false;

          if (context.mounted) {
            unawaited(
              showModalBottomSheet(
                context: context,
                isDismissible: false,
                enableDrag: false,
                backgroundColor: Colors.transparent,
                builder: (_) => NfcScanningSheet(
                  onCancel: () async {
                    sheetDismissed = true;
                    await NfcDeviceManager.cancelRead();
                    if (context.mounted) context.pop();
                  },
                ),
              ),
            );
          }

          result = await nfcFuture;

          if (!sheetDismissed && context.mounted) {
            context.pop();
          }
        } else {
          result = await NfcDeviceManager.readDeviceId(
            alertMessage: context.l10n.nfcScanPrompt,
            scanningCompletedMessage: context.l10n.scanningCompleted,
          );
        }

        if (!result.success) return;

        final db = ref.read(supabaseDatabaseProvider);
        final unlockResult = await db.unlockDevice(result.deviceId ?? '');

        if (context.mounted) {
          String title;
          String? body;
          switch (unlockResult) {
            case UnlockResult.success:
              title = context.l10n.unlockingSuccessful;
              body = null;
              break;
            case UnlockResult.accessDenied:
              title = context.l10n.unlockingFailed;
              body = context.l10n.unlockingFailedReason;
              break;
            case UnlockResult.deviceUnreachable:
              title = context.l10n.unlockingFailedDeviceUnreachable;
              body = context.l10n.unlockingFailedDeviceUnreachableReason;
              break;
            case UnlockResult.noConnection:
              title = context.l10n.unlockingNoConnection;
              body = context.l10n.unlockingNoConnectionReason;
              break;
            case UnlockResult.error:
              title = context.l10n.unlockingError;
              body = context.l10n.unlockingErrorReason;
              break;
          }

          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: ACColors.backgroundDimmed,
                title: Text(title, style: ACTextStyles.heading(ACColors.text)),
                content: body != null
                    ? SizedBox(
                        width: dialogWidth,
                        child: Text(
                          body,
                          style: ACTextStyles.smallerBodyText(ACColors.text),
                        ),
                      )
                    : null,
                actions: [
                  TextButton(
                    onPressed: () => context.pop(),
                    child: Text(
                      context.l10n.ok,
                      style: ACTextStyles.buttonText(ACColors.accent),
                    ),
                  ),
                ],
              );
            },
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ACColors.backgroundDimmed,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.nfc, color: ACColors.primaryShade, size: 32),
            const SizedBox(width: 8),
            Text(
              context.l10n.tapToScanNfcCard,
              style: ACTextStyles.buttonText(ACColors.primaryShade),
            ),
          ],
        ),
      ),
    );
  }
}
