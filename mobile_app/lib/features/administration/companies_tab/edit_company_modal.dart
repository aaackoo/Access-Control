import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/providers/companies_providers.dart';
import 'package:access_control/features/administration/companies_tab/widgets/company_info_banner.dart';
import 'package:access_control/features/widgets/general_input_field.dart';
import 'package:access_control/features/widgets/general_loading_indicator.dart';
import 'package:access_control/features/widgets/general_modal_title.dart';
import 'package:access_control/features/widgets/modal_actions.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:access_control/models/company.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EditCompanyModal extends ConsumerStatefulWidget {
  const EditCompanyModal({super.key, required this.company});

  final Company company;

  @override
  ConsumerState<EditCompanyModal> createState() => _EditCompanyModalState();
}

class _EditCompanyModalState extends ConsumerState<EditCompanyModal> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.company.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final dialogWidth =
        screenSize.width * 0.9 > 500 ? 500.0 : screenSize.width * 0.9;

    return AlertDialog(
      backgroundColor: ACColors.backgroundDimmed,
      title: GeneralModalTitle(text: context.l10n.editCompany),
      content: SizedBox(
        width: dialogWidth,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GeneralInputField(
                controller: _nameController,
                icon: Icons.business_outlined,
                label: context.l10n.companyName,
                hintText: context.l10n.enterCompanyName,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return context.l10n.companyNameRequired;
                  }
                  if (value.trim().length < 2) {
                    return context.l10n.companyNameTooShort;
                  }
                  return null;
                },
                autoFocus: true,
                onSubmit: _handleSubmit,
              ),
              const SizedBox(height: 16),
              CompanyInfoBanner(company: widget.company),
              const SizedBox(height: 16),
              if (_isLoading) LoadingRow(text: context.l10n.editingCompany),
            ],
          ),
        ),
      ),
      actions: [
        ModalActions(
          isLoading: _isLoading,
          onCancel: () => context.pop(),
          onSubmit: _handleSubmit,
        ),
      ],
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final newName = _nameController.text.trim();
    if (newName == widget.company.name) {
      context.pop();
      return;
    }

    setState(() => _isLoading = true);

    try {
      final updatedCompany = Company(
        id: widget.company.id,
        name: newName,
        createdUtc: widget.company.createdUtc,
        updatedUtc: DateTime.now(),
        isDeleted: widget.company.isDeleted,
      );

      await ref
          .read(companiesNotifierProvider.notifier)
          .updateCompany(updatedCompany);

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.l10n.updatedCompanySuccessfully,
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
            content: Text(context.l10n.errorDuringUpdatingCompany),
            backgroundColor: ACColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
