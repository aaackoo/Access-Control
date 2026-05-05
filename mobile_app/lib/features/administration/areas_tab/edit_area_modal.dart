import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/providers/areas_providers.dart';
import 'package:access_control/features/administration/areas_tab/widgets/area_info_banner.dart';
import 'package:access_control/features/widgets/general_input_field.dart';
import 'package:access_control/features/widgets/general_loading_indicator.dart';
import 'package:access_control/features/widgets/general_modal_title.dart';
import 'package:access_control/features/widgets/modal_actions.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:access_control/models/area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EditAreaModal extends ConsumerStatefulWidget {
  const EditAreaModal({super.key, required this.area});

  final Area area;

  @override
  ConsumerState<EditAreaModal> createState() => _EditAreaModalState();
}

class _EditAreaModalState extends ConsumerState<EditAreaModal> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _locationController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.area.name);
    _locationController = TextEditingController(text: widget.area.location);
  }

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
      title: GeneralModalTitle(text: context.l10n.editArea),
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
              AreaInfoBanner(area: widget.area),
              const SizedBox(height: 16),
              if (_isLoading) LoadingRow(text: context.l10n.editingArea),
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
    final newLocation = _locationController.text.trim();
    if (newName == widget.area.name && newLocation == widget.area.location) {
      context.pop();
      return;
    }

    setState(() => _isLoading = true);

    try {
      final updatedArea = Area(
        id: widget.area.id,
        name: newName,
        location: newLocation,
        companyId: widget.area.companyId,
        createdUtc: widget.area.createdUtc,
        updatedUtc: DateTime.now(),
        isDeleted: widget.area.isDeleted,
      );

      await ref.read(areasNotifierProvider.notifier).updateArea(updatedArea);
      ref.invalidate(areasByCompanyIdProvider(widget.area.companyId));

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.updatedAreaSuccessfully),
            backgroundColor: ACColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.errorDuringUpdatingArea),
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
