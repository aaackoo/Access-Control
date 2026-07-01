import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/providers/buildings_providers.dart';
import 'package:access_control/features/widgets/general_input_field.dart';
import 'package:access_control/features/widgets/general_loading_indicator.dart';
import 'package:access_control/features/widgets/general_modal_title.dart';
import 'package:access_control/features/widgets/modal_actions.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:access_control/models/building.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AddBuildingModal extends ConsumerStatefulWidget {
  const AddBuildingModal({
    super.key,
    required this.companyId,
    required this.areaId,
  });

  final String companyId;
  final String areaId;

  @override
  ConsumerState<AddBuildingModal> createState() => _AddBuildingModalState();
}

class _AddBuildingModalState extends ConsumerState<AddBuildingModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final dialogWidth =
        screenSize.width * 0.9 > 500 ? 500.0 : screenSize.width * 0.9;

    return AlertDialog(
      title: GeneralModalTitle(
        text: context.l10n.addBuilding,
        icon: Icons.apartment,
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
                icon: Icons.apartment,
                label: context.l10n.buildingName,
                hintText: context.l10n.enterBuildingName,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return context.l10n.buildingNameRequired;
                  }
                  if (value.trim().length < 2) {
                    return context.l10n.buildingNameTooShort;
                  }
                  return null;
                },
                autoFocus: true,
              ),
              const SizedBox(height: 16),
              GeneralInputField(
                controller: _addressController,
                icon: Icons.location_on_outlined,
                label: context.l10n.address,
                hintText: context.l10n.enterAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return context.l10n.addressRequired;
                  }
                  if (value.trim().length < 5) {
                    return context.l10n.addressTooShort;
                  }
                  return null;
                },
                onSubmit: _handleSubmit,
                minLines: 1,
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              if (_isLoading) LoadingRow(text: context.l10n.addingBuilding),
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
      final building = Building(
        id: '',
        name: _nameController.text.trim(),
        address: _addressController.text.trim(),
        areaId: widget.areaId,
        companyId: widget.companyId,
        accessKeyIds: [],
        createdUtc: DateTime.now(),
        updatedUtc: DateTime.now(),
        isDeleted: false,
      );

      await ref.read(buildingsNotifierProvider.notifier).addBuilding(building);
      ref.invalidate(buildingsByAreaIdProvider(widget.areaId));

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.addedBuildingSuccessfully),
            backgroundColor: ACColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.errorDuringAddingBuilding),
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
