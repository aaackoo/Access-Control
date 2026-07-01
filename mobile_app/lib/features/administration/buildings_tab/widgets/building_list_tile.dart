import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/constants/ac_text_styles.dart';
import 'package:access_control/core/providers/buildings_providers.dart';
import 'package:access_control/core/providers/state_management_providers.dart';
import 'package:access_control/features/administration/buildings_tab/edit_building_modal.dart';
import 'package:access_control/features/widgets/modal_actions.dart';
import 'package:access_control/models/building.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BuildingListTile extends ConsumerWidget {
  const BuildingListTile({
    super.key,
    required this.building,
    required this.isSelected,
    required this.onChangeTab,
  });

  final Building building;
  final bool isSelected;
  final VoidCallback onChangeTab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isSelected ? 4 : 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isSelected ? ACColors.backgroundAccent : null,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          ref.read(selectedBuildingProvider.notifier).state = building.id;
          onChangeTab();
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient:
                      isSelected ? null : ACGradients.accentPrimaryGradient,
                  color: isSelected ? ACColors.accent : null,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: ACColors.backgroundAccent,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child:
                    const Icon(Icons.apartment, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      building.name,
                      style: ACTextStyles.bodyText(ACColors.text).copyWith(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: ACColors.textDim,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            building.address,
                            style:
                                ACTextStyles.smallerBodyText(ACColors.textDim),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: Icon(Icons.check_circle, color: ACColors.accent),
                ),
              PopupMenuButton(
                itemBuilder: (context) => [
                  editMenuItem(
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) =>
                          EditBuildingModal(building: building),
                    ),
                    context: context,
                  ),
                  deleteMenuItem(
                    onTap: () async {
                      await ref
                          .read(buildingsNotifierProvider.notifier)
                          .deleteBuilding(building.id);
                      ref.invalidate(
                        buildingsByAreaIdProvider(building.areaId),
                      );
                    },
                    context: context,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
