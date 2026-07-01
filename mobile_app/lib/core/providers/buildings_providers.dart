import 'package:access_control/core/notifiers/buildings_notifier.dart';
import 'package:access_control/core/providers/supabase_database_provider.dart';
import 'package:access_control/models/building.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final buildingsNotifierProvider =
    StateNotifierProvider<BuildingsNotifier, AsyncValue<List<Building>>>((ref) {
  return BuildingsNotifier(ref);
});

final buildingsByAreaIdProvider =
    FutureProvider.family<List<Building>, String>((ref, areaId) async {
  final db = ref.read(supabaseDatabaseProvider);
  return db.getBuildingsByAreaId(areaId);
});

final buildingByIdProvider =
    FutureProvider.family<Building?, String>((ref, id) async {
  final db = ref.read(supabaseDatabaseProvider);
  return db.getBuildingById(id);
});
