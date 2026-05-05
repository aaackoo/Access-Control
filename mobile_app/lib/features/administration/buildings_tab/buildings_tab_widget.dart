import 'package:access_control/core/providers/state_management_providers.dart';
import 'package:access_control/features/administration/buildings_tab/widgets/buildings_header.dart';
import 'package:access_control/features/administration/buildings_tab/widgets/buildings_list.dart';
import 'package:access_control/features/widgets/general_empty_state.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BuildingsTabWidget extends ConsumerWidget {
  const BuildingsTabWidget({
    super.key,
    required this.onChangeTab,
  });

  final VoidCallback onChangeTab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedArea = ref.watch(selectedAreaProvider);
    final selectedBuilding = ref.watch(selectedBuildingProvider);

    return Column(
      children: [
        BuildingsHeader(
          selectedArea: selectedArea,
        ),
        Expanded(
          child: selectedArea == null
              ? GeneralEmptyState(
                  icon: Icons.apartment_outlined,
                  title: context.l10n.selectBuilding,
                  subtitle: context.l10n.selectAreaFirst,
                )
              : BuildingsList(
                  selectedArea: selectedArea,
                  selectedBuilding: selectedBuilding,
                  onChangeTab: onChangeTab,
                ),
        ),
      ],
    );
  }
}
