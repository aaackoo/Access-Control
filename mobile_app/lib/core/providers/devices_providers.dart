import 'package:access_control/core/notifiers/devices_notifier.dart';
import 'package:access_control/core/providers/supabase_database_provider.dart';
import 'package:access_control/models/device.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final devicesNotifierProvider =
    StateNotifierProvider<DevicesNotifier, AsyncValue<List<Device>>>((ref) {
  return DevicesNotifier(ref);
});

final devicesByIdsProvider =
    FutureProvider.family<List<Device>, List<String>>((ref, deviceIds) async {
  final db = ref.read(supabaseDatabaseProvider);
  return db.getDevicesByIds(deviceIds);
});

final deviceByIdProvider =
    FutureProvider.family<Device?, String>((ref, id) async {
  final db = ref.read(supabaseDatabaseProvider);
  return db.getDeviceById(id);
});

final devicesForBuildingProvider =
    FutureProvider.family<List<Device>, String>((ref, buildingId) async {
  final db = ref.read(supabaseDatabaseProvider);
  return db.getDevicesByBuildingId(buildingId);
});
