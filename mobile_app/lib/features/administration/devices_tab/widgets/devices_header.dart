import 'package:access_control/core/providers/devices_providers.dart';
import 'package:access_control/features/widgets/general_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DevicesHeader extends ConsumerWidget {
  const DevicesHeader({
    super.key,
    required this.selectedBuilding,
  });

  final String? selectedBuilding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final building = selectedBuilding;
    final devicesAsync = building != null
        ? ref.watch(devicesForBuildingProvider(building))
        : const AsyncValue.data(<dynamic>[]);
    return GeneralHeader(
      async: devicesAsync,
      icon: Icons.devices_fold_outlined,
      type: HeaderType.device,
    );
  }
}
