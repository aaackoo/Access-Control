import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/providers/areas_providers.dart';
import 'package:access_control/features/widgets/general_input_field.dart';
import 'package:access_control/features/widgets/general_loading_indicator.dart';
import 'package:access_control/features/widgets/general_modal_title.dart';
import 'package:access_control/features/widgets/modal_actions.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:access_control/models/area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AddAreaModal extends ConsumerStatefulWidget {
  const AddAreaModal({
    super.key,
    required this.companyId,
  });

  final String companyId;

  @override
  ConsumerState<AddAreaModal> createState() => _AddAreaModalState();
}

class _AddAreaModalState extends ConsumerState<AddAreaModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final dialogWidth =
        screenSize.width * 0.9 > 500 ? 500.0 : screenSize.width * 0.9;

    return AlertDialog(
      title: GeneralModalTitle(
        text: context.l10n.addArea,
        icon: Icons.location_city,
      ),
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
                icon: Icons.location_city_outlined,
                label: context.l10n.areaName,
                hintText: context.l10n.enterAreaName,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return context.l10n.areaNameRequired;
                  }
                  if (value.trim().length < 2) {
                    return context.l10n.areaNameTooShort;
                  }
                  return null;
                },
                autoFocus: true,
              ),
              const SizedBox(height: 16),
              GeneralInputField(
                controller: _locationController,
                icon: Icons.place,
                label: context.l10n.location,
                hintText: context.l10n.enterLocation,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return context.l10n.locationRequired;
                  }
                  if (value.trim().length < 2) {
                    return context.l10n.locationTooShort;
                  }
                  return null;
                },
                onSubmit: _handleSubmit,
              ),
              const SizedBox(height: 16),
              if (_isLoading) LoadingRow(text: context.l10n.addingArea),
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

    setState(() => _isLoading = true);

    try {
      final area = Area(
        id: '',
        name: _nameController.text.trim(),
        location: _locationController.text.trim(),
        companyId: widget.companyId,
        createdUtc: DateTime.now(),
        updatedUtc: DateTime.now(),
        isDeleted: false,
      );

      await ref.read(areasNotifierProvider.notifier).addArea(area);
      ref.invalidate(areasByCompanyIdProvider(widget.companyId));

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.addedAreaSuccessfully),
            backgroundColor: ACColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.errorDuringAddingArea),
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
