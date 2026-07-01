import 'package:access_control/core/app_bars/popup_appbar.dart';
import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/constants/ac_text_styles.dart';
import 'package:access_control/core/providers/access_keys_providers.dart';
import 'package:access_control/core/providers/accounts_providers.dart';
import 'package:access_control/features/accounts/widgets/access_rights_card.dart';
import 'package:access_control/features/accounts/widgets/account_info_card.dart';
import 'package:access_control/features/accounts/widgets/account_profile_card.dart';
import 'package:access_control/features/widgets/general_error_state.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:access_control/models/account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AccountDetailPage extends ConsumerWidget {
  const AccountDetailPage({
    super.key,
    required this.accountId,
  });

  final String accountId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountAsync = ref.watch(accountByIdProvider(accountId));

    return Scaffold(
      appBar: PopupAppbar(title: context.l10n.myProfileTitle),
      body: accountAsync.when(
        data: (account) {
          if (account == null) {
            return Center(child: Text(context.l10n.accountNotFound));
          }
          return _AccountDetailContent(
            account: account,
            accountId: accountId,
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => GeneralErrorState(
          error: error,
          customTitle: context.l10n.errorDuringLoadingAccount,
        ),
      ),
    );
  }
}

class _AccountDetailContent extends ConsumerStatefulWidget {
  const _AccountDetailContent({
    required this.account,
    required this.accountId,
  });

  final Account account;
  final String accountId;

  @override
  ConsumerState<_AccountDetailContent> createState() =>
      _AccountDetailContentState();
}

class _AccountDetailContentState extends ConsumerState<_AccountDetailContent> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        ref
          ..invalidate(accountByIdProvider(widget.accountId))
          ..invalidate(accessKeysByAccountIdProvider(widget.accountId));
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AccountProfileCard(account: widget.account),
            const SizedBox(height: 16),
            AccountInfoCard(account: widget.account),
            const SizedBox(height: 16),
            AccessRightsCard(account: widget.account),
            const SizedBox(height: 24),
            _DeleteAccountButton(
              isDeleting: _isDeleting,
              onDelete: _handleDelete,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleDelete() async {
    final confirmed = await _showDeleteConfirmation();
    if (!confirmed) return;

    setState(() => _isDeleting = true);

    try {
      await ref
          .read(accountsNotifierProvider.notifier)
          .deleteAccount(widget.accountId);

      if (mounted) {
        ref
          ..invalidate(accountsNotifierProvider)
          ..invalidate(accountsByCompanyIdProvider(widget.account.companyId));

        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.l10n.accountRemovedSuccessfully(widget.account.email),
            ),
            backgroundColor: ACColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.errorDuringRemovingAccount),
            backgroundColor: ACColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isDeleting = false);
    }
  }

  Future<bool> _showDeleteConfirmation() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          context.l10n.removeAccount,
          style: ACTextStyles.appBarTitle(ACColors.text),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.removeAccountConfirmation,
              style: ACTextStyles.bodyText(ACColors.text),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ACColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_outlined,
                    color: ACColors.error,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      context.l10n.thisActionCannotBeUndone,
                      style: ACTextStyles.smallerBodyText(ACColors.error),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: Text(
              context.l10n.cancel,
              style: ACTextStyles.bodyText(ACColors.text),
            ),
          ),
          TextButton(
            onPressed: () => context.pop(true),
            style: TextButton.styleFrom(foregroundColor: ACColors.error),
            child: Text(
              context.l10n.remove,
              style: ACTextStyles.bodyText(ACColors.error),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}

class _DeleteAccountButton extends StatelessWidget {
  const _DeleteAccountButton({
    required this.isDeleting,
    required this.onDelete,
  });

  final bool isDeleting;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: isDeleting ? null : onDelete,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: const BorderSide(color: ACColors.error),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        icon: isDeleting
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: ACColors.error,
                ),
              )
            : const Icon(Icons.delete_outline, color: ACColors.error),
        label: Text(
          isDeleting ? context.l10n.removing : context.l10n.removeAccount,
          style: ACTextStyles.bodyText(ACColors.error),
        ),
      ),
    );
  }
}
