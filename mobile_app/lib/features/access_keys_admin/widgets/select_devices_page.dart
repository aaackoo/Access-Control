import 'package:access_control/core/app_bars/popup_appbar.dart';
import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/constants/ac_text_styles.dart';
import 'package:access_control/core/providers/devices_providers.dart';
import 'package:access_control/features/access_keys_admin/providers/access_key_form_provider.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SelectDevicesPage extends ConsumerStatefulWidget {
  const SelectDevicesPage({
    super.key,
    required this.buildingId,
    required this.initialSelectedIds,
  });

  final String buildingId;
  final Set<String> initialSelectedIds;

  @override
  ConsumerState<SelectDevicesPage> createState() => _SelectDevicesPageState();
}

class _SelectDevicesPageState extends ConsumerState<SelectDevicesPage> {
  late Set<String> _selectedDeviceIds;

  @override
  void initState() {
    super.initState();
    _selectedDeviceIds = Set.from(widget.initialSelectedIds);
  }

  @override
  Widget build(BuildContext context) {
    final devicesAsync =
        ref.watch(devicesForBuildingProvider(widget.buildingId));

    return Scaffold(
      backgroundColor: ACColors.background,
      appBar: PopupAppbar(title: context.l10n.selectDevices),
      body: devicesAsync.when(
        data: (devices) {
          if (devices.isEmpty) {
            return Center(
              child: Text(
                context.l10n.noDevicesForSelectedCompany,
                style: const TextStyle(color: ACColors.textDim),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: devices.length,
                  itemBuilder: (context, index) {
                    final device = devices[index];
                    final isSelected = _selectedDeviceIds.contains(device.id);

                    return CheckboxListTile(
                      title: Text(
                        device.name,
                        style: ACTextStyles.bodyText(ACColors.text),
                      ),
                      value: isSelected,
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            _selectedDeviceIds.add(device.id);
                          } else {
                            _selectedDeviceIds.remove(device.id);
                          }
                        });
                      },
                      activeColor: ACColors.primary,
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: ACColors.background,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Vybrané: ${_selectedDeviceIds.length}',
                      style: ACTextStyles.bodyText(ACColors.text),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ref
                            .read(accessKeyFormProvider.notifier)
                            .setSelectedDevices(_selectedDeviceIds);
                        context.pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ACColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        context.l10n.confirm,
                        style: ACTextStyles.bodyText(Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(context.l10n.errorLoadingData),
        ),
      ),
    );
  }
}
