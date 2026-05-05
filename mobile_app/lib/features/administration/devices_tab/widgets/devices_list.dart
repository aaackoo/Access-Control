import 'package:access_control/core/providers/devices_providers.dart';
import 'package:access_control/features/administration/devices_tab/widgets/device_list_tile.dart';
import 'package:access_control/features/widgets/general_empty_state.dart';
import 'package:access_control/features/widgets/general_error_state.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DevicesList extends ConsumerWidget {
  const DevicesList({super.key, required this.selectedBuilding});

  final String selectedBuilding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devicesAsync =
        ref.watch(devicesForBuildingProvider(selectedBuilding));

    return devicesAsync.when(
      data: (devices) => RefreshIndicator(
        onRefresh: () async =>
            ref.invalidate(devicesForBuildingProvider(selectedBuilding)),
        child: devices.isEmpty
            ? CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    child: GeneralEmptyState(
                      icon: Icons.devices_outlined,
                      title: context.l10n.noDevices,
                      subtitle: context.l10n.buildingHasNoDevices,
                    ),
                  ),
                ],
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  return DeviceListTile(device: devices[index]);
                },
              ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => GeneralErrorState(
        error: error,
      ),
    );
  }
}
