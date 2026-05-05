import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/providers/devices_providers.dart';
import 'package:access_control/features/administration/devices_tab/widgets/device_info_banner.dart';
import 'package:access_control/features/administration/devices_tab/widgets/device_type_selector.dart';
import 'package:access_control/features/widgets/general_input_field.dart';
import 'package:access_control/features/widgets/general_loading_indicator.dart';
import 'package:access_control/features/widgets/general_modal_title.dart';
import 'package:access_control/features/widgets/modal_actions.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:access_control/models/device.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EditDeviceModal extends ConsumerStatefulWidget {
  const EditDeviceModal({super.key, required this.device});

  final Device device;

  @override
  ConsumerState<EditDeviceModal> createState() => _EditDeviceModalState();
}

class _EditDeviceModalState extends ConsumerState<EditDeviceModal> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late DeviceType _selectedDeviceType;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.device.name);
    _selectedDeviceType = widget.device.deviceType;
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
      title: GeneralModalTitle(text: context.l10n.editDevice),
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
                label: context.l10n.deviceName,
                hintText: context.l10n.enterDeviceName,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return context.l10n.deviceNameRequired;
                  }
                  if (value.trim().length < 2) {
                    return context.l10n.deviceNameTooShort;
                  }
                  return null;
                },
                autoFocus: true,
              ),
              const SizedBox(height: 16),
              DeviceTypeSelector(
                selectedDeviceType: _selectedDeviceType,
                onChanged: (value) {
                  setState(() {
                    _selectedDeviceType = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              DeviceInfoBanner(device: widget.device),
              const SizedBox(height: 16),
              if (_isLoading) LoadingRow(text: context.l10n.editingDevice),
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
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final newName = _nameController.text.trim();
    if (newName == widget.device.name &&
        _selectedDeviceType == widget.device.deviceType) {
      context.pop();
      return;
    }

    setState(() => _isLoading = true);

    try {
      final updatedDevice = Device(
        id: widget.device.id,
        name: newName,
        deviceType: _selectedDeviceType,
        buildingId: widget.device.buildingId,
        companyId: widget.device.companyId,
        createdUtc: widget.device.createdUtc,
        updatedUtc: DateTime.now(),
        isDeleted: widget.device.isDeleted,
      );

      await ref
          .read(devicesNotifierProvider.notifier)
          .updateDevice(updatedDevice);
      ref.invalidate(devicesForBuildingProvider(widget.device.buildingId));

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.l10n.updatedDeviceSuccessfully,
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
            content: Text(context.l10n.errorDuringUpdatingDevice),
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
