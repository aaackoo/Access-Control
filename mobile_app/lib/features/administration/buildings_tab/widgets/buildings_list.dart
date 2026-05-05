import 'package:access_control/core/providers/buildings_providers.dart';
import 'package:access_control/features/administration/buildings_tab/widgets/building_list_tile.dart';
import 'package:access_control/features/widgets/general_empty_state.dart';
import 'package:access_control/features/widgets/general_error_state.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BuildingsList extends ConsumerWidget {
  const BuildingsList({
    super.key,
    required this.selectedArea,
    required this.selectedBuilding,
    required this.onChangeTab,
  });

  final String selectedArea;
  final String? selectedBuilding;
  final VoidCallback onChangeTab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buildingsAsync = ref.watch(buildingsByAreaIdProvider(selectedArea));

    return buildingsAsync.when(
      data: (buildings) => RefreshIndicator(
        onRefresh: () async =>
            ref.invalidate(buildingsByAreaIdProvider(selectedArea)),
        child: buildings.isEmpty
            ? CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    child: GeneralEmptyState(
                      icon: Icons.apartment_outlined,
                      title: context.l10n.noBuildings,
                      subtitle: context.l10n.areaHasNoBuildings,
                    ),
                  ),
                ],
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: buildings.length,
                itemBuilder: (context, index) {
                  return BuildingListTile(
                    building: buildings[index],
                    isSelected: selectedBuilding == buildings[index].id,
                    onChangeTab: onChangeTab,
                  );
                },
              ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => GeneralErrorState(error: error),
    );
  }
}
