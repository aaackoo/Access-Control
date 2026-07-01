import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/providers/buildings_providers.dart';
import 'package:access_control/features/administration/buildings_tab/widgets/building_info_banner.dart';
import 'package:access_control/features/widgets/general_input_field.dart';
import 'package:access_control/features/widgets/general_loading_indicator.dart';
import 'package:access_control/features/widgets/general_modal_title.dart';
import 'package:access_control/features/widgets/modal_actions.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:access_control/models/building.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EditBuildingModal extends ConsumerStatefulWidget {
  const EditBuildingModal({super.key, required this.building});

  final Building building;

  @override
  ConsumerState<EditBuildingModal> createState() => _EditBuildingModalState();
}

class _EditBuildingModalState extends ConsumerState<EditBuildingModal> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.building.name);
    _addressController = TextEditingController(text: widget.building.address);
  }

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
      title: GeneralModalTitle(text: context.l10n.editBuilding),
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
              BuildingInfoBanner(building: widget.building),
              const SizedBox(height: 16),
              if (_isLoading) LoadingRow(text: context.l10n.editingBuilding),
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
    final newAddress = _addressController.text.trim();
    if (newName == widget.building.name &&
        newAddress == widget.building.address) {
      context.pop();
      return;
    }

    setState(() => _isLoading = true);

    try {
      final updatedBuilding = Building(
        id: widget.building.id,
        name: newName,
        address: newAddress,
        areaId: widget.building.areaId,
        companyId: widget.building.companyId,
        accessKeyIds: widget.building.accessKeyIds,
        createdUtc: widget.building.createdUtc,
        updatedUtc: DateTime.now(),
        isDeleted: widget.building.isDeleted,
      );

      await ref
          .read(buildingsNotifierProvider.notifier)
          .updateBuilding(updatedBuilding);
      ref.invalidate(buildingsByAreaIdProvider(widget.building.areaId));

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.updatedBuildingSuccessfully),
            backgroundColor: ACColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.errorDuringUpdatingBuilding),
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
