import 'package:access_control/core/providers/state_management_providers.dart';
import 'package:access_control/features/administration/areas_tab/widgets/areas_header.dart';
import 'package:access_control/features/administration/areas_tab/widgets/areas_list.dart';
import 'package:access_control/features/widgets/general_empty_state.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AreasTabWidget extends ConsumerWidget {
  const AreasTabWidget({
    super.key,
    required this.onChangeTab,
  });

  final VoidCallback onChangeTab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCompany = ref.watch(selectedCompanyProvider);
    final selectedArea = ref.watch(selectedAreaProvider);

    return Column(
      children: [
        AreasHeader(
          selectedCompany: selectedCompany,
        ),
        Expanded(
          child: selectedCompany == null
              ? GeneralEmptyState(
                  icon: Icons.location_city_outlined,
                  title: context.l10n.selectArea,
                  subtitle: context.l10n.selectCompanyFirst,
                )
              : AreasList(
                  selectedCompany: selectedCompany,
                  selectedArea: selectedArea,
                  onChangeTab: onChangeTab,
                ),
        ),
      ],
    );
  }
}
