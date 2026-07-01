import 'package:access_control/core/providers/access_keys_providers.dart';
import 'package:access_control/core/providers/areas_providers.dart';
import 'package:access_control/core/providers/auth_provider.dart';
import 'package:access_control/core/providers/buildings_providers.dart';
import 'package:access_control/core/providers/devices_providers.dart';
import 'package:access_control/core/providers/supabase_database_provider.dart';
import 'package:access_control/models/area.dart';
import 'package:access_control/models/building.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentUserKeysProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final currentUser = await ref.watch(currentUserProvider.future);
  if (currentUser == null) return [];

  ref
    ..watch(devicesNotifierProvider)
    ..watch(buildingsNotifierProvider)
    ..watch(areasNotifierProvider)
    ..watch(accessKeysNotifierProvider);

  final db = ref.read(supabaseDatabaseProvider);
  final assignments = await db.getAccountKeyAssignments(currentUser.id);

  final result = <Map<String, dynamic>>[];

  for (final assignment in assignments) {
    final accessKey = assignment.accessKey;
    final building = await db.getBuildingById(accessKey.buildingId);
    if (building == null) continue;

    final area = await db.getAreaById(building.areaId);
    if (area == null) continue;

    final devices = await db.getDevicesByIds(accessKey.deviceIds);

    result.add({
      'key': accessKey,
      'assignment': assignment,
      'area': area,
      'building': building,
      'devices': devices,
      'deviceCount': devices.length,
    });
  }

  return result;
});

final userKeysStatsProvider = FutureProvider<Map<String, int>>((ref) async {
  final currentUser = await ref.watch(currentUserProvider.future);
  if (currentUser == null) return {};

  ref
    ..watch(devicesNotifierProvider)
    ..watch(buildingsNotifierProvider)
    ..watch(areasNotifierProvider)
    ..watch(accessKeysNotifierProvider);

  final db = ref.read(supabaseDatabaseProvider);
  final stats = await db.getUserStats(currentUser.id);
  return {
    'uniqueBuildings': stats['buildings_count'] ?? 0,
    'uniqueAreas': stats['areas_count'] ?? 0,
    'totalDevices': stats['devices_count'] ?? 0,
    'totalKeys': stats['access_keys_count'] ?? 0,
    'totalRoles': stats['roles_count'] ?? 0,
  };
});

final keySearchQueryProvider = StateProvider<String>((ref) => '');

final filteredUserKeysProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final allKeys = await ref.watch(currentUserKeysProvider.future);
  final searchQuery = ref.watch(keySearchQueryProvider).toLowerCase();

  if (searchQuery.isEmpty) return allKeys;

  return allKeys.where((keyDetail) {
    final building = keyDetail['building'] as Building;
    final area = keyDetail['area'] as Area;
    final keyName = (keyDetail['key'] as dynamic).name as String;

    return building.name.toLowerCase().contains(searchQuery) ||
        area.name.toLowerCase().contains(searchQuery) ||
        keyName.toLowerCase().contains(searchQuery);
  }).toList();
});
