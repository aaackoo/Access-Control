import 'package:access_control/core/app_bars/popup_appbar.dart';
import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/navigation/routes/routes.dart';
import 'package:access_control/core/providers/access_keys_providers.dart';
import 'package:access_control/core/providers/auth_provider.dart';
import 'package:access_control/features/access_keys_admin/providers/access_key_form_provider.dart';
import 'package:access_control/features/access_keys_admin/widgets/building_selector.dart';
import 'package:access_control/features/widgets/form_page_actions.dart';
import 'package:access_control/features/widgets/general_input_field.dart';
import 'package:access_control/features/widgets/general_loading_indicator.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:access_control/models/access_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AccessKeyFormPage extends ConsumerStatefulWidget {
  const AccessKeyFormPage({
    super.key,
    this.existingAccessKey,
  });

  final AccessKey? existingAccessKey;

  @override
  ConsumerState<AccessKeyFormPage> createState() => AccessKeyFormPageState();
}

class AccessKeyFormPageState extends ConsumerState<AccessKeyFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late String? _selectedBuildingId;
  late final Set<String> _selectedDeviceIds;
  bool _isLoading = false;

  bool get isEditMode => widget.existingAccessKey != null;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.existingAccessKey?.name ?? '');
    _selectedBuildingId = widget.existingAccessKey?.buildingId;
    _selectedDeviceIds = widget.existingAccessKey != null
        ? Set<String>.from(widget.existingAccessKey!.deviceIds)
        : {};
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final companyId = isEditMode
        ? widget.existingAccessKey!.companyId
        : ref.read(currentUserProvider).value?.companyId;

    if (companyId == null) {
      return Scaffold(
        appBar: PopupAppbar(title: context.l10n.error),
        body: Center(
          child: Text(context.l10n.errorNoCompanyId),
        ),
      );
    }

    return Scaffold(
      backgroundColor: ACColors.background,
      appBar: PopupAppbar(
        title: isEditMode
            ? context.l10n.editAccessKey
            : context.l10n.addNewAccessKey,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GeneralInputField(
                  controller: _nameController,
                  icon: Icons.admin_panel_settings_outlined,
                  label: context.l10n.accessKeyName,
                  hintText: context.l10n.enterAccessKeyName,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return context.l10n.accessKeyNameRequired;
                    }
                    if (value.trim().length < 2) {
                      return context.l10n.accessKeyNameTooShort;
                    }
                    return null;
                  },
                  autoFocus: true,
                ),
                const SizedBox(height: 24),
                BuildingSelector(
                  companyId: companyId,
                  selectedBuildingId: _selectedBuildingId,
                  onChanged: (value) {
                    setState(() {
                      _selectedBuildingId = value;
                      _selectedDeviceIds.clear();
                    });
                  },
                ),
                if (_selectedBuildingId != null) ...[
                  const SizedBox(height: 24),
                  _SelectionButton(
                    label: context.l10n.accessibleDevices,
                    selectedCount: _selectedDeviceIds.length,
                    onTap: () => _selectDevices(context),
                    icon: Icons.devices,
                  ),
                ],
                const SizedBox(height: 24),
                if (_isLoading)
                  LoadingRow(
                    text: isEditMode
                        ? context.l10n.editingAccessKey
                        : context.l10n.addingAccessKey,
                  ),
                if (!_isLoading)
                  FormPageActions(
                    onCancel: () => context.pop(),
                    onSubmit: () => _handleSubmit(companyId),
                    submitLabel: isEditMode
                        ? context.l10n.save
                        : context.l10n.addAccessKey,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSubmit(String companyId) async {
    if (!_formKey.currentState!.validate()) return;

    if (isEditMode) {
      final newName = _nameController.text.trim();
      final deviceIdsChanged = !_setEquals(
        _selectedDeviceIds,
        widget.existingAccessKey!.deviceIds.toSet(),
      );

      if (newName == widget.existingAccessKey!.name &&
          _selectedBuildingId == widget.existingAccessKey!.buildingId &&
          !deviceIdsChanged) {
        context.pop();
        return;
      }
    }

    setState(() => _isLoading = true);

    try {
      final accessKey = AccessKey(
        id: isEditMode ? widget.existingAccessKey!.id : '',
        name: _nameController.text.trim(),
        companyId: companyId,
        buildingId: _selectedBuildingId!,
        deviceIds: _selectedDeviceIds.toList(),
        createdUtc:
            isEditMode ? widget.existingAccessKey!.createdUtc : DateTime.now(),
        updatedUtc: DateTime.now(),
        isDeleted: isEditMode ? widget.existingAccessKey!.isDeleted : false,
      );

      if (isEditMode) {
        await ref
            .read(accessKeysNotifierProvider.notifier)
            .updateAccessKey(accessKey);
      } else {
        await ref
            .read(accessKeysNotifierProvider.notifier)
            .addAccessKey(accessKey);
      }

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditMode
                  ? context.l10n.accessKeyUpdatedSuccessfully
                  : context.l10n.accessKeyAddedSuccessfully,
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
            content: Text(
              isEditMode
                  ? context.l10n.accessKeyUpdateFailed
                  : context.l10n.accessKeyAdditionFailed,
            ),
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

  bool _setEquals<T>(Set<T> a, Set<T> b) {
    if (a.length != b.length) return false;
    return a.containsAll(b);
  }

  Future<void> _selectDevices(BuildContext context) async {
    ref
        .read(accessKeyFormProvider.notifier)
        .setSelectedDevices(_selectedDeviceIds);

    final routePath = isEditMode
        ? Routes.selectDevicesForEditPath(widget.existingAccessKey!.id)
        : Routes.selectDevicesForAddPath;

    await context.push(
      routePath,
      extra: {
        'buildingId': _selectedBuildingId!,
        'initialSelectedIds': _selectedDeviceIds,
      },
    );

    if (mounted) {
      setState(() {
        _selectedDeviceIds
          ..clear()
          ..addAll(ref.read(accessKeyFormProvider).selectedDeviceIds);
      });
    }
  }
}

class _SelectionButton extends StatelessWidget {
  const _SelectionButton({
    required this.label,
    required this.selectedCount,
    required this.onTap,
    required this.icon,
  });

  final String label;
  final int selectedCount;
  final VoidCallback onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: ACColors.text.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: ACColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(color: ACColors.text),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.l10n.selectedCount(selectedCount),
                    style: TextStyle(
                      color: ACColors.text.withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: ACColors.text.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}
