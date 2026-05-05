import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/providers/devices_providers.dart';
import 'package:access_control/core/providers/state_management_providers.dart';
import 'package:access_control/features/administration/devices_tab/widgets/device_type_selector.dart';
import 'package:access_control/features/widgets/general_input_field.dart';
import 'package:access_control/features/widgets/general_loading_indicator.dart';
import 'package:access_control/features/widgets/general_modal_title.dart';
import 'package:access_control/features/widgets/modal_actions.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:access_control/models/device.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum _CreationMode { single, bulk }

class AddDeviceModal extends ConsumerStatefulWidget {
  const AddDeviceModal({
    super.key,
    required this.companyId,
  });

  final String companyId;

  @override
  ConsumerState<AddDeviceModal> createState() => _AddDeviceModalState();
}

class _AddDeviceModalState extends ConsumerState<AddDeviceModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _countController = TextEditingController();
  final _padLengthController = TextEditingController(text: '3');
  DeviceType _selectedDeviceType = DeviceType.door;
  _CreationMode _mode = _CreationMode.single;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _countController.dispose();
    _padLengthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final dialogWidth =
        screenSize.width * 0.9 > 500 ? 500.0 : screenSize.width * 0.9;

    return AlertDialog(
      title: GeneralModalTitle(
        text: context.l10n.addDevice,
        icon: Icons.devices,
      ),
      contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
      insetPadding:
          const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
      content: SizedBox(
        width: dialogWidth,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.l10n.addMultipleDevices,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Switch(
                    value: _mode == _CreationMode.bulk,
                    onChanged: (value) {
                      setState(() {
                        _mode =
                            value ? _CreationMode.bulk : _CreationMode.single;
                      });
                    },
                    activeTrackColor: ACColors.primary.withValues(alpha: 0.5),
                    thumbColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return ACColors.primary;
                      }
                      return null;
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GeneralInputField(
                controller: _nameController,
                icon: Icons.devices_fold_outlined,
                label: _mode == _CreationMode.single
                    ? context.l10n.deviceName
                    : context.l10n.prefix,
                hintText: _mode == _CreationMode.single
                    ? context.l10n.enterDeviceName
                    : context.l10n.enterMultipleDevicesPrefix,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return _mode == _CreationMode.single
                        ? context.l10n.deviceNameRequired
                        : context.l10n.multipleDevicesPrefixRequired;
                  }
                  if (value.trim().length < 2) {
                    return context.l10n.deviceNameTooShort;
                  }
                  return null;
                },
                autoFocus: true,
              ),
              if (_mode == _CreationMode.bulk) ...[
                const SizedBox(height: 16),
                GeneralInputField(
                  controller: _countController,
                  icon: Icons.numbers,
                  label: context.l10n.deviceCount,
                  hintText: context.l10n.enterDeviceCount,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return context.l10n.deviceCountRequired;
                    }
                    final count = int.tryParse(value);
                    if (count == null || count < 1) {
                      return context.l10n.deviceCountMustBePositive;
                    }
                    if (count > 100) {
                      return context.l10n.deviceCountMax100;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                GeneralInputField(
                  controller: _padLengthController,
                  icon: Icons.format_list_numbered,
                  label: context.l10n.indexingLength,
                  hintText: context.l10n.indexingLengthHint,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return context.l10n.indexingLengthRequired;
                    }
                    final padLength = int.tryParse(value);
                    if (padLength == null || padLength < 1 || padLength > 5) {
                      return context.l10n.indexingLengthMustBeBetween1And5;
                    }
                    return null;
                  },
                ),
              ],
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
              if (_isLoading)
                LoadingRow(
                  text: _mode == _CreationMode.single
                      ? context.l10n.addingDevice
                      : context.l10n.addingMultipleDevices,
                ),
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
      final selectedBuilding = ref.read(selectedBuildingProvider);
      if (selectedBuilding == null) {
        throw Exception(context.l10n.noBuildingSelected);
      }

      if (_mode == _CreationMode.single) {
        final device = Device(
          id: '',
          name: _nameController.text.trim(),
          deviceType: _selectedDeviceType,
          companyId: widget.companyId,
          buildingId: selectedBuilding,
          createdUtc: DateTime.now(),
          updatedUtc: DateTime.now(),
          isDeleted: false,
        );

        await ref.read(devicesNotifierProvider.notifier).addDevice(device);

        if (mounted) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.addedDeviceSuccessfully),
              backgroundColor: ACColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        final count = int.parse(_countController.text);
        final padLength = int.parse(_padLengthController.text);
        final deviceTypeString =
            Device.getStringFromDeviceType(_selectedDeviceType);

        await ref.read(devicesNotifierProvider.notifier).addMultipleDevices(
              namePrefix: _nameController.text.trim(),
              buildingId: selectedBuilding,
              companyId: widget.companyId,
              deviceType: deviceTypeString,
              count: count,
              padLength: padLength,
            );

        if (mounted) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                context.l10n.addedXDevicesSuccessfully(
                  count,
                  _nameController.text.trim(),
                ),
              ),
              backgroundColor: ACColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }

      ref
        ..invalidate(
          devicesForBuildingProvider(ref.read(selectedBuildingProvider)!),
        )
        ..invalidate(devicesNotifierProvider);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.errorDuringAddingDevice),
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
