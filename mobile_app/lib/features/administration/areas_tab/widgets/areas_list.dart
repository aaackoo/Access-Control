import 'package:access_control/core/providers/areas_providers.dart';
import 'package:access_control/features/administration/areas_tab/widgets/area_list_tile.dart';
import 'package:access_control/features/widgets/general_empty_state.dart';
import 'package:access_control/features/widgets/general_error_state.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AreasList extends ConsumerWidget {
  const AreasList({
    super.key,
    required this.selectedCompany,
    required this.selectedArea,
    required this.onChangeTab,
  });

  final String selectedCompany;
  final String? selectedArea;
  final VoidCallback onChangeTab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final areasAsync = ref.watch(areasByCompanyIdProvider(selectedCompany));

    return areasAsync.when(
      data: (areas) => RefreshIndicator(
        onRefresh: () async =>
            ref.invalidate(areasByCompanyIdProvider(selectedCompany)),
        child: areas.isEmpty
            ? CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    child: GeneralEmptyState(
                      icon: Icons.location_city_outlined,
                      title: context.l10n.noAreas,
                      subtitle: context.l10n.companyHasNoAreas,
                    ),
                  ),
                ],
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: areas.length,
                itemBuilder: (context, index) {
                  return AreaListTile(
                    area: areas[index],
                    isSelected: selectedArea == areas[index].id,
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
