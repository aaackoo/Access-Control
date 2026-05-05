import 'package:access_control/core/providers/auth_provider.dart';
import 'package:access_control/core/providers/supabase_database_provider.dart';
import 'package:access_control/models/building.dart';
import 'package:access_control/models/device.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final availableBuildingsProvider = FutureProvider<List<Building>>((ref) async {
  final currentUser = await ref.watch(currentUserProvider.future);
  if (currentUser == null) return [];

  final db = ref.read(supabaseDatabaseProvider);

  final areas = await db.getAreasByCompanyId(currentUser.companyId);
  final availableBuildings = <Building>[];

  for (final area in areas) {
    final buildings = await db.getBuildingsByAreaId(area.id);
    availableBuildings.addAll(buildings);
  }

  return availableBuildings;
});

final selectedBuildingControlProvider = StateProvider<Building?>((ref) => null);

final buildingDevicesProvider = FutureProvider<List<Device>>((ref) async {
  final selectedBuilding = ref.watch(selectedBuildingControlProvider);
  if (selectedBuilding == null) return [];

  final db = ref.read(supabaseDatabaseProvider);
  return db.getDevicesByBuildingId(selectedBuilding.id);
});

final deviceFilterProvider = StateProvider<String>((ref) => '');

final filteredBuildingDevicesProvider =
    FutureProvider<List<Device>>((ref) async {
  final devices = await ref.watch(buildingDevicesProvider.future);
  final filter = ref.watch(deviceFilterProvider).toLowerCase();

  if (filter.isEmpty) return devices;

  return devices
      .where(
        (device) => device.name.toLowerCase().contains(filter),
      )
      .toList();
});
