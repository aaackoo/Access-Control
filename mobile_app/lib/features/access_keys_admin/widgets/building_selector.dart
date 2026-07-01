import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/providers/buildings_providers.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BuildingSelector extends ConsumerWidget {
  const BuildingSelector({
    super.key,
    required this.companyId,
    required this.selectedBuildingId,
    required this.onChanged,
  });

  final String companyId;
  final String? selectedBuildingId;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buildingsAsync = ref.watch(buildingsNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.building,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        buildingsAsync.when(
          data: (buildings) {
            final companyBuildings =
                buildings.where((b) => b.companyId == companyId).toList();

            if (companyBuildings.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Text(
                  context.l10n.addBuildingFirst,
                  style: const TextStyle(color: Colors.orange),
                ),
              );
            }

            return DropdownButtonFormField<String>(
              initialValue: selectedBuildingId,
              decoration: InputDecoration(
                hintText: context.l10n.selectBuilding,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: ACColors.primary),
                ),
                prefixIcon:
                    const Icon(Icons.apartment, color: ACColors.primary),
              ),
              items: companyBuildings.map((building) {
                return DropdownMenuItem<String>(
                  value: building.id,
                  child: Text(
                    building.name,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: onChanged,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return context.l10n.selectBuilding;
                }
                return null;
              },
            );
          },
          loading: () => const LinearProgressIndicator(),
          error: (error, stack) => Text(context.l10n.errorLoadingData),
        ),
      ],
    );
  }
}
