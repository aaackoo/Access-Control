import 'package:access_control/core/app_bars/popup_appbar.dart';
import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/constants/ac_text_styles.dart';
import 'package:access_control/core/providers/accounts_providers.dart';
import 'package:access_control/features/widgets/general_input_field.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:access_control/models/account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AddAccountPage extends ConsumerStatefulWidget {
  const AddAccountPage({
    super.key,
    required this.companyId,
  });

  final String companyId;

  @override
  ConsumerState<AddAccountPage> createState() => _AddAccountPageState();
}

class _AddAccountPageState extends ConsumerState<AddAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  AccountRole _selectedRole = AccountRole.user;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final newAccount = Account(
        id: '',
        email: _emailController.text.trim(),
        role: _selectedRole,
        companyId: widget.companyId,
        createdUtc: DateTime.now(),
        updatedUtc: DateTime.now(),
      );

      await ref.read(accountsNotifierProvider.notifier).addAccount(newAccount);

      if (mounted) {
        ref.invalidate(accountsByCompanyIdProvider(widget.companyId));
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.accountCreatedSuccessfully),
            backgroundColor: ACColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.errorDuringAccountCreation),
            backgroundColor: ACColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ACColors.background,
      appBar: PopupAppbar(title: context.l10n.addAccount),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GeneralInputField(
                  controller: _emailController,
                  icon: Icons.email_outlined,
                  label: context.l10n.emailLabel,
                  hintText: context.l10n.emailHint,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.l10n.emailIsMandatory;
                    }
                    if (!value.contains('@')) {
                      return context.l10n.enterCorrectEmail;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                _RoleSelector(
                  selectedRole: _selectedRole,
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value;
                    });
                  },
                ),
                const SizedBox(height: 24),
                const _PasswordInfoBanner(),
                const SizedBox(height: 32),
                _PageActions(
                  isLoading: _isLoading,
                  onCancel: () => context.pop(),
                  onSubmit: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleSelector extends StatelessWidget {
  const _RoleSelector({
    required this.selectedRole,
    required this.onChanged,
  });

  final AccountRole selectedRole;
  final ValueChanged<AccountRole> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          context.l10n.accountRole,
          style: ACTextStyles.smallerBodyText(
            ACColors.text,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<AccountRole>(
          initialValue: selectedRole,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            prefixIcon: Icon(
              Icons.person,
              color: ACColors.text,
            ),
          ),
          items: AccountRole.values.map((role) {
            return DropdownMenuItem(
              value: role,
              child: _RoleDropdownItem(role: role),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
        ),
      ],
    );
  }
}

class _RoleDropdownItem extends StatelessWidget {
  const _RoleDropdownItem({required this.role});

  final AccountRole role;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: role.color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          accountRoleToString(context, role),
          style: ACTextStyles.bodyText(
            ACColors.text,
          ),
        ),
      ],
    );
  }
}

class _PasswordInfoBanner extends StatelessWidget {
  const _PasswordInfoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ACColors.backgroundAccent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: ACColors.text, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              context.l10n.addAccountPasswordHint,
              style: ACTextStyles.smallerBodyText(
                ACColors.text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageActions extends StatelessWidget {
  const _PageActions({
    required this.isLoading,
    required this.onCancel,
    required this.onSubmit,
  });

  final bool isLoading;
  final VoidCallback onCancel;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: isLoading ? null : onSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: ACColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(
                  context.l10n.addAccount,
                  style: ACTextStyles.bodyText(Colors.white),
                ),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: isLoading ? null : onCancel,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            side: const BorderSide(color: ACColors.text),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            context.l10n.cancel,
            style: ACTextStyles.bodyText(ACColors.text),
          ),
        ),
      ],
    );
  }
}
