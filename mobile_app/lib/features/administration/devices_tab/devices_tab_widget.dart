import 'package:access_control/core/providers/state_management_providers.dart';
import 'package:access_control/features/administration/devices_tab/widgets/devices_header.dart';
import 'package:access_control/features/administration/devices_tab/widgets/devices_list.dart';
import 'package:access_control/features/widgets/general_empty_state.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DevicesTabWidget extends ConsumerWidget {
  const DevicesTabWidget({
    super.key,
    required this.onChangeTab,
  });

  final VoidCallback onChangeTab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedBuilding = ref.watch(selectedBuildingProvider);

    return Column(
      children: [
        DevicesHeader(
          selectedBuilding: selectedBuilding,
        ),
        Expanded(
          child: selectedBuilding == null
              ? GeneralEmptyState(
                  icon: Icons.devices_outlined,
                  title: context.l10n.selectDevice,
                  subtitle: context.l10n.selectBuildingFirst,
                )
              : DevicesList(selectedBuilding: selectedBuilding),
        ),
      ],
    );
  }
}
