import 'package:access_control/core/providers/buildings_providers.dart';
import 'package:access_control/features/widgets/general_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BuildingsHeader extends ConsumerWidget {
  const BuildingsHeader({
    super.key,
    required this.selectedArea,
  });

  final String? selectedArea;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final area = selectedArea;
    final buildingsAsync = area != null
        ? ref.watch(buildingsByAreaIdProvider(area))
        : const AsyncValue.data(<dynamic>[]);
    return GeneralHeader(
      async: buildingsAsync,
      icon: Icons.location_city_outlined,
      type: HeaderType.building,
    );
  }
}
